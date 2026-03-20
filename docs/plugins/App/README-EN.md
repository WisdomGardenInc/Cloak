[中文版](./README.md) | [**English Version**](./README-EN.md)

# App Plugin

A built-in plugin of the **Cloak** framework that provides app lifecycle and hardware event handling. No separate installation required.

---

## Usage

### Native Side

Modify `entry/src/main/ets/pages/Index.ets` to handle the physical back button:
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

### Frontend Side
```typescript
// Listen to physical back button
const handlerId = window.Cloak.plugins.App.addEventListener('backButton', (event) => {
  // event.canGoBack: whether WebView has a previous page
  if (event.canGoBack) {
    // go back
  } else {
    // exit app
    window.Cloak.plugins.App.exitApp();
  }
});

// Remove listener
window.Cloak.plugins.App.removeEventListener('backButton', handlerId);

// Check if can go back
const canGoBack = window.Cloak.plugins.App.canGoBack();

// Exit app
window.Cloak.plugins.App.exitApp();
```

---

## Default Behavior

When the frontend has **no listener** registered for the `backButton` event, the framework handles it automatically:
- WebView has a previous page → go back
- WebView has no previous page → exit app

---

## API

### `canGoBack()`

Check whether the WebView has a previous page.

**Returns**: `boolean`, `true` means there is a previous page.

---

### `exitApp()`

Exit the app.

---

### `addEventListener(event, handler)`

Register an event listener.

| Parameter | Type | Description |
|---|---|---|
| `event` | `'backButton'` | Event name |
| `handler` | `(event: BackButtonEvent) => void` | Callback function |

**Returns**: `string` handlerId, used to remove the listener.

#### `BackButtonEvent`

| Field | Type | Description |
|---|---|---|
| `canGoBack` | `boolean` | Whether WebView has a previous page |

---

### `removeEventListener(event, handlerId?)`

Remove an event listener.

| Parameter | Type | Description |
|---|---|---|
| `event` | `'backButton'` | Event name |
| `handlerId` | `string?` | If not provided, all listeners for the event will be removed |