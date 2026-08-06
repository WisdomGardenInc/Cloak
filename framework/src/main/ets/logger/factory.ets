import { Logger, ILogger, BASE_LOG_DOMAIN } from "./base"

export function getLogger(tag: string): ILogger;

export function getLogger(domain: number, tag: string): ILogger;

export function getLogger(arg1: string | number, arg2?: string): ILogger {
  if (typeof arg1 === 'string' && typeof arg2 === "undefined") {
    return new Logger(BASE_LOG_DOMAIN, arg1);
  } else if (typeof arg1 === "number" && typeof arg2 === 'string') {
    return new Logger(arg1, arg2);
  } else {
    throw new Error('Invalid arguments for getLogger');
  }
}
