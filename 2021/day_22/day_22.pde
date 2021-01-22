// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Custom class to wrap data like on the fly objects with js
 */
class CustomPos {
  float x, y;
  float normFromCenter;
  
  CustomPos(float x, float y, float normFromCenter) {
    this.x = x;
    this.y = y;
    this.normFromCenter = normFromCenter;
  }
}

/**
 * Draw quads with diferent thickness and sizes to display lines
 */
void pseudoLine(int divisions, float thickness, float margin, float offset) {
  CustomPos[] points = new CustomPos[divisions + 1];
  
  float newWidth = width - 2 * margin;
  float newHeight = height - 2 * margin;
  
  // Compute the middle points of the quads for faster lookup
  for (int i = 0; i <= divisions; i++) {
    float n = map(i, 0, divisions, 0, 1);
    
    float nFromCenter = abs(0.5 - n) * 2;
    
    //const offsetX = sin(n * TWO_PI * 2 + offset) * 100;
    float offsetX = n * newWidth;
    float offsetY = sin(n * TWO_PI + offset) * 40 * (1 - nFromCenter);
    
    float offRad = (1 - nFromCenter) * 50;
    
    points[i] = new CustomPos(
      offsetX + cos(n * TWO_PI + offset) * offRad,
      margin + i * (newHeight / divisions) + offsetY + sin(n * TWO_PI * 10 + offset) * offRad,
      nFromCenter
    );
  }
  
  for (int i = 0; i < divisions; i++) {
    CustomPos current = points[i];
    CustomPos next = points[i + 1];
    
    fill(255, 153, 0);

    // Stroke same color as background to "erase" stuff
    stroke(#003344);
    
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

float  offset = 0;
final int margin = 80;

void setup() {
  size(500, 500);
}

void draw() {
  background(#003344);
  
  pseudoLine(20, 10, margin, offset);
  
  offset += 0.02;
}
