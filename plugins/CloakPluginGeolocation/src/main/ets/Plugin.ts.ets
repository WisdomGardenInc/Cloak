import { CloakPlugin, PluginMethod } from '@wisdomgarden/cloak';
import { geoLocationManager } from '@kit.LocationKit';


export default class Geolocation extends CloakPlugin {
  protected _name = "CloakPluginGeolocation";
  protected _version = "0.0.1";
  protected _description = ''

  @PluginMethod()
  public async getLocation(): Promise<geoLocationManager.Location> {
    const result = await geoLocationManager.getCurrentLocation()
    console.log(result.latitude.toString(), result.longitude.toString());
    return result;
  }
}