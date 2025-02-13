window.onload = function () {
    document.querySelector("div.demo").innerText = window.location.href + "\n" + window.navigator.userAgent;
}


const onAlert = () => {
    const result = alert("alert content")
    console.log(result)
}

const onConfirm = () => {
    const result = confirm("confirm")
    console.log(result)
}