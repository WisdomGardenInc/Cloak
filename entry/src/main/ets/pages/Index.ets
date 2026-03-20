import { Cloak, CloakWebview } from "@wisdomgarden/cloak"

@Entry
@ComponentV2
struct CloakIndex {
  onBackPress(): boolean {
    return Cloak.onBackPress();
  }

  build() {
    Column() {
      CloakWebview()
    }
  }
}
