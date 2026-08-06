[**English Version**](./CHANGELOG-EN.md) | [中文版](./CHANGELOG.md)

# Changelog

## 1.0.8 (2026-08-06)
- Fixed a plugin still treating an event as having listeners, and going on sending it to H5, after its last listener was removed
- Added log level control, defaulting to `Config.IS_DEBUG`, so `debug()` no longer emits in a release build; adjust it with `ILogger.setLevel(LogLevel.X)`
- Fixed the logger's `fatal()` actually emitting at debug level
- `getLogger` accepts a tag on its own


## 1.0.7 (2026-08-03)
- Fixed the promise returned by an `async` plugin method not following the Promise spec once it crossed into JS: a throw inside a `.then()` callback was swallowed and the derived object resolved to `null`, so code relying on chained `.then(onOk, onErr)` — a custom axios adapter, for instance — lost every non-2xx response
- `Cloak.plugins[name]` now exposes a facade so plugin methods always return a native promise; `window._cloak_plugin_*` is still the raw object injected by the bridge and should not be used directly
- `CloakPlugin._name` is now optional and falls back to the class name


## 1.0.6 (2026-03-21)
- Added built-in plugin `App` for physical back button handling and app exit
- Added built-in plugin `Device` for device information and system language
- Added `Cloak.onBackPress()` static method for handling physical back button
- `PluginManager` added generic method `getPlugin<T>()`
 
  
## 1.0.5 (2025-04-11)
- Added static property `Cloak.CONFIG` for retrieving the current configuration
- Changed static property `Cloak.APP_CONTEXT` to `Cloak.APP_ABILITY`; the original context can now be accessed via `Cloak.getAbility().context`
- Added static method `Cloak.isStartupCompleted()` to determine whether the application has completed startup
- Added lifecycle methods `beforeRegister`, `afterRegister`, and `onAttach` to `CloakPlugin`
- Introduced a logging module

## 1.0.4 (2025-03-13)
- Support event listeners and message handlers

## 1.0.3 (2025-02-27)
- Added configuration option `APP_USE_REAL_HOST_RESOURCE` to control whether to load remote resources configured by `APP_HOST`, otherwise use the local resource directory configured by `APP_FOLDER`
- Fallback to index.html if requested static resource does not exist

## 1.0.2 (2025-02-26)
- Added configuration option `WEB_VIEW_USE_APP_PERMISSION` to control whether WebView uses app permissions, eliminating authorization prompts

## 1.0.1 (2025-02-25)
- Added default index.html page for quick project startup

## 1.0.0 (2025-02-25)
- Implemented JavaScript ↔ HarmonyOS native communication
- Established base plugin architecture