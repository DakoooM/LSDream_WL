const displayedText = [
    "Tips: ne passez pas trop de temps sur les points de drogues", 
    "Tips: ne tirer pas dans des rues ou il y a des gens", 
    "Tips: N'osez pas faire de la D", 
    "Tips: Faites vous acceptez en jouant rp", 
]

var count = 0;
var thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) {
        if (data.count != undefined)
            count = data.count;
    },

    initFunctionInvoking(data) {
        if (data.idx != undefined)
            var thingy = document.getElementById("thingyChange");
            thingy.style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        if (data.count != undefined)
            count = data.count;
    },

    performMapLoadFunction(data) {
        ++thisCount;
        var thingy = document.getElementById("thingyChange");
        thingy.style.width = ((thisCount / count) * 100) + '%';
    },
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});

const getRandomInt = (max) => {
    return Math.floor(Math.random() * max);
}

setInterval(() => {
   if (displayedText.length > 1) {
       const randomResult = displayedText[Math.floor(Math.random() * displayedText.length)];
       document.getElementById("changeText").innerHTML = randomResult + " TAMER - " + event.data.eventName
   }
}, 5000)