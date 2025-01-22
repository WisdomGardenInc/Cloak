export const showAlert = (message: string) => {
  AlertDialog.show({
    title: 'Debug',
    message,
  })
}