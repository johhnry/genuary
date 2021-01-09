// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

class AnchorPoint {
  constructor(x, y, rotation, length) {
    this.x = x;
    this.y = y;
    this.rotation = rotation;
    this.length = length;
  }
  
  getControlX() {
    return this.x + cos(this.rotation) * this.length;
  }
  
  getControlY() {
    return this.y + sin(this.rotation) * this.length;
  }
  
  display() {
    stroke("#ff9900");
    strokeWeight(4);
    line(this.getControlX(), this.getControlY(), this.x, this.y);
    
    strokeWeight(10);
    stroke(255);
    point(this.x, this.y);
  }
}

class BezierCurve {
  constructor() {
    this.anchorPoints = [];
  }
  
  addPoint(anchorPoint) {
    this.anchorPoints.push(anchorPoint);
  }
  
  display(offset) {
    for (let i = 0; i < this.anchorPoints.length - 1; i++) {
      const pt = this.anchorPoints[i];
      const nextPt = this.anchorPoints[i + 1];
      
      stroke(255, 200);
      strokeWeight(2);
      noFill();
      bezier(pt.x, pt.y, pt.getControlX(), pt.getControlY(), nextPt.x, nextPt.y, nextPt.getControlX(), nextPt.getControlY())
      
      pt.rotation = cos(i * 0.1 + offset) * TWO_PI;
      pt.display();
    }
  }
}

function randomCurve(nPoints) {
  const curve = new BezierCurve();
  const margin = 50;
  
  for (let i = 0; i < nPoints; i++) {
    const x = random(margin, width - margin);
    const y = random(margin, height - margin);
    const length = random(5, 50);
    const rotation = random(TWO_PI);
    
    curve.addPoint(new AnchorPoint(x, y, rotation, length));
  }
  
  return curve;
}

let curve;

function setup() {
  createCanvas(500, 500);
  
  curve = randomCurve(20);
}

function draw() {
  background("#003344");
  
  curve.display();
  
  //noLoop();
}
