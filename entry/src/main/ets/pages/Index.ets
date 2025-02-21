import { CloakWebview } from "@wisdomgarden/cloak"


@Entry
@ComponentV2
struct CloakIndex {
  build() {
    Column() {
      CloakWebview()
    }
  }
}
