// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Draw a plane
 */
void plane(float size) {
  float h = size / 2;
  beginShape();
  vertex(-h, -h, 0);
  vertex(h, -h, 0);
  vertex(h, h, 0);
  vertex(-h, h);
  endShape(CLOSE);
}

/**
 * Draw a layer with a hole and stroke
 */
void layer(float x, float y, float z, float size, float rotationY, float rotationZ, color fillColor) {
  // Transform
  push();
  translate(x, y, z);
  rotateZ(QUARTER_PI + rotationY);
  rotateY(rotationZ);
  
  // Plane stroke
  noFill();
  stroke(#003344);
  strokeWeight(20);
  plane(size);
  
  // Base
  rectMode(CENTER);
  fill(fillColor);
  noStroke();
  plane(size);
  
  
  
  // Hole
  fill(#003344);
  noStroke();
  plane(size * 0.7);
  
  pop();
}

/**
 * Easing functions
 * From : https://easings.net/
 */
float easeInSine(float x) {
  return 1 - cos((x * PI) / 2.0);
}

float easeInOutCubic(float x) {
  return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
}

float offset = 0;

color fromYellow, toYellow;
color fromBlue, toBlue;

void settings() {
  System.setProperty("jogl.disable.openglcore", "true");
  size(500, 500, P3D);
}

void setup() {
  hint(DISABLE_DEPTH_TEST);
  hint(DISABLE_OPTIMIZED_STROKE);
  
  // Define colors
  fromYellow = color(#ff7300);
  toYellow = color(#ff9900);
  
  fromBlue = color(#84d0ef);
  toBlue = color(#2790cf);
}

void draw() {
  background(#003344);
  
  int nLayers = 8;
  float gap = easeInSine(cos(offset)) * 20 + 20;
  float rotationY = easeInSine(sin(offset)) * PI;
  float startX = -(gap * (nLayers - 1)) / 2;
  
  for (int i = 0; i < nLayers; i++) {
    float x = startX + (gap * i);
    float rotationZ = cos(offset) * PI + i * (sin(offset) * cos(offset) * 0.5);
    
    float lerp = easeInOutCubic(abs(sin(offset)));
    color from = lerpColor(fromBlue, fromYellow, lerp);
    color to = lerpColor(toBlue, toYellow, lerp);
    color fillColor = lerpColor(from, to, i / nLayers);
    
    float size = map(i, 0, nLayers, 150, 20);
    
    layer(width / 2, height / 2 - x - 40, 0, size, rotationY, rotationZ, fillColor);
  }
  
  offset += 0.01;
}

