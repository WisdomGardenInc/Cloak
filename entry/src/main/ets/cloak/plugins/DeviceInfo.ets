import CloakPlugin, { PluginMethod } from '../pluginsCore/CloakPlugin';

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

export default class DeviceInfo extends CloakPlugin {
  protected _name = "DeviceInfo";
  protected _version = "0.0.1";
  protected _description = ''

  // @PluginMethod
  // public getInnerObj(): ESObject {
  //   return new TestInnerObj();
  // };

  @PluginMethod
  public async getDeviceInfo(): Promise<DeviceInfoResult> {

    return {
      platform: "HarmonyOS"
    };
  }
}