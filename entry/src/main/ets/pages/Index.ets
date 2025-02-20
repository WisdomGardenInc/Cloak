import CloakWebview from '../cloak/Webview';


@Entry
@ComponentV2
struct CloakIndex {
  build() {
    Column() {
      CloakWebview()
    }
  }
}
