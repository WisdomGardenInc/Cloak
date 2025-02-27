[**English Version**](./CHANGELOG-EN.md) | [中文版](./CHANGELOG.md)

# 更新日志

## 1.0.0 (2025-02-25)
- 实现 JavaScript 与 HarmonyOS 原生通信机制
- 建立基础插件开发体系

## 1.0.1 (2025-02-25)
- 增加默认 index.html 页，快速启动项目

## 1.0.2 (2025-02-26)
- 配置文件增加 `WEB_VIEW_USE_APP_PERMISSION`，控制 WebView 是否使用应用权限，不再出现授权提示

## 1.0.3 (2025-02-27)
- 配置文件增加 `APP_USE_REAL_HOST_RESOURCE`，控制是否加载真实 `APP_HOST` 所配置的远程资源，否则用 `APP_FOLDER` 配置的本地资源目录
- 若请求路径不存在静态资源，则自动回退到加载 index.html
