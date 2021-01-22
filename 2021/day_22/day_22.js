// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Draw quads with diferent thickness and sizes to display lines
 */
function pseudoLine(divisions, thickness, margin, offset) {
  const points = [];
  
  const newWidth = width - 2 * margin;
  const newHeight = height - 2 * margin;
  
  // Compute the middle points of the quads for faster lookup
  for (let i = 0; i <= divisions; i++) {
    const n = map(i, 0, divisions, 0, 1);
    
    const nFromCenter = abs(0.5 - n) * 2;
    
    //const offsetX = sin(n * TWO_PI * 2 + offset) * 100;
    const offsetX = n * newWidth;
    const offsetY = sin(n * TWO_PI + offset) * 40 * (1 - nFromCenter);
    
    const offRad = (1 - nFromCenter) * 50;
    
    points.push({
      x: offsetX + cos(n * TWO_PI + offset) * offRad,
      y: margin + i * (newHeight / divisions) + offsetY + sin(n * TWO_PI * 10 + offset) * offRad,
      normFromCenter: nFromCenter
    });
  }
  
  for (let i = 0; i < divisions; i++) {
    const current = points[i];
    const next = points[i + 1];
    
    fill(255, 153, 0);

    // Stroke same color as background to "erase" stuff
    stroke("#003344");
    
    strokeWeight(thickness * 1 / (current.normFromCenter + 2.5));
    
    quad(margin, current.y,
         margin + current.x, current.y,
         margin + next.x, next.y,
         margin, next.y);
    
    quad(margin + current.x, current.y, 
         width - margin, current.y, 
         width - margin, next.y, 
         margin + next.x, next.y);
  }
}

let offset = 0;
const margin = 80;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  
  pseudoLine(20, 10, margin, offset);
 
  offset += 0.02;
}
