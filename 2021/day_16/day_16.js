// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

const blue = "#003344";
const yellow = "#ff9900";

function easeInOutQuint(x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

function easeOffset(offset) {
  return easeInOutQuint((cos(offset) + 1) / 2) - easeInOutQuint((sin(offset / 2)));
}

function circlePattern(x, y, size, offset) {
  push();
  translate(x, y);
  
  const osc = easeOffset(offset);
  const oscHP = easeOffset(offset + HALF_PI);
  const oscP = easeOffset(offset + PI);
  
  rotate(osc * HALF_PI);
  
  const half = size / 2;
  
  strokeWeight(5);
  
  fill(255);
  stroke(yellow);
  circle(0, 0, size);
  
  fill(blue);
  stroke(blue);
  circle(half * osc, 0, size * 0.75);
  circle(-half * osc, 0, size * 0.75);
  
  circle(0, half, half * osc);
  circle(0, -half, half * osc);
  
  strokeWeight(10);
  
  fill(yellow);
  circle(half, 0, half);
  circle(-half, 0, half);
  
  circle(0, 0, half * 0.75 * oscP);
  
  fill(blue);
  stroke(yellow);
  circle(half * oscHP, (half / 2) * oscHP, half / 2);
  circle(-half * oscHP, (-half / 2) * oscHP, half / 2);
  
  circle(half, 0, (half / 4) * oscHP);
  circle(-half, 0, (half / 4) * oscHP);
  pop();
}

let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background(blue);
  
  circlePattern(width / 2, height / 2, 250, offset);
  
  offset += 0.05;
}

