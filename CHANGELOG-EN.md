[**中文版**](./CHANGELOG.md) | [English Version](./CHANGELOG-EN.md)

# Changelog

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