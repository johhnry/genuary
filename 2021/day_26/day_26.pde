// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Line class that contains a linear equation y = a * x + b
 * can't be vertical by definition
 */
class Line {
  PVector start, end, p1, p2;
  float a, b;
  
  Line(PVector p1, PVector p2) {
    this.start = p1;
    this.end = p2;
    
    this.a = (p2.y - p1.y) / (p2.x - p1.x);
    this.b = p1.y - p1.x * this.a;
  }
  
  /**
   * Return y coordinate of point at location x
   */
  float getYAt(float x) {
    return this.a * x + this.b;
  }
  
  /**
   * Compute the intersection of two lines
   * Return null if they are parallel
   */
  PVector intersect(Line line) {
    float sub = this.a - line.a;
    if (sub == 0) return null;
    
    float x = (line.b - this.b) / sub;
    float y = this.getYAt(x);
    return new PVector(x, y);
  }
  
  /**
   * Display the line between original end and last points
   */
  void display() {
    line(this.start.x, this.start.y, this.end.x, this.end.y);
  }
}

/**
 * Vertical line class, that is x = j
 */
class VerticalLine {
  float x;
  
  VerticalLine(float x) {
    this.x = x;
  }
  
  /**
   * Compute the intersection with a line
   * Return null otherwise
   */
  PVector intersect(Line line) {
    return new PVector(this.x, line.getYAt(this.x));
  }
  
  /** 
   * Display the vertical line between yMin and yMax
   */
  void display(float yMin, float yMax) {
    line(this.x, yMin, this.x, yMax);
  }
}

/**
 * Return the geometric middle point between two points
 */
PVector getMiddlePoint(PVector p1, PVector p2) {
  return new PVector((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

/**
 * Draw a point from a vector object
 */
void drawVertex(PVector p) {
  point(p.x, p.y);
}

/**
 * Draw a quad given 4 points as vectors
 */
void drawQuad(PVector a, PVector b, PVector c, PVector d) {
  quad(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y);
}

class PerspectiveCube {
  PVector vp1, vp2, centerCorner;
  float size;
  
  PerspectiveCube(float x1, float y1, float x2, float y2, float cx, float cy, float size) {
    this.vp1 = new PVector(x1, y1);
    this.vp2 = new PVector(x2, y2);
    this.centerCorner = new PVector(cx, cy);
    this.size = size;
  }
  
  void display() {
    PVector downCorner = PVector.add(this.centerCorner, new PVector(0, this.size));
    
    // Up
    Line vline1Up = new Line(this.vp1, this.centerCorner);
    Line vline2Up = new Line(this.vp2, this.centerCorner);
    
    // Down
    Line vline1Down = new Line(this.vp1, downCorner);
    Line vline2Down = new Line(this.vp2, downCorner);
    
    // Frontal edge
    VerticalLine frontEdge = new VerticalLine(this.centerCorner.x);
    
    PVector leftUpCorner = getMiddlePoint(this.vp1, this.centerCorner);
    VerticalLine leftEdge = new VerticalLine(leftUpCorner.x);
    
    PVector rightUpCorner = getMiddlePoint(this.vp2, this.centerCorner);
    VerticalLine rightEdge = new VerticalLine(rightUpCorner.x);
    
    PVector leftDownCorner = getMiddlePoint(this.vp1, downCorner);
    PVector rightDownCorner = getMiddlePoint(this.vp2, downCorner);  
    
    Line vline1BackUp = new Line(this.vp1, rightUpCorner);
    Line vline2BackUp = new Line(this.vp2, leftUpCorner);
    
    PVector backCornerUp = vline1BackUp.intersect(vline2BackUp);
    
    Line vline1BackDown = new Line(this.vp1, rightDownCorner);
    Line vline2BackDown = new Line(this.vp2, leftDownCorner);
    
    PVector backCornerDown = vline1BackDown.intersect(vline2BackDown);
    VerticalLine backEdge = new VerticalLine(backCornerUp.x);

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

PerspectiveCube cube;
float offset = 0;

void setup() {
  size(500, 500);
  
  cube = new PerspectiveCube(50, 150, width - 50, 150, width / 2, height / 2, 150);
}

void draw() {
  background(#003344);
  
  cube.centerCorner.x = width / 2 + sin(offset / 2) * cos(offset) * 100;
  cube.centerCorner.y = height / 2 + sin(offset / 2) * 50;
  
  cube.vp1.x = 100 + sin(offset / 2) * 50;
  cube.vp2.x = height - 100 + cos(offset / 2) * 50;
  
  cube.vp1.y = height / 2 + sin(-offset) * 100;
  cube.vp2.y = height / 2 + cos(-offset) * 100;
  
  cube.display();
  
  offset += 0.03;
}

