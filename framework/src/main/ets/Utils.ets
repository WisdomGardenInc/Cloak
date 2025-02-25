import mime from 'mime';
import Config from './Config';

export const getResourcePath = (pathName: string): string => {
  if (pathName === "/") {
    return `${Config.APP_FOLDER}${pathName}index.html`
  } else {
    return `${Config.APP_FOLDER}${pathName}`
  }
}

export const getMimeType = (pathName: string): string => {
  const filename = pathName.split('/').pop() || ''
  const extension = filename.split('.').pop()?.toLowerCase() || ''

  return mime.getType(extension);
}