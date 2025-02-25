import { PluginMethod, CloakPlugin } from '@wisdomgarden/cloak';
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface PermissionsResult {
  Permissions: abilityAccessCtrl.GrantStatus;
}

export default class Permission extends CloakPlugin {
  protected _name = "Permission";
  protected _version = "1.0.0";

  private unifyPermissions(permissions: Permissions | Permissions[]): Permissions[] {
    if (typeof permissions === "string") {
      return [permissions]
    }
    return permissions
  }


  private async queryPermission(permission: Permissions, tokenId: number,
    atManager: abilityAccessCtrl.AtManager): Promise<[Permissions, abilityAccessCtrl.GrantStatus]> {

    try {
      const grantStatus = await atManager.checkAccessToken(tokenId, permission);
      return [permission, grantStatus];
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
      return [permission, abilityAccessCtrl.GrantStatus.PERMISSION_DENIED];
    }

  }

  @PluginMethod()
  async query(_permissions: Permissions | Permissions[]): Promise<Map<Permissions, abilityAccessCtrl.GrantStatus>> {
    const permissions = this.unifyPermissions(_permissions);
    const result = new Map<Permissions, abilityAccessCtrl.GrantStatus>(permissions.map((p) => [p,
      abilityAccessCtrl.GrantStatus.PERMISSION_DENIED]))

    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();


    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
      return result;
    }

    const checkResults = await
    Promise.all(permissions.map(permission => this.queryPermission(permission, tokenId, atManager)))

    checkResults.forEach((checkResult) => result[checkResult[0]] = checkResult[1])
    
    return result;
  }


  @PluginMethod()
  async request(_permissions: Permissions | Permissions[]): Promise<Map<Permissions, abilityAccessCtrl.GrantStatus>> {

    const permissions = this.unifyPermissions(_permissions);

    const result = new Map<Permissions, abilityAccessCtrl.GrantStatus>(permissions.map((p) => [p,
      abilityAccessCtrl.GrantStatus.PERMISSION_DENIED]))

    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();


    try {
      const requestResults = await atManager.requestPermissionsFromUser(context, permissions);

      requestResults.permissions.forEach((permission, index) => {
        result[permission] = requestResults.authResults[index];
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
    }

    return result;
  }
}