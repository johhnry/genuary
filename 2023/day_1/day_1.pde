// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// From https://easings.net/
float easeInOutQuint(float x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

float easeInOutQuad(float x) {
  return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
}

void dashedCircle(float x, float y, float diam, float step, float space) {
  pushMatrix();
  translate(x, y);

  int segments = int((TWO_PI / (step + space)));
  noFill();

  for (int i = 0; i < segments; i++) {
    float angle = i * (step + space);
    arc(0, 0, diam, diam, angle, angle + step);
  }

  pushStyle();
  fill(146, 188, 215, 40);
  noStroke();
  circle(0, 0, diam);
  popStyle();

  popMatrix();
}

void dashedLine(float x1, float y1, float x2, float y2, float step, float space) {
  float dist = dist(x1, y1, x2, y2);
  int segments = int(dist / (step + space));
  float segmentSize = dist / segments;
  PVector origin = new PVector(x1, y1);
  PVector direction = PVector.sub(new PVector(x2, y2), origin).normalize();

  for (int i = 0; i < segments; i++) {
    PVector next = PVector.add(origin, PVector.mult(direction, segmentSize - space));
    line(origin.x, origin.y, next.x, next.y);
    origin = PVector.add(next, PVector.mult(direction, space));
  }
}

void bezierWithHandles(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  noFill();
  stroke(#2f4858);
  strokeWeight(2);
  bezier(x1, y1, x2, y2, x3, y3, x4, y4);

  strokeWeight(2);
  stroke(#df8b4a);
  dashedLine(x1, y1, x2, y2, 8, 4);
  dashedLine(x3, y3, x4, y4, 8, 4);

  strokeWeight(10);
  stroke(#4a5577);
  point(x1, y1);
  point(x4, y4);

  strokeWeight(4);
  stroke(#b15f83);
  fill(#dfe0df);
  circle(x2, y2, 6);
  circle(x3, y3, 6);
}

void infiniteLoop(float x, float y, float radius, float space, float roundFactor) {
  pushMatrix();
  translate(x, y);

  float cy = space / 2 + radius;
  float cyDist = cy * 2 * roundFactor;
  float bxOff = 0;

  // Circle dashed contour
  noFill();
  stroke(#9eb0a2);
  strokeWeight(1);
  dashedCircle(0, -cy, radius * 2, PI / 30, PI / 60);
  dashedCircle(0, cy, radius * 2, PI / 30, PI / 60);

  // Middle
  bezierWithHandles(
    bxOff - radius,
    cy,
    bxOff - radius,
    cy - cyDist,
    radius,
    -cy + cyDist,
    radius,
    -cy
    );

  bezierWithHandles(
    bxOff + radius,
    cy,
    bxOff + radius,
    cy - cyDist,
    -radius,
    -cy + cyDist,
    -radius,
    -cy
    );

  float loopRadius = radius * roundFactor;

  // Bottom loop
  bezierWithHandles(
    bxOff + radius,
    cy,
    bxOff + radius,
    cy + loopRadius,
    bxOff + loopRadius,
    cy + radius,
    bxOff,
    cy + radius
    );

  bezierWithHandles(
    bxOff - radius,
    cy,
    bxOff - radius,
    cy + loopRadius,
    bxOff - loopRadius,
    cy + radius,
    bxOff,
    cy + radius
    );

  // Top loop
  bezierWithHandles(
    radius,
    -cy,
    radius,
    -cy - loopRadius,
    loopRadius,
    -cy - radius,
    0,
    -cy - radius
    );

  bezierWithHandles(
    -radius,
    -cy,
    -radius,
    -cy - loopRadius,
    -loopRadius,
    -cy - radius,
    0,
    -cy - radius
    );

  // Circle center points
  strokeWeight(5);
  stroke(#4a5577);
  point(0, -cy);
  point(0, cy);

  popMatrix();
}

float timeValue = 0;

void setup() {
  size(400, 400);
}

void draw() {
  background(#dfe0df);

  translate(width / 2, height / 2);

  float offset = (cos(timeValue * 2) + 1) / 2.0;
  float offsetNext = (cos(timeValue * 2 + QUARTER_PI) + 1) / 2.0;
  float rotateFactor = floor(timeValue) + easeInOutQuint(timeValue % 1);

  scale(1 + offset * 0.2);
  rotate(rotateFactor * QUARTER_PI);

  infiniteLoop(0, 0, 50 + offsetNext * 10, easeInOutQuad(offsetNext) * 80, easeInOutQuint(offset));

  rotate(HALF_PI);
  infiniteLoop(0, 0, 50 + offset * 10, easeInOutQuad(offset) * offset * 60, easeInOutQuint(offset));

  timeValue += 0.01;
}
