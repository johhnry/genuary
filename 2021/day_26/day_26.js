// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Line class that contains a linear equation y = a * x + b
 * can't be vertical by definition
 */
class Line {
  constructor(p1, p2) {
    this.start = p1;
    this.end = p2;
    
    this.a = (p2.y - p1.y) / (p2.x - p1.x);
    this.b = p1.y - p1.x * this.a;
  }
  
  /**
   * Return y coordinate of point at location x
   */
  getYAt(x) {
    return this.a * x + this.b;
  }
  
  /**
   * Compute the intersection of two lines
   * Return null if they are parallel
   */
  intersect(line) {
    const sub = this.a - line.a;
    if (sub === 0) return null;
    
    const x = (line.b - this.b) / sub;
    const y = this.getYAt(x);
    return createVector(x, y);
  }
  
  /**
   * Display the line between original end and last points
   */
  display() {
    line(this.start.x, this.start.y, this.end.x, this.end.y);
  }
}

/**
 * Vertical line class, that is x = j
 */
class VerticalLine {
  constructor(x) {
    this.x = x;
  }
  
  /**
   * Compute the intersection with a line
   * Return null otherwise
   */
  intersect(line) {
    if (!(line instanceof Line)) return null;
    return createVector(this.x, line.getYAt(this.x));
  }
  
  /** 
   * Display the vertical line between yMin and yMax
   */
  display(yMin, yMax) {
    line(this.x, yMin, this.x, yMax);
  }
}

/**
 * Return the geometric middle point between two points
 */
function getMiddlePoint(p1, p2) {
  return createVector((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

/**
 * Draw a point from a vector object
 */
function drawVertex(p) {
  point(p.x, p.y);
}

/**
 * Draw a quad given 4 points as vectors
 */
function drawQuad(a, b, c, d) {
  quad(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y);
}

class PerspectiveCube {
  constructor(x1, y1, x2, y2, cx, cy, size) {
    this.vp1 = createVector(x1, y1);
    this.vp2 = createVector(x2, y2);
    this.centerCorner = createVector(cx, cy);
    this.size = size;
  }
  
  display() {
    const downCorner = p5.Vector.add(this.centerCorner, createVector(0, this.size));
    
    // Up
    const vline1Up = new Line(this.vp1, this.centerCorner);
    const vline2Up = new Line(this.vp2, this.centerCorner);
    
    // Down
    const vline1Down = new Line(this.vp1, downCorner);
    const vline2Down = new Line(this.vp2, downCorner);
    
    // Frontal edge
    const frontEdge = new VerticalLine(this.centerCorner.x);
    
    const leftUpCorner = getMiddlePoint(this.vp1, this.centerCorner);
    const leftEdge = new VerticalLine(leftUpCorner.x);
    
    const rightUpCorner = getMiddlePoint(this.vp2, this.centerCorner);
    const rightEdge = new VerticalLine(rightUpCorner.x);
    
    const leftDownCorner = getMiddlePoint(this.vp1, downCorner);
    const rightDownCorner = getMiddlePoint(this.vp2, downCorner);  
    
    const vline1BackUp = new Line(this.vp1, rightUpCorner);
    const vline2BackUp = new Line(this.vp2, leftUpCorner);
    
    const backCornerUp = vline1BackUp.intersect(vline2BackUp);
    
    const vline1BackDown = new Line(this.vp1, rightDownCorner);
    const vline2BackDown = new Line(this.vp2, leftDownCorner);
    
    const backCornerDown = vline1BackDown.intersect(vline2BackDown);
    const backEdge = new VerticalLine(backCornerUp.x);

    stroke(255, 153, 0);
    
    strokeWeight(1);
    leftEdge.display(leftUpCorner.y, leftDownCorner.y);
    rightEdge.display(rightUpCorner.y, rightDownCorner.y);
    
    vline1BackUp.display();
    vline2BackUp.display();
    
    vline1BackDown.display();
    vline2BackDown.display();
    
    vline1Up.display();
    vline2Up.display();
    
    vline1Down.display();
    vline2Down.display();
    
    frontEdge.display(this.centerCorner.y, downCorner.y);
    
    strokeWeight(10);
    drawVertex(leftUpCorner);
    drawVertex(rightUpCorner);
    drawVertex(leftDownCorner);
    drawVertex(rightDownCorner);
    drawVertex(this.vp1);
    drawVertex(this.vp2);
    
    drawVertex(this.centerCorner);
    drawVertex(downCorner);
    
    drawVertex(backCornerUp);
    
    // Display back semi transparent
    stroke(255, 153, 0, 100);
    
    strokeWeight(10);
    drawVertex(backCornerDown);
    
    strokeWeight(2);
    backEdge.display(backCornerUp.y, backCornerDown.y);
    
    fill(255, 153, 0, 100);
    drawQuad(leftUpCorner, backCornerUp, backCornerDown, leftDownCorner);
    drawQuad(rightUpCorner, backCornerUp, backCornerDown, rightDownCorner);
    
    drawQuad(rightUpCorner, this.centerCorner, downCorner, rightDownCorner);
    drawQuad(leftUpCorner, this.centerCorner, downCorner, leftDownCorner);
    
    fill(255, 153, 50, 150);
    drawQuad(this.centerCorner, leftUpCorner, backCornerUp, rightUpCorner);
    drawQuad(downCorner, leftDownCorner, backCornerDown, rightDownCorner);
  }
}

let cube;
let offset = 0;

function setup() {
  createCanvas(500, 500);
  
  cube = new PerspectiveCube(50, 150, width - 50, 150, width / 2, height / 2, 150);
}

function draw() {
  background("#003344");
  
  cube.centerCorner.x = width / 2 + sin(offset / 2) * cos(offset) * 100;
  cube.centerCorner.y = height / 2 + sin(offset / 2) * 50;
  
  cube.vp1.x = 100 + sin(offset / 2) * 50;
  cube.vp2.x = height - 100 + cos(offset / 2) * 50;
  
  cube.vp1.y = height / 2 + sin(-offset) * 100;
  cube.vp2.y = height / 2 + cos(-offset) * 100;
  
  cube.display();
  
  offset += 0.03;
}

