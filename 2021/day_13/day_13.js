// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

const CANVAS_SIZE = 500;

const circles = [];

function pickRandomPointInCircle(x, y, diameter) {
  const randomAngle = random(TWO_PI);
  const randomRadius = random(0, diameter / 2);
  return createVector(cos(randomAngle) * randomRadius, sin(randomAngle) * randomRadius);
}

function recursiveCircles(x, y, diameter, depth) {
  if (depth == 0) return;
  
  stroke(255, 50);
  noFill();
  strokeWeight(2);
  circle(x, y, diameter);
  
  for (let i = 0; i < depth; i++) {
    const nextPoint = pickRandomPointInCircle(x, y, diameter);
    
    stroke(255, 153, 0, 100);
    strokeWeight(5);
    point(nextPoint.x, nextPoint.y);
    strokeWeight(1);
    line(x, y, nextPoint.x, nextPoint.y);
    
    const distanceFromCenter = dist(x, y, nextPoint.x, nextPoint.y);
    
    const nextDiameter = diameter - (2 * distanceFromCenter);
  
    recursiveCircles(nextPoint.x, nextPoint.y, nextDiameter, depth - 1);
  }
}

const time = 0;

function setup() {
  createCanvas(CANVAS_SIZE, CANVAS_SIZE);
  
  background("#003344");
}

function draw() {
  
  
  translate(width / 2, height / 2);
  
  recursiveCircles(0, 0, 300, 3);
  
  noLoop();
}

