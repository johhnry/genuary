// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

function setLineDash(list) {
  drawingContext.setLineDash(list);
}

function easeInOutQuint(x) {
  return x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
}

function easeInOutQuad(x) {
  return x < 0.5 ? 2 * x * x : 1 - Math.pow(-2 * x + 2, 2) / 2;
}

function bezierWithHandles(x1, y1, x2, y2, x3, y3, x4, y4) {
  noFill();
  stroke("#2f4858");
  strokeWeight(2);
  bezier(x1, y1, x2, y2, x3, y3, x4, y4);

  setLineDash([4, 2, 4]);
  strokeWeight(2);
  stroke("#df8b4a");
  line(x1, y1, x2, y2);
  line(x3, y3, x4, y4);
  setLineDash([]);

  strokeWeight(10);
  stroke("#4a5577");
  point(x1, y1);
  point(x4, y4);

  strokeWeight(4);
  stroke("#b15f83");
  fill("#dfe0df");
  circle(x2, y2, 6);
  circle(x3, y3, 6);
}

function infiniteLoop(x, y, radius, space, roundFactor) {
  push();
  translate(x, y);

  const cy = space / 2 + radius;
  const cyDist = cy * 2 * roundFactor;
  const bxOff = 0;

  // Circle dashed contour
  setLineDash([2, 4]);
  stroke("#9eb0a2");
  fill("#92BCD744");
  circle(0, -cy, radius * 2);
  circle(0, cy, radius * 2);
  setLineDash([]);

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

  const loopRadius = radius * roundFactor;

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
  stroke("#4a5577");
  point(0, -cy);
  point(0, cy);

  pop();
}

let timeValue = 0;

function setup() {
  createCanvas(400, 400);
}

function draw() {
  background("#dfe0df");

  translate(width / 2, height / 2);

  const offset = (cos(timeValue * 2) + 1) / 2.0;
  const offsetNext = (cos(timeValue * 2 + QUARTER_PI) + 1) / 2.0;
  const rotateFactor = Math.floor(timeValue) + easeInOutQuint(timeValue % 1);

  scale(1 + offset * 0.2);

  rotate(rotateFactor * QUARTER_PI);

  infiniteLoop(
    0,
    0,
    50 + offsetNext * 10,
    easeInOutQuad(offsetNext) * 80,
    easeInOutQuint(offset)
  );

  rotate(HALF_PI);
  infiniteLoop(
    0,
    0,
    50 + offset * 10,
    easeInOutQuad(offset) * offset * 60,
    easeInOutQuint(offset)
  );

  timeValue += 0.01;
}
