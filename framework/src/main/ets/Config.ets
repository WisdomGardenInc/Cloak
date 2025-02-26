import BuildProfile from '../../../BuildProfile';

export interface APPConfig {
  APP_FOLDER: string;
  APP_HOST: string;
  APP_IDENTITY_USER_AGENT: string;
  CLOAK_IDENTITY_USER_AGENT: string;
  IS_DEBUG: boolean;
  WEB_VIEW_USE_APP_PERMISSION: boolean;
}

const config: APPConfig = {
  APP_FOLDER: 'www',
  APP_HOST: 'http://localhost',
  APP_IDENTITY_USER_AGENT: 'Cloak/HarmonyOS',
  CLOAK_IDENTITY_USER_AGENT: `Cloak/${BuildProfile.HAR_VERSION}`,
  IS_DEBUG: true,
  WEB_VIEW_USE_APP_PERMISSION: true,
}


export default config