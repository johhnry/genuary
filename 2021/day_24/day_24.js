// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Display a square of n * n lines
 */
function squareOfLines(x, y, n, size, offset) {
  push();
  translate(x, y);
  
  const cellSize = size / n;
  
  for (let i = 0; i < n; i++) {
    const xx = i * cellSize;
    for (let j = 0; j < n; j++) {
      const yy = j * cellSize;
      
      const noiseOffset = noise(i + cos(offset) * 5, j + sin(offset) * 5);
      
      stroke("#ff9900");
      strokeWeight(noiseOffset * 4);
      line(xx, yy + cellSize * (1 - noiseOffset), xx + cellSize * noiseOffset * cos(offset + i / 10) * 2, yy );
    }
  }
  
  pop();
}

let offset = 0;

// Margin between the grid and the canvas
const margin = 50;

// Gap between squares of lines
const gap = 5;

// Size of the square of lines
const n = 5;

let totalSize, cellSize, start;


function setup() {
  createCanvas(500, 500);
  
  totalSize = (width - 2 * margin);
  cellSize = (totalSize - gap * (n - 1)) / n;
  start = (width - totalSize) / 2;
}

function draw() {
  background("#003344");
  
  for (let i = 0; i < n; i++) {
    const x = start + i * (cellSize + gap);
    for (let j = 0; j < n; j++) {
      const y = start + j * (cellSize + gap);
      
      squareOfLines(x, y, 10, cellSize, offset + i + j);
    }
  }
  
  offset += 0.05;
}

