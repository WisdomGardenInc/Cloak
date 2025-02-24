interface APPConfig {
  PAGE_FOLDER: string;
  APP_HOST: string;
  APP_IDENTITY_USER_AGENT: string;
  CLOAK_IDENTITY_USER_AGENT: string;
  IS_DEBUG: boolean;
}

const config: APPConfig = {
  PAGE_FOLDER: 'demo',
  APP_HOST: 'http://localhost',
  APP_IDENTITY_USER_AGENT: 'Cloak/harmony',
  // version should read from oh-package.json5 in module
  CLOAK_IDENTITY_USER_AGENT: 'Cloak/1.0.0',
  IS_DEBUG: true
}


export default config