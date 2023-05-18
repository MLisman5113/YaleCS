var socket = new WebSocket("ws://cpsc484-01.yale.internal:8888/frames");

var host = "cpsc484-01.yale.internal:8888";
function setup() {
    // get the dimensions of the parent HTML element
//    createCanvas(windowWidth, windowHeight);

}

function draw() {
    // background(220);
    // textAlign(CENTER);
    // textSize(50);
    // text('Do you think hotdogs are sandwhiches?', windowWidth/2, 100);
    // text('Stand in front of TV to participate', windowWidth/2, windowHeight - 50);
  }


$(document).ready(function () {
    frames.start();
    index = 0;
    localStorage.setItem("index", index);
    question.text(questions[index]);
});

var frames = {
    socket: null,

    start: function () {
        var url = "ws://" + host + "/frames";
        frames.socket = new WebSocket(url);
        frames.socket.onmessage = function (event) {
            frames.show(JSON.parse(event.data));
        }
    },

    show: function (frame) {
        console.log(frame);
    }
};

