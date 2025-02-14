interface CloakGlobalObjectMataData {
  name: string;
  version: string;
  description: string;
  platform: string;
}

export default class CloakGlobalObject {
  /**
   * window.Cloak {
   *   plugins: {
   *      xxxx: {
   *        metadata: {
   *          name: '',
   *          version: '',
   *          description: '',
   *          methods: [],
   *          TSType: 'npm library url',
   *          permission: {}
   *        }
   *        exposed method1 .....
   *        exposed method2 .....
   *      }
   *    }
   * }
   *
   *
   **/

  private name = 'Cloak'
  private version = "0.0.1"
  private description = 'Cloak is a Hybrid Framework for HarmonyOS'

  public getMataData(): CloakGlobalObjectMataData {
    return {
      name: this.name,
      version: this.version,
      description: this.description,
      platform: "HarmonyOS"
    }
  }

  public registerPlugins() {

  }
}