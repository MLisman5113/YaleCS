var socket = new WebSocket("ws://cpsc484-01.yale.internal:8888/frames");

var host = "cpsc484-01.yale.internal:8888";

const questions = ["Do you feel satisfied with the quality of career strategy resources you are receiving at Yale University?",
                    "Do you believe that Yale University provides enough opportunities for extracurricular activities?",
                    "Do you find that Yale extracurricular clubs and organizations are overly selective?",
                    "Do you actively participate in Greek Life at Yale?",
                    "Do you think Yale should increase its efforts to accommodate dietary restrictions in dining halls?",
                    "Do you feel satisfied with the quality and availability of mental health resources on campus?",
                    "Do you believe that having an academic advisor was helpful to you in your first two years at Yale?",
                    "Do you feel satisfied with the academic support resources at Yale, including your residential college Dean?", 
                    "Do you like visiting the residential college butteries?", 
                    "Do you believe that TD buttery is the best buttery on campus?",
                    "Have you ever had a roommate horror story at Yale?",
                    "Have you ever found a mouse or a rat in your residential college?",
                    "Have you ever used ChatGPT to help with your homework?",
                    "Given the chance, would you join a secret society in your senior year?", 
                    "Have you switched your intended major more than once since coming to Yale?",
                    "Have you been to Woads more than ten times throughout your time at Yale?",
                    "Have you spoken to your academic advisor at any point in the last academic year?",
                    "Have you had to wait more than an hour for Yale Health services, even if the situation was urgent?",
                    "Do you think that Yale should offer minors or expand its certificate offerings?",
                    "Do you think listening to the bells on Harkness Tower provides a positive experience to Yale students?",
                    "Do you think GHeav's prices are too high considering its target customers?",
                    "Has having suitemates enhanced your Yale experience in a positive way?",
                    "Do you think it is fair that students are charged for laundry and printing?",
                    "Are Yale's science facilities up to date enough to conduct research at its fullest potential?"]


// Retrieve the last question index from local storage or initialize it to 0
let index = localStorage.getItem("index") || 0;


function setup() {
    // get the dimensions of the parent HTML element
  //createCanvas(windowWidth, windowHeight);
}
//
// function draw() {
//     // background(220);
//     // textAlign(CENTER);
//     // textSize(50);
//     // text('Do you think hotdogs are sandwhiches?', windowWidth/2, 100);
//     // text('Stand in front of TV to participate', windowWidth/2, windowHeight - 50);
// }

$(document).ready(function () {
    frames.start();
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

