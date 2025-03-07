let InAppBrowser = null;

const register = (plugin) => {
  if (plugin.registered) {
    return;
  }
  InAppBrowser = plugin;
  plugin.currentBrowser = null;
  plugin.create = function (url, target, options) {
    const browser = plugin.createBrowser(url, target, options);
    plugin.currentBrowser = browser;
    browser._events = {};

    browser.on = function (eventName) {
      if (!browser._events[eventName]) {
        this._events[eventName] = [];
      }
      plugin.addMessage(eventName);

      return {
        subscribe: (callback) => {
          this._events[eventName].push(callback);
        },
      };
    };

    browser._triggerEvent = function (eventName, data) {
      if (this._events[eventName]) {
        this._events[eventName].forEach((callback) => callback(data));
      }
    };

    return browser;
  };

  const messagehandler = (message) => {
    const { event } = message;
    if (event && plugin.currentBrowser._events[event]) {
      plugin.currentBrowser._triggerEvent(event, message);
      if (event === "exit") {
        plugin._events = undefined;
        plugin.currentBrowser = undefined;
      }
    }
  };

  plugin.setMessageHandler(messagehandler);

  plugin.registered = true;
};

(() => {
  window.__CloakPluginsRegister = window.__CloakPluginsRegister || {};
  window.__CloakPluginsRegister["InAppBrowser"] = register;
  if (Cloak && Cloak.plugins && Cloak.plugins.InAppBrowser) {
    register(Cloak.plugins.InAppBrowser);
  }
})();

export {
  register,
  InAppBrowser,
};