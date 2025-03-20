[**中文版**](./README.md) | [English Version](./README-EN.md)

# **Cloak** - Hybrid Development Framework for HarmonyOS

**Cloak** is a lightweight hybrid development framework for **HarmonyOS**, inspired by [Cordova](https://cordova.apache.org/) and [Capacitor](https://capacitorjs.com/), but with **simpler implementation** and **better performance**.

Enables rapid conversion of web applications to native HarmonyOS apps with plugin-based native API access.

---

## Core Features

- **Quick Packaging**
  Compile H5/web apps into HarmonyOS applications within minutes

- **Native API Access**
  Extend functionality through HarmonyOS native plugins

- **Optimized WebView**
  High-performance WebView container with hardware acceleration

- **Plugin Development**
  Easily create HarmonyOS native plugins using TypeScript/ArkTS

---

## Important Notes

- **No Compatibility** with existing Cordova/Capacitor plugins
  All plugins must be **redeveloped** using HarmonyOS native APIs

### Existing Plugins

- **[CloakPluginPermission](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginPermission/README-EN.md)** `ohpm i @wisdomgarden/cloak-plugin-permission`
  
  Used to check and request HarmonyOS permissions.

- **[CloakPluginHttp](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginHttp/README-EN.md)** `ohpm i @wisdomgarden/cloak-plugin-http`
  
  Used to make Native HTTP requests within Cloak applications.

- **[CloakPluginInAppBrowser](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginInAppBrowser/README-EN.md)** `ohpm i @wisdomgarden/cloak-plugin-inappbrowser`
  
  Used to open internal browsers in Cloak applications and perform operations.

- **[CloakPluginOpenNativeSettings](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginOpenNativeSettings/README-EN.md)** `ohpm i @wisdomgarden/cloak-plugin-open-native-settings`

  used for opening native settings pages within Cloak applications

More plugins are coming soon, stay tuned.

---

## Getting Started

### Run Demo App
1. **Create EmptyAbility Project**
  
   Follow official guide: [Building the First ArkTS Application in Stage Model](https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V5/start-with-ets-stage-V5)


2. **Install Cloak Framework**
   ```bash
   ohpm install @wisdomgarden/cloak
   ```
   The built-in demo will be automatically available.

---

### Integrate Your Web App
3. **Create Config File**
  Add `entry/src/main/resources/rawfile/config.json`:
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


4. **Deploy Web Assets**

   Copy your web app (must contain **index.html**) to `entry/src/main/resources/rawfile/www`


5. **Debug & Run**

   Use DevEco Studio for real-time debugging


6. **Adapting H5 Capabilities**

   At this point, with the help of **[CloakPluginPermission](https://github.com/WisdomGardenInc/CloakPlugins/blob/master/plugins/CloakPluginPermission/README-EN.md)** to obtain system permissions, Cloak can now adapt to the majority of capabilities required by H5 applications. For example, `navigator.mediaDevices`, `input (capture, file)`, `navigator.geolocation`, `indexedDB`, etc. Please refer to the [Demo](https://github.com/WisdomGardenInc/Cloak/tree/master/entry/src/main/resources/rawfile/www) for more details.


7. **Plugin Development**

   Develop custom plugins or find community plugins via [OHPM registry](https://ohpm.openharmony.cn)

## Example

Complete the [Getting Started](#getting-started) steps, and refer to: https://github.com/WisdomGardenInc/Cloak for more details.