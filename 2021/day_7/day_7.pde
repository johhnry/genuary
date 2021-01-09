// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

final float margin = 100;

/**
 * Draw a pen from the tip with rotation
 */
void pen(float x, float y, float width , float height, float rotation) {
  // The ratio of the different parts compared to the total height
  float ratios[] = {0.12, 0.28, 0.5, 0.1};
  
  push();
  translate(x, y);
  rotate(rotation);
  
  strokeJoin(ROUND);
  fill(#003344);
  stroke(#ff9900);
  strokeWeight(4);
  
  // Tip
  float h = width / 2;
  float spikeHeight = ratios[0] * height;
  triangle(0, 0, -h, -spikeHeight, h, -spikeHeight);
  
  // Body
  float bodyHeight = (ratios[1] + ratios[2]) * height;
  float lineHeight = spikeHeight + ratios[1] * height;
  line(-h, -lineHeight, h, -lineHeight);
  rect(-h, -(spikeHeight + bodyHeight), width, bodyHeight);
  
  // Eraser
  arc(0, -((1 - ratios[3]) * height), width, width, PI, TWO_PI);
  
  pop();
}

/**
 * Display the pen and the stroke
 */
void penOnPaper(float offset) {
  float off = 0.1;
  
  noFill();
  stroke(255);
  strokeWeight(3);
  
  float w = (width - 2 * margin) / 2;
  float lastX = 0;
  
  beginShape();
  for (float y = margin; y < height - margin; y += off) {
    float t = map(y, margin, height - margin, 0, 1);
    float angle = log(t + 0.05) * 15;
    float x = cos(angle + offset) * w + width / 2;
    
    curveVertex(x, y);
    off += 0.05;
    
    if (y + off * 2 >= height - margin && lastX == 0) lastX = x;
  }
  endShape();
  
  pen(lastX, height - margin, 20, 120, -cos(offset) * QUARTER_PI);
}

float offset = 0;

void setup() {
  size(500, 500);
}

void draw() {
  background(#003344);
  
  penOnPaper(offset);
  
  offset += 0.04;
}

