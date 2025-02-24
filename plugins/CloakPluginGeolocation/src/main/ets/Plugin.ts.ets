import { CloakPlugin, PluginMethod } from '@wisdomgarden/cloak';
import { geoLocationManager } from '@kit.LocationKit';


export default class Geolocation extends CloakPlugin {
  protected _name = "Geolocation";
  protected _version = "1.0.0";
  protected _description = ''

  @PluginMethod()
  public async getLocation(): Promise<geoLocationManager.Location> {
    const result = await geoLocationManager.getCurrentLocation()
    console.log(result.latitude.toString(), result.longitude.toString());
    return result;
  }
}