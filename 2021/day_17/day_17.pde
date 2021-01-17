// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

color yellow, orange, pink;

float offset = 0;

void lines(float x, float y, float size, int nLines, float offset, color fromColor, color toColor) {
  float slice = TWO_PI / (float) nLines;
  float radius = size / 2;
  
  push();
  translate(x, y);
  
  for (int i = 0; i < nLines; i++) {
    randomSeed(i * 1000);
    
    float angle = i * slice;
    float rotMultiplier = sin(angle / 2) + 1;
    float rotation = angle * rotMultiplier + offset;
    color col = lerpColor(fromColor, toColor, random(1));
    
    stroke(col);
    strokeWeight(map(sin(rotation * 2), -1, 1, size / 20, size / 5));
    
    push();
    translate(cos(angle) * radius, sin(angle) * radius);
    rotate(rotation);
    line(0, 0, size / 4, 0);
    pop();
  }
  
  pop();
}

void setup() {
  size(500, 500);
  
  yellow = color(#ff9900);
  orange = color(#ff5500);
  pink = color(#ff7c67);
}

void draw() {
  background(#003344);
  
  translate(width / 2, height / 2);
  
  noStroke();
  fill(pink);
  circle(0, 0, 120 + sin(offset) * 20);
  
  fill(orange);
  circle(0, 0, 100 + sin(offset + QUARTER_PI) * 10);
  
  fill(yellow);
  circle(0, 0, 50 + sin(offset) * 20);
  
  
  lines(0, 0, 250, 50, offset, yellow, orange);
  lines(0, 0, 150, 25, offset, orange, pink);
  
  offset += 0.03;
}

