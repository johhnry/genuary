// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Anchor point of a bezier curve
 * It has a location and describe the control point
 * with polar coordinates
 */
class AnchorPoint {
  float x, y, rotation, length;
  
  AnchorPoint(float x, float y, float rotation, float length) {
    this.x = x;
    this.y = y;
    this.rotation = rotation;
    this.length = length;
  }
  
  /**
   * Return x coordinate of control point
   */
  float getControlX() {
    return this.x + cos(this.rotation) * this.length;
  }
  
  /**
   * Return y coordinate of control point
   */
  float getControlY() {
    return this.y + sin(this.rotation) * this.length;
  }
  
  void display() {
    stroke(#ff9900);
    strokeWeight(4);
    line(this.getControlX(), this.getControlY(), this.x, this.y);
    
    strokeWeight(10);
    stroke(255);
    point(this.x, this.y);
  }
}

/**
 * Bezier curve class contains an array of anchor points
 */
class BezierCurve {
  ArrayList<AnchorPoint> anchorPoints;
  
  BezierCurve() {
    this.anchorPoints = new ArrayList<AnchorPoint>();
  }
  
  /**
   * Add a new anchor point
   */
  void addPoint(AnchorPoint anchorPoint) {
    this.anchorPoints.add(anchorPoint);
  }
  
  void display(float offset) {
    for (int i = 0; i < this.anchorPoints.size() - 1; i++) {
      AnchorPoint pt = this.anchorPoints.get(i);
      AnchorPoint nextPt = this.anchorPoints.get(i + 1);
      
      stroke(255, 200);
      strokeWeight(2);
      noFill();
      bezier(pt.x, pt.y, pt.getControlX(), pt.getControlY(), nextPt.x, nextPt.y, nextPt.getControlX(), nextPt.getControlY());
      
      pt.rotation = offset + i * 0.5;
      pt.display();
    }
    
    // Display last point
    AnchorPoint last = this.anchorPoints.get(this.anchorPoints.size() - 1);
    last.rotation = offset;
    last.display();
  }
}

/**
 * Return a random bezier curve inside the canvas with a margin
 */
BezierCurve randomCurve(int nPoints, float margin) {
  BezierCurve curve = new BezierCurve();
  
  for (int i = 0; i < nPoints; i++) {
    float x = random(margin, width - margin);
    float y = random(margin, height - margin);
    float length = random(10, 50);
    float rotation = random(TWO_PI);
    
    curve.addPoint(new AnchorPoint(x, y, rotation, length));
  }
  
  return curve;
}

BezierCurve curve;
float offset = 0;

void setup() {
  size(500, 500);
  
  curve = randomCurve(15, 70);
}

void draw() {
  background(#003344);
  
  curve.display(offset);
  
  offset += 0.05;
}
