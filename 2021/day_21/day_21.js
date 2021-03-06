// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// Min and max values of x
const MIN_VALUE = 10;
const MAX_VALUE = 200;

/**
 * Main draw function, the offset controls the animation
 */
function DRAW(x, offset) {
  // Normalized value from 0 to 1 for a call with x
  const norma = map(x, MIN_VALUE, MAX_VALUE, 0, 1);
 
  push();
  
  rotate(norma * TWO_PI + offset + cos(x / 100 + offset) * HALF_PI);
  
  strokeWeight(x / 20);
  noFill();
  stroke(255, 80);
  ellipse(0, 0, x, x * 2);
 
  stroke(255, 153, 0, (1 - norma) * 255);
  strokeWeight(norma * 50);
  point(x, norma * x + cos(offset) * 50);
 
  rotate(PI);
  point(x, norma * x + sin(offset) * 50);
  
  pop();
}

/**
* From : https://genuary2021.github.io/prompts#jan15
*/
function f(x, offset) {
  if (x < MIN_VALUE) return;
  DRAW(x, offset);
  f(1 * x / 4, offset);
  f(2 * x / 4, offset);
  f(3 * x / 4, offset);
}

let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
 
  translate(width / 2, height / 2);
  f(MAX_VALUE, offset);
 
  offset += 0.02;
}
