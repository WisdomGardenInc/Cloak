import { CloakPlugin, PluginMethod } from '@wisdomgarden/cloak';

interface DeviceInfoResult {
  platform: string,
}

// class TestInnerObj {
//   methodNameListForJsProxy = ["getData"]
//
//   public getData() {
//     return "TestInnerObj data"
//   }
// }

export default class Device extends CloakPlugin {
  protected _name = "Device";
  protected _version = "1.0.0";
  protected _description = ''

  // @PluginMethod()
  // public getInnerObj(): ESObject {
  //   return new TestInnerObj();
  // };

  @PluginMethod()
  public async getDeviceInfo(): Promise<DeviceInfoResult> {

    return {
      platform: "HarmonyOS"
    };
  }

  @PluginMethod()
  public sendTestEvent() {
    this._sendEvent("test", { data: "test~~~~"})
  }
}