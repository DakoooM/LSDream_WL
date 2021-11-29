window.addEventListener("message", (event) => {
    if (event.data.type == "loadBar") {
        switch (event.data.showLoad) {
            case true:
                $("#loadingBar").fadeIn(200)
                const writeId = document.getElementById("writeLoadText");
                writeId.innerHTML = event.data.loadText;
                break
            case false:
                $("#loadingBar").fadeOut(200)
                break
            default:
        } 
    } else if (event.data.type == "statsBar") {
        switch (event.data.showStatus) {
            case true:
                $("#statusBar").fadeIn(200)
                break
            case false:
                $("#statusBar").fadeOut(200)
                break
            default:
        } 
    } 
});