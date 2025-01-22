interface APPConfig {
  PAGE_FOLDER: string;
  APP_HOST: string;
  APP_IDENTITY_USER_AGENT: string;
  IS_DEBUG: boolean;
}

const config: APPConfig = {
  PAGE_FOLDER: 'demo',
  APP_HOST: "http://localhost",
  APP_IDENTITY_USER_AGENT: 'TronClass/harmony',
  IS_DEBUG: true
}


export default config