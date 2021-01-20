// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

class Arrow {
  constructor(originX, originY, nSegments, height) {
    this.origin = createVector(originX, originY);
    
    this.nSegments = nSegments;
    this.segmentSize = height / nSegments;
    
    this.seed = random(10000);
  }
  
  getAngleAtPoint(ratio, offset) {
    return ((ratio - 0.5) * 2) * noise(ratio * 5 + this.seed + offset) * HALF_PI;
  }
  
  display(offset) {
    let currentY = this.origin.y;
    
    noFill();
    
    for (let i = 0; i < this.nSegments; i++) {
      const yRatio = map(i, 0, this.nSegments, 0, 1);
      const yRatioNext = map(i + 1, 0, this.nSegments, 0, 1);
      
      const nextY = currentY + this.segmentSize * yRatio * ((sin(offset + this.seed) + 3.5) / 2);
      
      const angleOffset = ((noise(this.seed + offset / 5) - 0.5) * 2) * PI;
      const angle = this.getAngleAtPoint(yRatio, offset) + angleOffset;
      const angleNext = this.getAngleAtPoint(yRatioNext, offset) + angleOffset;
      
      const length = 10 + (yRatio + 0.2) * 200 * noise(yRatio * 10 + this.seed + offset / 2);
      const handleLength = length * yRatio;
      const handleLengthNext = length * yRatioNext;
      
      const ctrlX1 = this.origin.x + cos(angle) * handleLength;
      const ctrlY1 = currentY + sin(angle) * handleLength;
      
      const ctrlX2 = this.origin.x + cos(PI + angleNext) * handleLengthNext;
      const ctrlY2 = nextY + sin(PI + angleNext) * handleLengthNext;
      
      stroke(255);
      strokeWeight(1);
      bezier(this.origin.x, currentY, ctrlX1, ctrlY1, ctrlX2, ctrlY2, this.origin.x, nextY);
      
      // Display the arrow
      if (i == this.nSegments - 1) {
        stroke("#ff9900");
        strokeWeight(3);
        
        const arrowSize = noise(this.seed) * 30;
        
        line(this.origin.x, nextY, this.origin.x + cos(PI + QUARTER_PI + angleNext) * arrowSize, nextY + sin(PI + QUARTER_PI + angleNext) * arrowSize);
        line(this.origin.x, nextY, this.origin.x + cos(PI - QUARTER_PI + angleNext) * arrowSize, nextY + sin(PI - QUARTER_PI + angleNext) * arrowSize);
      }
      
      currentY = nextY;
    }
  }
}

const nArrows = 15;
const gap = 20;
const arrows = [];
let offset = 0;

function setup() {
  createCanvas(500, 500);
  
  const startX = (width - gap * nArrows) / 2;
  for (let i = 0; i < nArrows; i++) {
    arrows.push(new Arrow(startX + i * gap, 50, 10, random(250, 400)));
  }
}

function draw() {
  background("#003344");
  
  for (const arrow of arrows) {
    arrow.display(offset);
  }
  
  offset += 0.05;
}
