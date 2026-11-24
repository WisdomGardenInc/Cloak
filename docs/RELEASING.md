# Cloak 打包、测试与发版

[English](#building-testing-and-releasing-cloak)

## 打包

从仓库根目录运行以下命令。HAR 构建脚本适用于 macOS，需安装 JDK 17，并将 `ohpm` 和 `hvigorw` 加入 `PATH`。

| 产物 | 命令 | 输出位置 |
| --- | --- | --- |
| Release HAR | `export JAVA_HOME_17="$(/usr/libexec/java_home -v 17)"` 后运行 `./scripts/build_har.sh` | `framework/build/default/outputs/default/framework.har` |
| npm 包 | `(cd framework/src/npm && npm pack)` | `framework/src/npm/` 下的 `.tgz` |

HAR 构建以 OHPM 安装和 Hvigor 打包均成功为准。npm 包可用 `(cd framework/src/npm && npm pack --dry-run)` 预览内容。

## 真机测试

验证本地源码时，用 DevEco Studio 安装依赖、配置签名并运行 `entry`。Demo 通过 `file:../framework` 引用本地 framework。

| 验收项 | 通过标准 |
| --- | --- |
| Demo 冷启动 | 出现 **Installed Plugins**，点击 **Device.getInfo** 能显示设备信息。 |
| H5 刷新 | 点击 **reload** 后，插件列表重新出现，**Device.getInfo** 仍能调用。 |
| 宿主集成 | 引入新 HAR 并冷启动宿主。确认实际使用的插件可调用，例如扫码，并验证本次改动的功能。 |

排查桥接时，在 HiLog 筛选 `CloakFramework`。`Cloak Webview init success` 表示代理注册成功，`Cloak Webview initCloakClient success` 表示端口握手已发送。

## 发版

- 分别更新 [HAR 版本](../framework/oh-package.json5)和 [npm 版本](../framework/src/npm/package.json)，并更新中英文 CHANGELOG。[中文](../CHANGELOG.md) · [English](../CHANGELOG-EN.md)
- 重新打包并完成真机验收，核对 [`entry/oh-package-lock.json5`](../entry/oh-package-lock.json5) 中的本地 framework 版本。
- 使用有 `@wisdomgarden/cloak` 发布权限的 OHPM 和 npm 凭据，从仓库根目录发布对应的包。

| 发布到 | 命令 |
| --- | --- |
| OHPM | `mkdir -p local_hars && ./scripts/publish.sh` |
| npm | `(cd framework/src/npm && npm publish --access public)` |

`publish.sh` 会把 HAR 备份到 `local_hars/`，再上传到 OHPM。

## Building, testing, and releasing Cloak

### Build packages

Run these commands from the repository root. The HAR build script runs on macOS and requires JDK 17, plus `ohpm` and `hvigorw` on your `PATH`.

| Package | Command | Output |
| --- | --- | --- |
| Release HAR | `export JAVA_HOME_17="$(/usr/libexec/java_home -v 17)"`, then `./scripts/build_har.sh` | `framework/build/default/outputs/default/framework.har` |
| npm package | `(cd framework/src/npm && npm pack)` | A `.tgz` in `framework/src/npm/` |

For HAR, check that OHPM installation and Hvigor packaging both succeed. To preview the npm package contents, run `(cd framework/src/npm && npm pack --dry-run)`.

### Test on a device

To test local source changes, install dependencies and configure signing in DevEco Studio, then run `entry`. The demo references the local framework via `file:../framework`.

| Check | Expected result |
| --- | --- |
| Cold start | **Installed Plugins** appears, and **Device.getInfo** displays device details. |
| H5 reload | After **reload**, the plugin list reappears and **Device.getInfo** still works. |
| Host integration | Add the new HAR to the host app and cold-start it. Exercise a plugin the app uses, such as QR scanning, and verify the features changed in the release. |

For bridge diagnostics, filter HiLog by `CloakFramework`. `Cloak Webview init success` means the proxies registered. `Cloak Webview initCloakClient success` means the framework sent the message port.

### Publish

- Bump the [HAR version](../framework/oh-package.json5) and [npm version](../framework/src/npm/package.json) independently. Update both changelogs. [Chinese](../CHANGELOG.md) · [English](../CHANGELOG-EN.md)
- Rebuild, verify on a device, and check the local framework version in [`entry/oh-package-lock.json5`](../entry/oh-package-lock.json5).
- Run the publishing commands from the repository root with OHPM and npm credentials that can publish `@wisdomgarden/cloak`.

| Registry | Command |
| --- | --- |
| OHPM | `mkdir -p local_hars && ./scripts/publish.sh` |
| npm | `(cd framework/src/npm && npm publish --access public)` |

`publish.sh` backs up the HAR to `local_hars/` before uploading it to OHPM.
