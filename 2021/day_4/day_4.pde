// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Bubble shape (like conversation icon)
 */
void bubble(float x, float y, float size, float rotation) {
  noFill();
  stroke(255);
  strokeWeight(5);
  
  push();
  translate(x, y);
  rotate(rotation);
  
  arc(0, 0, size, size, HALF_PI, TWO_PI);
  
  float half = size / 2.0;
  
  line(half, 0, half, half);
  line(0, half, half, half);
  
  pop();
}

/**
 * Rotating bubbles with gap
 */
void bubbles(float x, float y, float size, float rotation, float offset) {
  float gap = (cos(offset) + 2) * 20;
  
  int i = 0;
  for (float radius = size; radius > 0; radius -= gap) {
    float rotationOffset = sin(offset * 2 + i * 0.1) * TWO_PI;
    bubble(x, y, radius, rotation + rotationOffset);
    i++;
  }
}

// Size of the bubbles
float size = 150;
float gap = 10;

// Animation offset
float offset = 0;

void setup() {
  size(500, 500);
}

void draw() {
  background(#003344);
  
  translate(width / 2, height / 2);
  
  float bOffset = gap + size / 2;

  // Symmetry is here!
  bubbles(-bOffset, -bOffset, size, 0, offset);
  bubbles(bOffset, -bOffset, size, HALF_PI, offset);
  bubbles(-bOffset, bOffset, size, -HALF_PI, offset);
  bubbles(bOffset, bOffset, size, PI, offset);
  
  offset += 0.01;
}

