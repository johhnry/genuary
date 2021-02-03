// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

function band(x, y, w, h, gap, nBands, offset) {
  push();
  translate(x, y);
  
  fill("#ff9900");
  noStroke();
  
  const size = h - ((nBands - 1) * gap);
  let ratio = 0;
  
  for (let i = 0; i < nBands; i++) {
    let pieceRatio;
    
    if (i == nBands - 1) {
      pieceRatio = 1 - ratio;
    } else {
      pieceRatio = noise(ratio / 5 + offset + i * 0.5) * (1 - ratio) * 0.9;
    }
    
    const yy = ratio * size + i * gap;
    
    rect(0, yy, w, pieceRatio * size);
    
    ratio += pieceRatio;
  }
  
  pop();
}

const margin = 70;
const nBands = 5;
const gap = 10;
let bandSize;
let bandWidth;
let offset = 0;

function setup() {
  createCanvas(500, 500);
  
  // The size of the band
  bandSize = width - 2 * margin;
  
  // The thickness of each band, considering the gaps
  bandWidth = (bandSize - ((nBands - 1) * gap)) / nBands;
}

function draw() {
  background("#003344");
  
  // Draw the bands
  for (let i = 0; i < nBands; i++) {
    const x = margin + i * (bandWidth + gap);
    const bandOffset = cos(TWO_PI + offset + i * 5) / 5;
    
    band(x, margin, bandWidth, bandSize, gap, 6, bandOffset);
  }
  
  offset += 0.05;
}

