(function () {
    const clockPlugins = Object.keys(window).filter(key => key.startsWith('_cloak_plugin_'))
    Cloak.plugins = {};
    Cloak.metadata = Cloak.getMetadata();
    clockPlugins.forEach(pluginName => {
        const newName = pluginName.substr(14);
        Cloak.plugins[newName] = window[pluginName];
        Cloak.plugins[newName].metadata = Cloak.plugins[newName].getMetadata();
    })
})()