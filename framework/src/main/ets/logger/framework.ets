import { BASE_LOG_DOMAIN } from "./base"
import { getLogger } from "./factory"

export const LOG_TAG = 'CloakFramework';

export default getLogger(BASE_LOG_DOMAIN, LOG_TAG);
