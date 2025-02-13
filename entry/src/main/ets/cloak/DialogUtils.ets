export const showAlert =
  (message: string, gotResult: (success: boolean, message: string | null) => void) => {
    AlertDialog.show({
      message,
      autoCancel: false,
      isModal: true,
      cancel: () => {
        gotResult(false, null)
      },
      confirm: {
        value: "OK",
        action: () => {
          gotResult(true, null)
        }
      }
    })
  }


export const showConfirm = (message: string, gotResult: (success: boolean, message: string | null) => void) => {
  AlertDialog.show({
    message: message,
    autoCancel: false,
    primaryButton: {
      value: 'Confirm',
      action: () => {
        gotResult(true, null)
      }
    },
    secondaryButton: {
      value: 'Cancel',
      action: () => {
        gotResult(false, null)
      }
    },
    cancel: () => {
      gotResult(false, null)
    }
  })
}