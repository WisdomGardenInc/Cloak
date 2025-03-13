import { CloakPlugin } from './plugin/CloakPlugin';
import PluginManager from './plugin/PluginManager';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import Config, { APPConfig } from './Config';

export default class Cloak {
  private static APP_CONTEXT: common.ApplicationContext;
  public static SAFE_TOP = 32;
  public static SAFE_BOTTOM = 28;

  constructor(context: common.ApplicationContext, plugins: CloakPlugin[]) {
    Cloak.APP_CONTEXT = context;
    this.parseConfig();
    plugins.forEach(plugin => {
      PluginManager.addPlugin(plugin)
    })
  }

  public static getAppContext() {
    return Cloak.APP_CONTEXT;
  }

  private parseConfig() {
    const content = Cloak.APP_CONTEXT.resourceManager.getRawFileContentSync('config.json');

    const textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    const config = JSON.parse(textDecoder.decodeToString(content)) as Partial<APPConfig>

    Config.APP_FOLDER = config.APP_FOLDER ?? Config.APP_FOLDER;
    Config.APP_HOST = config.APP_HOST ?? Config.APP_HOST;
    Config.APP_IDENTITY_USER_AGENT = config.APP_IDENTITY_USER_AGENT ?? Config.APP_IDENTITY_USER_AGENT;
    Config.IS_DEBUG = config.IS_DEBUG ?? Config.IS_DEBUG;
    Config.WEB_VIEW_USE_APP_PERMISSION = config.WEB_VIEW_USE_APP_PERMISSION ?? Config.WEB_VIEW_USE_APP_PERMISSION;
    Config.APP_USE_REAL_HOST_RESOURCE = config.APP_USE_REAL_HOST_RESOURCE ?? Config.APP_USE_REAL_HOST_RESOURCE;
  }
}