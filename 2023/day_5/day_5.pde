// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

boolean displayStack = false;

void displayStackTrace() {
  fill(0, 255, 0);

  int i = 0;
  for (StackTraceElement ste : Thread.currentThread().getStackTrace()) {
    text(ste.toString(), 10, 20 + i * 15); 
    i++;
  }
  
  displayStack = true;
}

void circleRecursive(float x, float y, float size, int depth, int maxDepth) {
  if (depth >= maxDepth) {
    if (!displayStack) displayStackTrace();
    return;
  }
  
  pushMatrix();
  translate(x, y);

  noFill();
  stroke(255);

  circle(0, 0, size);
  popMatrix();
  
  for (int i = 0; i < 10; i++) {
    float rsize = random(size / 12, size /1.5);
    float angle = random(TWO_PI);
    float radius = random((size - rsize) / 2.0);
    float nextX = cos(angle) * radius;
    float nextY = sin(angle) * radius;
    if (random(1) < 0.5 - depth * 0.05) circleRecursive(x + nextX, y + nextY, rsize, depth + 1, maxDepth);
  }
}

float animValue = 0;

void setup() {
  size(400, 400);
}

void draw() {
  background(0);
  
  float cosValue = (cos(animValue) + 1) / 2.0;
  int depth = floor(cosValue * 10);

  circleRecursive(width / 2, height / 2, 300, 0, depth);

  animValue += 0.1;
  displayStack = false;
}
