// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Bubble shape (like conversation icon)
 */
function bubble(x, y, size, rotation) {
  noFill();
  stroke(255);
  strokeWeight(5);
  
  push();
  translate(x, y);
  rotate(rotation);
  
  arc(0, 0, size, size, HALF_PI, 0);
  
  const half = size / 2;
  
  line(half, 0, half, half);
  line(0, half, half, half);
  
  pop();
}

/**
 * Rotating bubbles with gap
 */
function bubbles(x, y, size, rotation, offset) {
  const gap = (cos(offset) + 2) * 20;
  
  let i = 0;
  for (let radius = size; radius > 0; radius -= gap) {
    const rotationOffset = sin(offset * 2 + i * 0.1) * TWO_PI;
    bubble(x, y, radius, rotation + rotationOffset);
    i++;
  }
}

// Size of the bubbles
const size = 150;
const gap = 10;

// Animation offset
let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  
  translate(width / 2, height / 2);
  
  const bOffset = gap + size / 2;

  // Symmetry is here!
  bubbles(-bOffset, -bOffset, size, 0, offset);
  bubbles(bOffset, -bOffset, size, HALF_PI, offset);
  bubbles(-bOffset, bOffset, size, -HALF_PI, offset);
  bubbles(bOffset, bOffset, size, PI, offset);
  
  offset += 0.01;
}

