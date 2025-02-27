import BuildProfile from '../../../BuildProfile';

export interface APPConfig {
  APP_FOLDER: string;
  APP_HOST: string;
  APP_IDENTITY_USER_AGENT: string;
  CLOAK_IDENTITY_USER_AGENT: string;
  IS_DEBUG: boolean;
  WEB_VIEW_USE_APP_PERMISSION: boolean;
  APP_USE_REAL_HOST_RESOURCE: boolean;
}

const config: APPConfig = {
  APP_FOLDER: 'www',
  APP_HOST: 'http://localhost',
  APP_IDENTITY_USER_AGENT: 'Cloak/HarmonyOS',
  CLOAK_IDENTITY_USER_AGENT: `Cloak/${BuildProfile.HAR_VERSION}`,
  WEB_VIEW_USE_APP_PERMISSION: true,
  IS_DEBUG: false,
  APP_USE_REAL_HOST_RESOURCE: false,
}


export default config