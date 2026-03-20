[**中文版**](./README.md) | [English Version](./README-EN.md)

# App 插件

**Cloak** 框架内置插件，提供应用生命周期和硬件事件处理能力，无需单独安装。

---

## 使用方法

### 原生侧

修改 `entry/src/main/ets/pages/Index.ets`，添加物理返回键处理：
```typescript
import { Cloak, CloakWebview } from '@wisdomgarden/cloak';

@Entry
@ComponentV2
struct CloakIndex {
  onBackPress(): boolean {
    return Cloak.onBackPress();
  }

  build() {
    Column() {
      CloakWebview()
    }
  }
}
```

### 前端侧
```typescript
// 监听物理返回键
const handlerId = window.Cloak.plugins.App.addEventListener('backButton', (event) => {
  // event.canGoBack: WebView 是否有上一页
  if (event.canGoBack) {
    // 返回上一页
  } else {
    // 退出应用
    window.Cloak.plugins.App.exitApp();
  }
});

// 移除监听
window.Cloak.plugins.App.removeEventListener('backButton', handlerId);

// 判断是否可以返回
const canGoBack = window.Cloak.plugins.App.canGoBack();

// 退出应用
window.Cloak.plugins.App.exitApp();
```

---

## 默认行为

前端**未监听** `backButton` 事件时，框架自动处理：
- WebView 有上一页 → 返回上一页
- WebView 无上一页 → 退出应用

---

## API

### `canGoBack()`

判断 WebView 是否有上一页。

**返回值**：`boolean`，`true` 表示有上一页。

---

### `exitApp()`

退出应用。

---

### `addEventListener(event, handler)`

监听事件。

| 参数 | 类型 | 说明 |
|---|---|---|
| `event` | `'backButton'` | 事件名 |
| `handler` | `(event: BackButtonEvent) => void` | 回调函数 |

**返回值**：`string` handlerId，用于移除监听。

#### `BackButtonEvent`

| 字段 | 类型 | 说明 |
|---|---|---|
| `canGoBack` | `boolean` | WebView 是否有上一页 |

---

### `removeEventListener(event, handlerId?)`

移除监听。

| 参数 | 类型 | 说明 |
|---|---|---|
| `event` | `'backButton'` | 事件名 |
| `handlerId` | `string?` | 不传则移除该事件所有监听 |