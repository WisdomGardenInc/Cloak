[**English Version**](./README-EN.md) | [中文版](./README.md)

# **Cloak** - HarmonyOS 混合开发框架

**Cloak** 是专为 **HarmonyOS** 设计的混合开发框架，类似 [Cordova](https://cordova.apache.org/) 和 [Capacitor](https://capacitorjs.com/)，但具备 **更轻量**、**更高性能** 的特性。

该框架可将 Web 应用快速转换为原生应用，同时通过插件机制访问 HarmonyOS 原生能力。

---

## 核心特性

- **快速打包**：将 H5 应用快速编译为 HarmonyOS 应用。
- **原生能力访问**：通过插件机制调用原生接口。
- **WebView 支持**：提供高性能 WebView 容器，确保 H5 应用流畅运行。
- **插件开发**：支持开发者自定义插件以扩展原生功能。

---

## 提示

- **兼容性说明**：与现有 Cordova 或 Capacitor 插件 **不兼容**，所有插件需基于 HarmonyOS 原生能力 **重新开发**。

### 现有插件
  每个插件还有配套的同名 `npm` 包，方便 `Typescript` 和前端**扩展**。   

- **[CloakPluginPermission](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginPermission/README.md)**
  
  用于检查、请求 HarmonyOS 权限。
  
  ```bash
  ohpm i @wisdomgarden/cloak-plugin-permission
  npm i @wisdomgarden/cloak-plugin-permission # optional
  ```

- **[CloakPluginHttp](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginHttp/README.md)**
  
  用于在 Cloak 应用中进行 Native HTTP 请求。

  ```bash
  ohpm i @wisdomgarden/cloak-plugin-http
  npm i @wisdomgarden/cloak-plugin-http # optional
  ```

- **[CloakPluginInAppBrowser](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginInAppBrowser/README.md)**
  
  用于在 Cloak 应用中打再开内部浏览器，执行操作。

  ```bash
  ohpm i @wisdomgarden/cloak-plugin-inappbrowser
  npm i @wisdomgarden/cloak-plugin-inappbrowser # optional
  ```

- **[CloakPluginOpenNativeSettings](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginOpenNativeSettings/README.md)**

  用于在 Cloak 应用中打开原生设置页面。

  ```bash
  ohpm i @wisdomgarden/cloak-plugin-open-native-settings
  npm i @wisdomgarden/cloak-plugin-open-native-settings # optional
  ```

***✨✨✨ 更多插件即将推出，敬请期待。 ✨✨✨***

---

## 使用方法

### 运行示例应用
1. **创建 EmptyAbility 应用**
  
   参考华为官方文档：[构建第一个ArkTS应用（Stage模型）](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/start-with-ets-stage-V5)

2. **安装 Cloak 框架**
   ```bash
   ohpm install @wisdomgarden/cloak
   ```
   安装完成后即可运行内置示例应用。

3. **引入框架**
   
   修改 `entry/src/main/ets/entryability/EntryAbility.ets` 的 `onCreate` 方法，添加以下代码：
   
   ```typescript
   import { Cloak } from '@wisdomgarden/cloak';
   
   onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
      // ...
      
      const cloak = new Cloak(this)
      // cloak.addPlugins([
      //   new CloakPluginPermission(),
      //   new CloakPluginDevice(),
      //   new CloakPluginGeolocation(),
      //   new CloakPluginInAppBrowser(),
      // ])
   }
   ```
   
   修改 entry/src/main/ets/pages/Index.ets， 展示 webview
   
   ```typescript
   import { CloakWebview } from "@wisdomgarden/cloak"
   
   @Entry
   @Component
   struct CloakIndex {
      build() {
         Column() {
            CloakWebview()
         }
      }
   }
   ```

---

### 集成你的 H5 应用

4. **创建配置文件**
   在资源目录新建 `entry/src/main/resources/rawfile/config.json`：
   ```json
   {
     "APP_FOLDER": "www",
     "APP_HOST": "http://localhost",
     "APP_IDENTITY_USER_AGENT": "YourAppName/HarmonyOS",
     "IS_DEBUG": false,
     "WEB_VIEW_USE_APP_PERMISSION": true,
     "APP_USE_REAL_HOST_RESOURCE": false
   }
   ```


5. **部署 H5 资源**
  
   将 H5 应用文件（**以 index.html 为入口**）复制至 `entry/src/main/resources/rawfile/www`


6. **调试与运行**

   通过 DevEco Studio 进行编译和实时调试。


7. **适配 H5 能力**
   
   至此，配合 **[CloakPluginPermission](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginPermission/README.md)** 获得系统权限， 
   Cloak 已经可以适配绝大多数 H5 应用所需的能力。比如 `navigator.mediaDevices`, `input (capture, file)`, `navigator.geolocation`, `indexedDB` 等。可参见 [Demo](https://github.com/WisdomGardenInc/Cloak/tree/master/entry/src/main/resources/rawfile/www)


8. **插件开发**

   根据需求开发自定义插件，或通过[社区](https://ohpm.openharmony.cn)获取适配 HarmonyOS 的插件。

## 示例

完成[使用方法](#使用方法)步骤，其他可参照: https://github.com/WisdomGardenInc/Cloak