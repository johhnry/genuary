// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

color blue; 
color yellow; 

float easeInOutQuint(float x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

float easeOffset(float offset) {
  return easeInOutQuint((cos(offset) + 1) / 2) - easeInOutQuint((sin(offset / 2)));
}

void circlePattern(float x, float y, float size, float offset) {
  push();
  translate(x, y);
  
  float osc = easeOffset(offset);
  float oscHP = easeOffset(offset + HALF_PI);
  float oscP = easeOffset(offset + PI);
  
  rotate(osc * HALF_PI);
  
  float half = size / 2;
  
  strokeWeight(5);
  
  fill(255);
  stroke(yellow);
  circle(0, 0, size);
  
  fill(blue);
  stroke(blue);
  circle(half * osc, 0, size * 0.75);
  circle(-half * osc, 0, size * 0.75);
  
  circle(0, half, half * osc);
  circle(0, -half, half * osc);
  
  strokeWeight(10);
  
  fill(yellow);
  circle(half, 0, half);
  circle(-half, 0, half);
  
  circle(0, 0, half * 0.75 * oscP);
  
  fill(blue);
  stroke(yellow);
  circle(half * oscHP, (half / 2) * oscHP, half / 2);
  circle(-half * oscHP, (-half / 2) * oscHP, half / 2);
  
  circle(half, 0, (half / 4) * oscHP);
  circle(-half, 0, (half / 4) * oscHP);
  pop();
}

float offset = 0;

void setup() {
  size(500, 500);
  
  blue = color(#003344);
  yellow = color(#ff9900);
}

void draw() {
  background(blue);
  
  circlePattern(width / 2, height / 2, 250, offset);
  
  offset += 0.04;
}

