(function () {
  class PluginBase {
    constructor(name) {
      this.name = name;
    }

    setMessageHandler(callback) {
      this.messageHandler = callback;
    }

    onMessage(message) {
      if (this.messageHandler) {
        this.messageHandler(message);
      }
    }

    sendMessage(message) {
      Cloak.channel.postMessage(
        JSON.stringify({
          pluginName: this.name,
          payload: message,
        }),
      );
    }

    register() {
      if (this.registered) {
        return;
      }
      const pluginRegister =
        window.__CloakPluginsRegister && window.__CloakPluginsRegister[this.name];
      if (pluginRegister) {
        pluginRegister(this);
      }
    }
  }

  // IChannelMessage
  window.addEventListener(
    "message",
    function (event) {
      if (event.data === "Cloak__init_port__") {
        if (event.ports[0] !== null) {
          Cloak.channel = event.ports[0];

          Cloak.channel.onmessage = function (event) {
            const data = JSON.parse(event.data);

            const plugin = Cloak.plugins[data.pluginName];
            plugin.onMessage(data.payload);
          };
          window.document.dispatchEvent(new Event("CloakReady"));
        }
      }
    },
    { once: true },
  );

  // Keep this. What the bridge returns for an async ArkTS method is not a real promise:
  // a throw inside a .then() handler is swallowed and the derived object resolves to null.
  function adoptThenable(value) {
    if (value instanceof Promise) {
      return value;
    }
    if (
      value !== null &&
      (typeof value === "object" || typeof value === "function") &&
      typeof value.then === "function"
    ) {
      return new Promise((resolve, reject) => {
        value.then(resolve, reject);
      });
    }
    return value;
  }

  // A facade is needed because the injected host object's methods cannot be replaced in
  // place — defineProperty on them neither throws nor takes effect.
  function createPluginFacade(plugin) {
    // Usually empty: only InAppBrowser and Permission attach functions to the instance.
    // Not dead code.
    const localFunctions = new Set();
    const wrapped = new Map();

    return new Proxy(plugin, {
      get(target, prop) {
        const value = Reflect.get(target, prop);

        // These must stay unwrapped: their `this` has to be the facade, not the host
        // object. register() in particular hands `this` to the npm side.
        if (
          typeof value !== "function" ||
          localFunctions.has(prop) ||
          PluginBase.prototype[prop] === value
        ) {
          return value;
        }

        // Wrapping serves two purposes and both are required. Besides adopting the
        // thenable, Reflect.apply pins `this` to the host object: calling a bridge method
        // with the facade as `this` fails with "Javascript bridge method can't be invoked
        // on a non-injected object". That is why the sync base methods (getMetadata,
        // addEventListener, ...) have to be wrapped as well.
        if (!wrapped.has(prop)) {
          wrapped.set(prop, function (...args) {
            return adoptThenable(Reflect.apply(value, target, args));
          });
        }
        return wrapped.get(prop);
      },

      // Do not drop this trap, and do not pass `receiver` to Reflect.set. Both route the
      // write through the host object's defineProperty, which is a silent no-op, so the
      // npm side's `plugin.create = fn` would be lost without any error.
      set(target, prop, value) {
        if (typeof value === "function") {
          localFunctions.add(prop);
        }
        return Reflect.set(target, prop, value);
      },
    });
  }

  const PLUGIN_PREFIX = "_cloak_plugin_";
  const cloakPlugins = Object.keys(window).filter((key) => key.startsWith(PLUGIN_PREFIX));
  Cloak.plugins = {};
  Cloak.metadata = Cloak.getMetadata();
  Cloak.name = "Cloak";
  Cloak.registered = true;
  Object.setPrototypeOf(Cloak, PluginBase.prototype);

  cloakPlugins.forEach((pluginName) => {
    const newName = pluginName.substring(PLUGIN_PREFIX.length);

    const plugin = window[pluginName];
    plugin.name = newName;
    plugin.registered = false;

    plugin.metadata = plugin.getMetadata();

    Object.setPrototypeOf(plugin, PluginBase.prototype);

    // Must exist before register(): register() passes `this` to the npm side, which has
    // to end up with the same object as Cloak.plugins[name].
    const facade = createPluginFacade(plugin);
    Cloak.plugins[newName] = facade;

    facade.register();
  });
})();
