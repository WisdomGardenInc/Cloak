(function () {
    const clockPlugins = Object.keys(window).filter(key => key.startsWith('_cloak_plugin_'))
    Cloak.plugins = {};
    Cloak.matadata = Cloak.getMataData();
    clockPlugins.forEach(pluginName => {
        const newName = pluginName.substr(14);
        Cloak.plugins[newName] = window[pluginName];
        Cloak.plugins[newName].matadata = Cloak.plugins[newName].getMataData();
    })
})()