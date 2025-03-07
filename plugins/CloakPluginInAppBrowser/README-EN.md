[中文版](./README.md) | [**English Version**](./README-EN.md)

# CloakPluginInAppBrowser

CloakPluginInAppBrowser is a plugin for the Cloak framework, designed to open and manage browser windows within Cloak applications.

## Usage

### Prerequisites

> Install the Cloak framework `@wisdomgarden/cloak`
>
> For more details, refer to [@wisdomgarden/cloak](https://ohpm.openharmony.cn/#/cn/detail/@wisdomgarden%2Fcloak)

1. Install the CloakPluginInAppBrowser plugin
   ```bash
   ohpm install @wisdomgarden/cloak-plugin-inappbrowser
   ```

2. Declare internet access permissions in your project's `entry/src/main/module.json5`.
   
   [Official Documentation](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/declare-permissions-V5#%E5%9C%A8%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E4%B8%AD%E5%A3%B0%E6%98%8E%E6%9D%83%E9%99%90)
   
   Example:
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

3. You can now directly call the plugin in your H5 logic code.

### Example Code

#### Open URL and Listen for Events

```javascript
const onOpenUrl = async (url) => {
  const browser = Cloak.plugins.InAppBrowser.create(url, "_blank", { clearcache: true, footer: false });

  browser.open();

  // Listen for loadstart event
  browser.addEventListener('loadstart', function (event) {
    alert("addEventListener loadstart: " + event.url);
  });

  // Use RxJS-style subscription to listen for loadstart event
  browser.on("loadstart").subscribe(({ url }) => {
    alert("on loadstart: " + url);
  });

  // Listen for loadstop event and execute script and insert CSS
  browser.on("loadstop").subscribe(({ url }) => {
    browser.executeScript({
      code: "document.querySelector('.core-card .card-title').innerText = 'Start your OpenHarmony journey with Wisdom Garden!';document.querySelector('.core-card .card-title').style.fontSize = '2rem';document.querySelector('.core-card .card-title').style.color = 'red';"
    });
    browser.insertCSS({ code: ".card-summary {color: purple !important;}" });
    alert("on loadstop: " + url);
  });

  // Listen for exit event
  browser.on("exit").subscribe(() => {
    alert("closed");
  });
};
```

### Core Interfaces

#### Create Browser Instance

```typescript
interface InAppBrowserPlugin extends Plugin {
  currentBrowser: InAppBrowserObject | null;
  create(url: string, target: IOpenTarget, options: ICreateBrowserOptions): InAppBrowserObject;
  createBrowser(url: string, target: string, options: ICreateBrowserOptions): InAppBrowserObject;
}
```

#### Browser Object Interface

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

#### RxJS-style Event Subscription

```typescript
interface InAppBrowserInstanceRxjs extends InAppBrowserObject {
  on: (event: IBrowserEvent) => {
    subscribe: (handler: (event: IBrowserEventPayload) => void) => void;
  };
}
```

## Interface Type Definitions

### Browser Script Execution Payload

```typescript
export interface IBrowserExecutePayload {
  code: string;
}
```

### Browser Event Types

```typescript
export type IBrowserEvent = "loadstart" | "loadstop" | "loaderror" | "exit";
```

### Target Options for Opening

```typescript
export type IOpenTarget = "_self" | "_blank" | "_system" | null;
```

### Browser Creation Options

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

### Browser Event Payload

```typescript
export interface IBrowserEventPayload {
  event: IBrowserEvent;
  url: string;
}
```

---

# About **Cloak**

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

For more information about the Cloak framework, please visit: https://github.com/WisdomGardenInc/Cloak