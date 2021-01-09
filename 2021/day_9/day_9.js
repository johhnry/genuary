// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

function circles(x, y, size, nCircles, offset, thick = 5, yellow = false) {
  noFill();
  
  stroke(255, 200);
  
  for (let i = 0; i < nCircles; i++) {
    const factor = (i / nCircles);
    const newSize = factor * size;
    
    strokeWeight(abs(cos(factor * 5 + offset)) * thick + 5)
    circle(x + cos(factor - offset) * size / 8, y, newSize);
  }
}

let offset = 0;
const size = 300;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  
  translate(width / 2, height / 2);
  
  circles(0, 0, size - cos(offset) * 50, 10, offset);
  circles(0, 0, size + cos(offset) * 50, 10, offset * 2);
  
  offset += 0.02;
}
