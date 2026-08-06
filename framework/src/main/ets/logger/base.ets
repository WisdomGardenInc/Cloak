import { hilog } from "@kit.PerformanceAnalysisKit";
import Config from "../Config";

export const BASE_LOG_DOMAIN = 0xC000;

export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  FATAL = 4,
  OFF = 5
}

export interface ILogger {
  debug: (format: string, ...args: (string | number | boolean)[]) => void;
  info: (format: string, ...args: (string | number | boolean)[]) => void;
  warn: (format: string, ...args: (string | number | boolean)[]) => void;
  error: (format: string, ...args: (string | number | boolean)[]) => void;
  fatal: (format: string, ...args: (string | number | boolean)[]) => void;
  setLevel: (level: LogLevel) => void;
  getLevel: () => LogLevel;
}

export class Logger implements ILogger {
  private domain: number;
  private tag: string;
  private _level?: LogLevel;
  private tagInFormat: string;

  constructor(domain: number, tag: string) {
    this.domain = domain;
    this.tag = tag;
    this.tagInFormat = `[${tag}] `;
  }

  private get effectiveLevel(): LogLevel {
    if (this._level !== undefined) {
      return this._level;
    }
    return Config.IS_DEBUG ? LogLevel.DEBUG : LogLevel.INFO;
  }

  private shouldLog(level: LogLevel): boolean {
    return level >= this.effectiveLevel;
  }

  debug(format: string, ...args: (string | number | boolean)[]): void {
    if (this.shouldLog(LogLevel.DEBUG)) {
      hilog.debug(this.domain, this.tag, this.tagInFormat + format, ...args);
    }
  }

  info(format: string, ...args: (string | number | boolean)[]): void {
    if (this.shouldLog(LogLevel.INFO)) {
      hilog.info(this.domain, this.tag, this.tagInFormat + format, ...args);
    }
  }

  warn(format: string, ...args: (string | number | boolean)[]): void {
    if (this.shouldLog(LogLevel.WARN)) {
      hilog.warn(this.domain, this.tag, this.tagInFormat + format, ...args);
    }
  }

  error(format: string, ...args: (string | number | boolean)[]): void {
    if (this.shouldLog(LogLevel.ERROR)) {
      hilog.error(this.domain, this.tag, this.tagInFormat + format, ...args);
    }
  }

  fatal(format: string, ...args: (string | number | boolean)[]): void {
    if (this.shouldLog(LogLevel.FATAL)) {
      hilog.fatal(this.domain, this.tag, this.tagInFormat + format, ...args);
    }
  }

  setLevel(level: LogLevel): void {
    this._level = level;
  }

  getLevel(): LogLevel {
    return this.effectiveLevel;
  }
}