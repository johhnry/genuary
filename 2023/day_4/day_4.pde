// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

float easeOutExpo(float x) {
  return x == 1 ? 1 : 1 - pow(2, -10 * x);
}

float easeInOutQuint(float x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

void lineBorder(float x1, float y1, float x2, float y2, float sw, float sp) {
  strokeCap(SQUARE);
  stroke(255);
  strokeWeight(sp);
  line(x1, y1, x2, y2);
  stroke(0);
  strokeWeight(sw);
  line(x1, y1, x2, y2);
}

void lineBorderFromPointAngle(float x, float y, float angle, float sw, float sp, float size, float anim) {
  pushMatrix();
  translate(x, y);
  rotate(angle);

  lineBorder(-size / 2, 0, -size / 2 + size * anim, 0, sw, sp);

  popMatrix();
}

float movingFactor(float value) {
  return floor(value) + easeInOutQuint(value % 1);
}

float animValue = 0;

void setup() {
  size(400, 400);
}

void draw() {
  background(255);

  float rotateFactor = movingFactor(animValue);

  int nPoints = 15;
  
  for (int i = 0; i < nPoints; i++) {
    float fac = (i / (float) nPoints);
    float x = fac * width;
    lineBorderFromPointAngle(x, x, -QUARTER_PI * rotateFactor, 8, 16, width * 2, 1);
    lineBorderFromPointAngle(width - x, x, QUARTER_PI * rotateFactor, 8, 16, width * 2, 1);
    
    
    lineBorderFromPointAngle(x, height - x, -QUARTER_PI / 2 * rotateFactor, 8, 16, width * 2, 1);
    lineBorderFromPointAngle(width - x, height - x, QUARTER_PI / 2 * rotateFactor, 8, 16, width * 2, 1);
  }
  
  // White border
  noFill();
  strokeWeight(50);
  stroke(255);
  rect(0, 0, width, height);

  animValue += 0.02;
}
