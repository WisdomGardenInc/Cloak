import { hilog } from "@kit.PerformanceAnalysisKit";

export const LOG_DOMAIN = 0xC000;

export const LOG_TAG = 'CloakFramework';


interface ILogger {
  debug: (format: string, ...args: (string | number | boolean)[]) => void;
  info: (format: string, ...args: (string | number | boolean)[]) => void;
  warn: (format: string, ...args: (string | number | boolean)[]) => void;
  error: (format: string, ...args: (string | number | boolean)[]) => void;
  fatal: (format: string, ...args: (string | number | boolean)[]) => void;
}

export const getLogger = (domain: number, tag: string): ILogger => {
  const logger: ILogger = {
    debug: (format: string, ...args: (string | number | boolean)[]) => {
      hilog.debug(domain, tag, format, ...args);
    },
    info: (format: string, ...args: (string | number | boolean)[]) => {
      hilog.info(domain, tag, format, ...args);
    },
    warn: (format: string, ...args: (string | number | boolean)[]) => {
      hilog.warn(domain, tag, format, ...args);
    },
    error: (format: string, ...args: (string | number | boolean)[]) => {
      hilog.error(domain, tag, format, ...args);
    },
    fatal: (format: string, ...args: (string | number | boolean)[]) => {
      hilog.debug(domain, tag, format, ...args);
    }
  };

  return logger;
}

export default getLogger(LOG_DOMAIN, LOG_TAG);