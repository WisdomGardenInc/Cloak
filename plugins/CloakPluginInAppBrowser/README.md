[**English Version**](./README-EN.md) | [中文版](./README.md)

# CloakPluginInAppBrowser

CloakPluginInAppBrowser 是 Cloak 框架的插件之一，用于在 Cloak 应用 中再打开浏览器，执行操作。

## 使用方法

### 前置条件


> 安装 Cloak 框架 `@wisdomgarden/cloak`
>
> 具体细节参考 [@wisdomgarden/cloak](https://ohpm.openharmony.cn/#/cn/detail/@wisdomgarden%2Fcloak)

1. 安装 CloakPluginInAppBrowser 插件
   ```bash
   ohpm install @wisdomgarden/cloak-plugin-inappbrowser
   ```

2. 在项目 `entry/src/main/module.json5` 中声明网络访问权限。
   
   [官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/declare-permissions-V5#%E5%9C%A8%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E4%B8%AD%E5%A3%B0%E6%98%8E%E6%9D%83%E9%99%90)
   
   示例：
   ```json5
   "requestPermissions": [
    // ...
    {
      "name": "ohos.permission.INTERNET",
      "reason": "$string:permission_internet_reason",
      "usedScene": {
        "abilities": [
          "EntryAbility"
        ],
        "when": "inuse"
      }
    },
    // ...
   ]
   ```

3. 在 H5 逻辑代码中就可以直接调用该插件

### 示例代码

#### 打开 URL 并监听事件

```javascript
const onOpenUrl = async (url) => {
  const browser = Cloak.plugins.InAppBrowser.create(url, "_blank", { clearcache: true, footer: false });

  browser.open();

  // 监听 loadstart 事件
  browser.addEventListener('loadstart', function (event) {
    alert("addEventListener loadstart: " + event.url);
  });

  // 使用 RxJS 风格的订阅方式监听 loadstart 事件
  browser.on("loadstart").subscribe(({ url }) => {
    alert("on loadstart: " + url);
  });

  // 监听 loadstop 事件并执行脚本和插入 CSS
  browser.on("loadstop").subscribe(({ url }) => {
    browser.executeScript({
      code: "document.querySelector('.core-card .card-title').innerText = '和 Wisdom Garden 一起开启 OpenHarmony 之旅吧！';document.querySelector('.core-card .card-title').style.fontSize = '2rem';document.querySelector('.core-card .card-title').style.color = 'red';"
    });
    browser.insertCSS({ code: ".card-summary {color: purple !important;}" });
    alert("on loadstop: " + url);
  });

  // 监听 exit 事件
  browser.on("exit").subscribe(() => {
    alert("closed");
  });
};
```

### 核心接口

#### 创建浏览器实例

```typescript
interface InAppBrowserPlugin extends Plugin {
  currentBrowser: InAppBrowserObject | null;
  create(url: string, target: IOpenTarget, options: ICreateBrowserOptions): InAppBrowserObject;
  createBrowser(url: string, target: string, options: ICreateBrowserOptions): InAppBrowserObject;
}
```

#### 浏览器对象接口

```typescript
interface InAppBrowserObject {
  open: () => boolean;
  close: () => boolean;
  show: () => boolean;
  hide: () => boolean;
  executeScript: (payload: IBrowserExecutePayload) => Promise<ESObject>;
  insertCSS: (payload: IBrowserExecutePayload) => Promise<ESObject>;
  addEventListener: (event: IBrowserEvent, handler?: (event: IBrowserEventPayload) => void) => void;
}
```

#### RxJS 风格的事件订阅

```typescript
interface InAppBrowserInstanceRxjs extends InAppBrowserObject {
  on: (event: IBrowserEvent) => {
    subscribe: (handler: (event: IBrowserEventPayload) => void) => void;
  };
}
```

## 接口类型定义

### 浏览器执行脚本负载

```typescript
export interface IBrowserExecutePayload {
  code: string;
}
```

### 浏览器事件类型

```typescript
export type IBrowserEvent = "loadstart" | "loadstop" | "loaderror" | "exit";
```

### 打开目标选项

```typescript
export type IOpenTarget = "_self" | "_blank" | "_system" | null;
```

### 创建浏览器选项

```typescript
export interface ICreateBrowserOptions {
  clearCache?: boolean | null;
  clearcache?: boolean | null;
  clearSessionCache?: boolean | null;
  clearsessioncache?: boolean | null;
  session?: string | null;
  closeButtonCaption?: string | null;
  closebuttoncaption?: string | null;
  footer?: boolean | null;
  footerColor?: string | null;
  footercolor?: string | null;
  hideNavigationButtons?: boolean | null;
  hidenavigationbuttons?: boolean | null;
}
```

### 浏览器事件负载

```typescript
export interface IBrowserEventPayload {
  event: IBrowserEvent;
  url: string;
}
```

---

# 关于 **Cloak**

**Cloak** 是专为 **HarmonyOS** 设计的混合开发框架，类似 [Cordova](https://cordova.apache.org/) 和 [Capacitor](https://capacitorjs.com/)，但具备 **更轻量**、**更高性能** 的特性。

该框架可将 Web 应用快速转换为原生应用，同时通过插件机制访问 HarmonyOS 原生能力。


## 核心特性

- **快速打包**：将 H5 应用快速编译为 HarmonyOS 应用。
- **原生能力访问**：通过插件机制调用原生接口。
- **WebView 支持**：提供高性能 WebView 容器，确保 H5 应用流畅运行。
- **插件开发**：支持开发者自定义插件以扩展原生功能。

更多关于 Cloak 框架信息，请查看: https://github.com/WisdomGardenInc/Cloak