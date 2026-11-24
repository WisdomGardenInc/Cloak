[English Version](./README-EN.md) | [**中文版**](./README.md)

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

### 内置插件

- **[App](https://github.com/WisdomGardenInc/Cloak/blob/master/docs/plugins/App/README.md)**

  提供应用生命周期和硬件事件处理能力，无需单独安装。

- **[Device](https://github.com/WisdomGardenInc/Cloak/blob/master/docs/plugins/Device/README.md)**

  提供设备信息和系统语言获取能力，无需单独安装。
  
### 现有插件

官方插件清单与安装说明见 **[CloakPlugins](https://github.com/WisdomGardenInc/CloakPlugins#插件列表)**。

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

   在 `entry/src/main/resources/rawfile/config.json` 中填写需要自定义的字段。使用默认设置时，文件内容可写为 `{}`。

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

   | 字段 | 类型 | 默认值 | 说明 |
   | --- | --- | --- | --- |
   | `APP_FOLDER` | `string` | `"www"` | `rawfile` 下存放本地 H5 资源的目录。 |
   | `APP_HOST` | `string` | `"http://localhost"` | WebView 的入口地址。与该地址同源的页面可在 WebView 内打开。 |
   | `APP_ALLOW_NAVIGATION` | `string[]` | 无 | 可选。让指定的外部域名留在 WebView，例如 `["help.example.com"]`。按域名精确匹配，填写时省略协议、端口和路径。其他命中外链拦截规则的链接交给系统处理。 |
   | `APP_IDENTITY_USER_AGENT` | `string` | `"Cloak/HarmonyOS"` | 附加到 WebView User-Agent 的应用标识，例如 `"YourAppName/HarmonyOS"`。 |
   | `IS_DEBUG` | `boolean` | `false` | 设为 `true` 时启用 WebView 调试和调试级日志。 |
   | `WEB_VIEW_USE_APP_PERMISSION` | `boolean` | `true` | 设为 `true` 时，WebView 的定位及其他权限请求直接走授权流程。设为 `false` 时，Cloak 先显示确认弹窗。 |
   | `APP_USE_REAL_HOST_RESOURCE` | `boolean` | `false` | 设为 `true` 时，由 WebView 向 `APP_HOST` 请求资源。设为 `false` 时，Cloak 尝试从本地 `APP_FOLDER` 加载。 |


5. **部署 H5 资源**
  
   将 H5 应用文件（**以 index.html 为入口**）复制至 `entry/src/main/resources/rawfile/www`


6. **调试与运行**

   通过 DevEco Studio 进行编译和实时调试。


7. **适配 H5 能力**
   
   至此，配合 **[CloakPluginPermission](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginPermission/README.md)** 获得系统权限， 
   Cloak 已经可以适配绝大多数 H5 应用所需的能力。比如 `navigator.mediaDevices`, `input (capture, file)`, `navigator.geolocation`, `indexedDB` 等。可参见 [Demo](https://github.com/WisdomGardenInc/Cloak/tree/master/entry/src/main/resources/rawfile/www)


8. **插件开发**

   根据需求开发自定义插件，或通过[社区](https://ohpm.openharmony.cn)获取适配 HarmonyOS 的插件。

## 打包与测试

查看 Demo 验收项、HAR 和 npm 打包命令，以及两个包的发布步骤。[打包、测试与发版指南](https://github.com/WisdomGardenInc/Cloak/blob/master/docs/RELEASING.md)

## 示例

完成[使用方法](#使用方法)步骤，其他可参照: https://github.com/WisdomGardenInc/Cloak
