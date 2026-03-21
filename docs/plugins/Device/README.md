[**中文版**](./README.md) | [English Version](./README-EN.md)

# Device 插件

**Cloak** 框架内置插件，提供设备信息获取能力，无需单独安装。

---

## 使用方法

### 前端侧
```typescript
// 获取设备信息
const info = await window.Cloak.plugins.Device.getInfo();
console.log(info.appVersion);
console.log(info.uuid);

// 获取系统语言
const language = await window.Cloak.plugins.Device.getSystemLanguage();
console.log(language); // 例如: zh-Hans
```

---

## API

### `getInfo()`

获取设备和应用信息。

**返回值**：`Promise<DeviceInfo>`

#### `DeviceInfo`

| 字段 | 类型 | 说明 |
|---|---|---|
| `appVersion` | `string` | 应用版本号，如 `1.0.0` |
| `appBuild` | `string` | 应用构建号，如 `100` |
| `appId` | `string` | 应用包名，如 `com.example.app` |
| `operatingSystem` | `string` | 操作系统，固定为 `harmonyos` |
| `osVersion` | `string` | 系统版本，如 `HarmonyOS 4.0.0` |
| `platform` | `string` | 平台，固定为 `harmonyos` |
| `uuid` | `string` | 设备唯一标识（ODID） |

---

### `getSystemLanguage()`

获取系统当前语言。

**返回值**：`Promise<string>`，如 `zh-Hans`、`en-US`。