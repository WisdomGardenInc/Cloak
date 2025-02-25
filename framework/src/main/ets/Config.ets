import BuildProfile from '../../../BuildProfile';

export interface APPConfig {
  APP_FOLDER: string;
  APP_HOST: string;
  APP_IDENTITY_USER_AGENT: string;
  CLOAK_IDENTITY_USER_AGENT: string;
  IS_DEBUG: boolean;
}

const config: APPConfig = {
  APP_FOLDER: 'demo',
  APP_HOST: 'http://localhost',
  APP_IDENTITY_USER_AGENT: 'Cloak/HarmonyOS',
  // version should read from oh-package.json5 in module
  CLOAK_IDENTITY_USER_AGENT: `Cloak/${BuildProfile.HAR_VERSION}`,
  IS_DEBUG: true
}


export default config