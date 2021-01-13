// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// Initialize activity with empty object
let activity = {activity:"", type:""};

/**
 * Get new activity as JSON from : http://www.boredapi.com/api/activity/
 * using xhr request
 */
function getNewActivity() {
  const requestURL = "https://www.boredapi.com/api/activity/";

  const request = new XMLHttpRequest();

  request.open('GET', requestURL);
  request.responseType = 'json';
  request.send();

  request.onload = function() {
    activity = request.response;
  }
}

/**
 * Display a bone like shape where (x, y) is the origin
 * length and rotation
 */
function vThickLine(x, y, d1, d2, length, rotation) {
  push();
  translate(x, y);
  rotate(rotation);
  
  // Upper half circle
  beginShape();
  const r2 = d2 / 2;
  for (let angle = PI; angle < TWO_PI; angle += 0.1) {
    vertex(cos(angle) * r2, sin(angle) * r2 - length);
  }
  
  // Down half circle
  const r1 = d1 / 2;
  for (let angle = 0; angle < PI; angle += 0.1) {
    vertex(cos(angle) * r1, sin(angle) * r1);
  }
  
  // Connect the two
  endShape(CLOSE);

  pop();
}

/**
 * Draw a bored person
 */
function bored(x, y, vSize, factor) {
  push();
  translate(x, y);
  
  noStroke();
  fill(255, 200);
  
  // Too much consts and variables here, not optimized at all
  // but it's procedural anyway
  const headWidth = 60;
  const headHeight = 80;
  
  const headY = headHeight / 2 + (vSize - headHeight / 2) * factor;

  const armLength = vSize - headHeight / 2;
  const lowerDiameter = 30;
  const upperDiameter = 10;
  const handDiameter = upperDiameter / 2;
  
  const handX = (headWidth + upperDiameter) / 2;
  
  const armY = headY - headHeight / 2;
  const armOffset = sqrt((armLength ** 2) - (armY ** 2));
  const armRotation = acos(armOffset / armLength) - HALF_PI;
  const armX = handX + armOffset;
  
  // Shoulders
  const shoulderDiameter = lowerDiameter * 1.2;
  vThickLine(-headWidth / 2, -(headY - headHeight / 2), shoulderDiameter, lowerDiameter, armLength, -armRotation + PI);
  vThickLine(headWidth / 2, -(headY - headHeight / 2), shoulderDiameter, lowerDiameter, armLength, armRotation + PI);
  
  // Arms
  vThickLine(-armX, 0, lowerDiameter, upperDiameter, armLength, -armRotation);
  vThickLine(armX, 0, lowerDiameter, upperDiameter, armLength, armRotation);
  
  // Hands
  vThickLine(-handX, -armY, upperDiameter, handDiameter, headHeight / 1.5, 0);
  vThickLine(handX, -armY, upperDiameter, handDiameter, headHeight / 1.5, 0);
  
  // Head
  ellipse(0, -headY, headWidth, headHeight);
  
  // Eyes
  stroke("#ff9900");
  strokeWeight(10);
  point(-headWidth / 4, -headY);
  point(headWidth / 4, -headY);
  
  // Mouth
  strokeWeight(2);
  noFill();
  arc(0, -headY + headHeight / 5, 20, factor * 20, 0, PI);
  
  // eyes black dots
  stroke(0);
  strokeWeight(5);
  point(-headWidth / 4 + cos(armRotation * 4) * 2.5, -headY);
  point(headWidth / 4 + cos(armRotation * 4) * 2.5, -headY);

  pop();
}

let offset = 0;
let time = 0;
const incr = 0.03;

function preload() {
  getNewActivity();
}

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");

  translate(width / 2, height / 2 + 50);

  bored(0, 0, 150, (sin(offset) + 1) / 2);
  
  // Text display
  textSize(8);
  stroke("#ff9900");
  strokeWeight(50);
  line(-200, 105, 200, 105);
  
  textAlign(CENTER, CENTER);
  fill(255);
  noStroke();
  
  textSize(15);
  textStyle(NORMAL);
  text("You're bored? Just : ", 0, -220);
  
  fill(255);
  textStyle(BOLD);
  text(activity.activity, 0, 100);
  
  textSize(8);
  text("type : " + activity.type, 0, 120);
  
  // Get new activity each cycle
  if (offset - time > TWO_PI) {
    getNewActivity();
    time = offset;
  }
  
  offset += incr;
}
