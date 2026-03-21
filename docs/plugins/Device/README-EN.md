[中文版](./README.md) | [**English Version**](./README-EN.md)

# Device Plugin

A built-in plugin of the **Cloak** framework that provides device information. No separate installation required.

---

## Usage

### Frontend Side
```typescript
// Get device info
const info = await window.Cloak.plugins.Device.getInfo();
console.log(info.appVersion);
console.log(info.uuid);

// Get system language
const language = await window.Cloak.plugins.Device.getSystemLanguage();
console.log(language); // e.g. zh-Hans
```

---

## API

### `getInfo()`

Get device and application information.

**Returns**: `Promise<DeviceInfo>`

#### `DeviceInfo`

| Field | Type | Description |
|---|---|---|
| `appVersion` | `string` | App version, e.g. `1.0.0` |
| `appBuild` | `string` | App build number, e.g. `100` |
| `appId` | `string` | App bundle name, e.g. `com.example.app` |
| `operatingSystem` | `string` | Operating system, always `harmonyos` |
| `osVersion` | `string` | OS version, e.g. `HarmonyOS 4.0.0` |
| `platform` | `string` | Platform, always `harmonyos` |
| `uuid` | `string` | Device unique identifier (ODID) |

---

### `getSystemLanguage()`

Get the current system language.

**Returns**: `Promise<string>`, e.g. `zh-Hans`, `en-US`.