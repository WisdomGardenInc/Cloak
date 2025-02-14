import CloakPlugin from "./CloakPlugin";

export function PluginMethod (target: CloakPlugin, propertyName: string, descriptor: PropertyDescriptor) {
  target.addPluginMethod(propertyName);
}