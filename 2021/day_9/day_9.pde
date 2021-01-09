// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

void circles(float x, float y, float size, int nCircles, float offset) {
  noFill();
  
  stroke(255, 200);
  
  for (int i = 0; i < nCircles; i++) {
    float factor = ((float) i / nCircles);
    float newSize = factor * size;
    
    strokeWeight(abs(cos(factor * 5 + offset)) * 5 + 5);
    circle(x + cos(factor - offset) * size / 8, y, newSize);
  }
}

float offset = 0;
float size = 300;

void setup() {
  size(500, 500);
}

void draw() {
  background(#003344);
  
  translate(width / 2, height / 2);
  
  circles(0, 0, size - cos(offset) * 50, 10, offset);
  circles(0, 0, size + cos(offset) * 50, 10, offset * 2);
  
  offset += 0.02;
}
