import { CloakPlugin } from './plugin/CloakPlugin';
import PluginManager from './plugin/PluginManager';
import { UIAbility } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import Config, { APPConfig } from './Config';

export default class Cloak {
  private static APP_ABILITY: UIAbility;
  public static SAFE_TOP = 32;
  public static SAFE_BOTTOM = 28;
  private static CONFIG: APPConfig;
  private static IS_STARTUP_COMPLETED = false;

  constructor(uiAbility: UIAbility, plugins?: CloakPlugin[]) {
    Cloak.APP_ABILITY = uiAbility;
    this.parseConfig();
    if (plugins) {
      this.addPlugins(plugins);
    }
  }

  public static getAbility() {
    return Cloak.APP_ABILITY;
  }

  public static getConfig() {
    return Cloak.CONFIG;
  }

  public static setStartupCompleted() {
    Cloak.IS_STARTUP_COMPLETED = true;
  }

  public static isStartupCompleted() {
    return Cloak.IS_STARTUP_COMPLETED;
  }

  public addPlugins(plugins: CloakPlugin[]) {
    plugins.forEach(plugin => {
      PluginManager.addPlugin(plugin)
    })
  }

  private parseConfig() {
    const content = Cloak.APP_ABILITY.context.getApplicationContext()
      .resourceManager
      .getRawFileContentSync('config.json');

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

    Cloak.CONFIG = Config;
  }
}