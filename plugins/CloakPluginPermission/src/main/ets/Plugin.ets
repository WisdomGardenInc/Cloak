import {PluginMethod, CloakPlugin} from '@wisdomgarden/cloak';

export default class Permission extends CloakPlugin {
  protected _name = "Permission";
  protected _version = "1.0.0";

  @PluginMethod()
  query() {
    return true;
  }

  @PluginMethod()
  request() {
    return true;
  }
}