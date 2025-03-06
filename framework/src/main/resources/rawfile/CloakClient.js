(function () {
  window.addEventListener("message", function (event) {
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
  });

  const PLUGIN_PREFIX = "_cloak_plugin_";
  const cloakPlugins = Object.keys(window).filter((key) => key.startsWith(PLUGIN_PREFIX));
  Cloak.plugins = {};
  Cloak.metadata = Cloak.getMetadata();

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
        })
      );
    }

    clientRegister() {
      // todo: implement
    }
  }

  cloakPlugins.forEach((pluginName) => {
    const newName = pluginName.substring(PLUGIN_PREFIX.length);

    const plugin = window[pluginName];
    plugin.name = newName;
    Cloak.plugins[newName] = plugin;

    plugin.metadata = Cloak.plugins[newName].getMetadata();

    Object.setPrototypeOf(plugin, PluginBase.prototype);

    plugin.clientRegister();
  });
})();
