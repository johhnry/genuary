// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

class Arrow {
  PVector origin;
  int nSegments, seed;
  float segmentSize;
  
  Arrow(float originX, float originY, int nSegments, float size) {
    this.origin = new PVector(originX, originY);
    
    this.nSegments = nSegments;
    this.segmentSize = size / nSegments;
    
    this.seed = int(random(10000));
  }
  
  float getAngleAtPoint(float ratio, float offset) {
    return ((ratio - 0.5) * 2) * noise(ratio * 5 + this.seed + offset) * HALF_PI;
  }
  
  void display(float offset) {
    float currentY = this.origin.y;
    
    noFill();
    
    for (int i = 0; i < this.nSegments; i++) {
      float yRatio = map(i, 0, this.nSegments, 0, 1);
      float yRatioNext = map(i + 1, 0, this.nSegments, 0, 1);
      
      float nextY = currentY + this.segmentSize * yRatio * ((sin(offset + this.seed) + 3.5) / 2);
      
      float angleOffset = ((noise(this.seed + offset / 5) - 0.5) * 2) * PI;
      float angle = this.getAngleAtPoint(yRatio, offset) + angleOffset;
      float angleNext = this.getAngleAtPoint(yRatioNext, offset) + angleOffset;
      
      float length = 10 + (yRatio + 0.2) * 200 * noise(yRatio * 10 + this.seed + offset / 2);
      float handleLength = length * yRatio;
      float handleLengthNext = length * yRatioNext;
      
      float ctrlX1 = this.origin.x + cos(angle) * handleLength;
      float ctrlY1 = currentY + sin(angle) * handleLength;
      
      float ctrlX2 = this.origin.x + cos(PI + angleNext) * handleLengthNext;
      float ctrlY2 = nextY + sin(PI + angleNext) * handleLengthNext;
      
      stroke(255);
      strokeWeight(1);
      bezier(this.origin.x, currentY, ctrlX1, ctrlY1, ctrlX2, ctrlY2, this.origin.x, nextY);
      
      // Display the arrow
      if (i == this.nSegments - 1) {
        stroke(#ff9900);
        strokeWeight(3);
        
        float arrowSize = noise(this.seed) * 30;
        
        line(this.origin.x, nextY, this.origin.x + cos(PI + QUARTER_PI + angleNext) * arrowSize, nextY + sin(PI + QUARTER_PI + angleNext) * arrowSize);
        line(this.origin.x, nextY, this.origin.x + cos(PI - QUARTER_PI + angleNext) * arrowSize, nextY + sin(PI - QUARTER_PI + angleNext) * arrowSize);
      }
      
      currentY = nextY;
    }
  }
}

int nArrows = 15;
int gap = 20;
ArrayList<Arrow> arrows = new ArrayList<Arrow>();
float offset = 0;

void setup() {
  size(500, 500);
  
  float startX = (width - gap * nArrows) / 2;
  for (int i = 0; i < nArrows; i++) {
    arrows.add(new Arrow(startX + i * gap, 50, 10, random(250, 400)));
  }
}

void draw() {
  background(#003344);
  
  for (Arrow arrow : arrows) {
    arrow.display(offset);
  }
  
  offset += 0.05;
  
  //noLoop();
}
