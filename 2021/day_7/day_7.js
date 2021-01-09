// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// The margin of the canvas
var margin = 100;

/**
 * Draw a pen from the tip with rotation
 */
function pen(x, y, width, height, rotation) {
  // The ratio of the different parts compared to the total height
  const ratios = [0.12, 0.28, 0.5, 0.1];

  push();
  translate(x, y);
  rotate(rotation);

  strokeJoin(ROUND);
  fill("#003344");
  stroke("#ff9900");
  strokeWeight(4);
  
  // Tip
  const h = width / 2;
  const spikeHeight = ratios[0] * height;
  triangle(0, 0, -h, -spikeHeight, h, -spikeHeight);
  
  // Body
  const bodyHeight = (ratios[1] + ratios[2]) * height;
  const lineHeight = spikeHeight + ratios[1] * height;
  line(-h, -lineHeight, h, -lineHeight);
  rect(-h, -(spikeHeight + bodyHeight), width, bodyHeight);
  
  // Eraser
  arc(0, -((1 - ratios[3]) * height), width, width, PI, TWO_PI);

  pop();
}

/**
 * Display the pen and the stroke
 */
function penOnPaper(offset) {
  let off = 0.1;
  
  noFill();
  stroke(255);
  strokeWeight(3);
  
  const w = (width - 2 * margin) / 2;
  let lastX = 0;
  
  beginShape();
  for (let y = margin; y < height - margin; y += off) {
    const t = map(y, margin, height - margin, 0, 1);
    const angle = log(t + 0.05) * 15;
    const x = cos(angle + offset) * w + width / 2;
    
    curveVertex(x, y);
    off += 0.05;
    
    if (y + off * 2 >= height - margin && lastX == 0) lastX = x;
  }
  endShape();
  
  pen(lastX, height - margin, 20, 120, -cos(offset) * QUARTER_PI);
}

let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");

  penOnPaper(offset);

  offset += 0.04;
}
