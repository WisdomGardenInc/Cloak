export const showAlert =
  (message: string | Resource, gotResult: (success: boolean, message: string | null,) => void,
    title: string | Resource = "") => {
    AlertDialog.show({
      title,
      message,
      autoCancel: false,
      isModal: true,
      cancel: () => {
        gotResult(false, null)
      },
      confirm: {
        value: $r('app.string.common_ui_dialog_ok'),
        action: () => {
          gotResult(true, null)
        }
      }
    })
  }


export const showConfirm =
  (message: string | Resource, gotResult: (success: boolean, message: string | null) => void,
    title: string | Resource = "") => {
    AlertDialog.show({
      title,
      message,
      autoCancel: false,
      primaryButton: {
        value: $r('app.string.common_ui_dialog_confirm'),
        action: () => {
          gotResult(true, null)
        }
      },
      secondaryButton: {
        value: $r('app.string.common_ui_dialog_cancel'),
        action: () => {
          gotResult(false, null)
        }
      },
      cancel: () => {
        gotResult(false, null)
      }
    })
  }