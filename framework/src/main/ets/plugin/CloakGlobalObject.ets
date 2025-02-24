import  { CloakPlugin, PluginMetadata } from "./CloakPlugin";

interface CloakGlobalObjectMetadata extends PluginMetadata {
  platform: string;
}

export default class CloakGlobalObject extends CloakPlugin {
  protected _name = "Cloak";
  protected _version = "1.0.0";
  protected _description = "Cloak is a Hybrid Framework for HarmonyOS";

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


  public getMetadata(): CloakGlobalObjectMetadata {
    const superMetaData = super.getMetadata();

    return {
      name: superMetaData.name,
      version: superMetaData.version,
      description: superMetaData.description,
      methods: superMetaData.methods,
      platform: "HarmonyOS",
    };
  }

  registerPlugins() {
    // move to client logic
  }
}