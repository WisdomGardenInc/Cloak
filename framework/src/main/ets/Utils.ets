import mime from 'mime';
import Config from './Config';

interface IResourceInfo {
  resourcePath: string,
  extension: string
}

export const getResourceInfo = (pathName: string): IResourceInfo => {
  // Simple handling, check the extension rather than checking if the file exists.
  const filename = pathName.split('/').pop() || '';
  const extensionInfo = filename.split('.');
  let extension = extensionInfo.length > 1 ? (extensionInfo.pop()?.toLowerCase() || '') : '';

  let resourcePath = `${Config.APP_FOLDER}${pathName}`;
  if (extension === '') {
    resourcePath = `${Config.APP_FOLDER}/index.html`;
    extension = 'html';
  }

  return { resourcePath, extension };
}

export const getMimeType = (extension: string): string => {
  return mime.getType(extension);
}