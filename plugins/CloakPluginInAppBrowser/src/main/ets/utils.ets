import { ICreateBrowserOptions } from './types';


const defaultOpenOptions: ICreateBrowserOptions = {
  session: undefined,
  clearCache: false,
  clearSessionCache: false,
  closeButtonCaption: undefined,
  footer: true,
  footerColor: undefined,
  hideNavigationButtons: false
}

const compatibleOptionsMap = new Map<string, keyof ICreateBrowserOptions>([
  ['clearcache', 'clearCache'],
  ['clearsessioncache', 'clearSessionCache'],
  ['closebuttoncaption', 'closeButtonCaption'],
  ['footercolor', 'footerColor'],
  ['hidenavigationbuttons', 'hideNavigationButtons']
]);

const compatibleOptionsValue = (value?: string | boolean | number | null) => {
  if (typeof value !== 'string') {
    return value;
  }
  switch (value) {
    case 'yes':
      return true;
    case 'no':
      return false;
    default:
      return value;
  }
};




export const getBrowserOptions = (clientOptions: ESObject) => {
  const convertedOptions: ICreateBrowserOptions = {};
  for (const key of Object.keys(clientOptions)) {
    const realKey = compatibleOptionsMap.get(key);
    if (realKey) {
      Reflect.set(convertedOptions, realKey, compatibleOptionsValue(Reflect.get(clientOptions, key)))
    }
  }

  const options: ICreateBrowserOptions = {};

  for (const key of Object.keys(defaultOpenOptions)) {
    if (Reflect.get(convertedOptions, key) !== undefined && Reflect.get(convertedOptions, key) !== null) {
      Reflect.set(options, key, Reflect.get(convertedOptions, key))
    } else {
      Reflect.set(options, key, Reflect.get(defaultOpenOptions, key))
    }
  }

  return options;
}