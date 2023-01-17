// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

float tWidth = 10;
float tHeight = tWidth * 3;
float tLength = tHeight;
float tTotalLength = 2 * tWidth + tLength;

float easeInOutQuint(float x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

void tShape(float x, float y, float rotate, float scale) {
  pushMatrix();
  translate(x, y);
  rotate(rotate);
  scale(scale);
  
  noStroke();

  beginShape();
  vertex(0, 0);
  vertex(tWidth, 0);
  vertex(tWidth, tWidth);
  vertex(tWidth + tLength, tWidth);
  vertex(tWidth + tLength, 0);
  vertex(tWidth + tLength + tWidth, 0);
  vertex(tWidth + tLength + tWidth, tHeight);
  vertex(tWidth + tLength, tHeight);
  vertex(tWidth + tLength, tHeight - tWidth);
  vertex(tWidth, tHeight - tWidth);
  vertex(tWidth, tHeight);
  vertex(0, tHeight);
  endShape(CLOSE);

  popMatrix();
}

float normalizeOsc(float v) {
  return easeInOutQuint((v + 1) / 2) * 2 -1;
}

void horizontalGrid(float x, float y, color c, float anim) {
  pushMatrix();
  translate(x, y);

  float ty = 0;

  fill(c);
  while (ty < height) {
    float tx = 0;
    while (tx < width) {
      float txNorm = norm(tx, 0, height);
      tShape(tx, ty, 0, normalizeOsc(sin(txNorm + anim)));
      tx += tTotalLength + tWidth;
    }
    ty += 2 * tHeight;
  }

  popMatrix();
}

void verticalGrid(float x, float y, color c, float anim) {
  pushMatrix();
  translate(x, y);

  float tx = tHeight;

  fill(c);
  while (tx < width) {
    float ty = 0;
    while (ty < height) {
      float tyNorm = norm(ty, 0, height);
      tShape(tx, ty, HALF_PI, normalizeOsc(cos(tyNorm + anim)));
      ty += tTotalLength + tWidth;
    }
    tx += 2 * tHeight;
  }

  popMatrix();
}

float animValue = 0;

void setup() {
  size(400, 400);
}

void draw() {
  background(255);

  horizontalGrid(0, 0, #e92525, animValue + PI);
  horizontalGrid(tLength, tHeight, #ff8ba8, animValue + PI);

  verticalGrid(tWidth, tWidth * 2, #ff5968, animValue - PI);
  verticalGrid(tWidth + tLength, -tWidth, #ffbce3, animValue - PI);

  stroke(255);
  strokeWeight(tWidth * 6);
  noFill();
  rect(0, 0, width, height);

  animValue += 0.05;
}
