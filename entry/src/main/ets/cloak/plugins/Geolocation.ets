import CloakPlugin from '../pluginsCore/CloakPlugin';
import { PluginMethod } from '../pluginsCore/utils';
import geoLocationManager from '@ohos.geoLocationManager';

interface LocationResult {
  latitude: number,
  longitude: number
}

export default class Geolocation extends CloakPlugin {
  protected _name = "Geolocation";
  protected _version = "0.0.1";
  protected _description = ''

  @PluginMethod
  public async getLocation(): Promise<geoLocationManager.Location> {
    const result = await geoLocationManager.getCurrentLocation()
    console.log(result.latitude.toString(), result.longitude.toString());
    return result;
  }
}