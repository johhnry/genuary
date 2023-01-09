// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

float computeGradient(float fac, float middle, float size) {
  float half = size / 2;
  if (fac <= middle - half) return 0;
  else if (fac >= middle + half) return 1;
  return (fac - (middle - half)) / size;
}

float easeInOutSine(float x) {
  return -(cos(PI * x) - 1) / 2;
}

float easeInOutCirc(float x) {
  return x < 0.5
    ? (1 - sqrt(1 - pow(2 * x, 2))) / 2
    : (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2;
}

PGraphics windowMask(int w, int h) {
  PGraphics mask = createGraphics(width, height);

  mask.beginDraw();
  mask.background(0);
  mask.fill(255);
  mask.stroke(255);
  mask.strokeWeight(10);
  mask.rectMode(CENTER);

  mask.translate(width / 2.0, height / 2.0);

  mask.rect(0, 0, w, h, 40);
  mask.endDraw();

  return mask;
}

void maskWith(PGraphics origin, PGraphics mask, boolean keepMask) {
  origin.loadPixels();
  mask.loadPixels();
  for (int i = 0; i < origin.width * origin.height; i++) {
    if (mask.pixels[i] == color(0)) {
      origin.pixels[i] = color(0, 0);
    } else if (keepMask && alpha(origin.pixels[i]) > 50) {
      origin.pixels[i] = mask.pixels[i];
    }
  }
  origin.updatePixels();
}

color blue = #2e3e8c;
color pink = #fbc9be;
color red = #fd312b;

float rh, rw;
PGraphics rectMask;
PGraphics drawing;
float animValue = 0;

float lerpValue(float offset, float speed, float min, float max) {
  return min + (max - min) * easeInOutSine((cos(animValue * speed + offset) + 1) / 2);
}

void setup() {
  size(400, 400);

  rh = width * 0.8;
  rw = rh / 1.5;
}

void draw() {
  drawing = createGraphics(width, height);
  rectMask = windowMask((int) rw, (int) rh);

  // Lines
  drawing.beginDraw();
  drawing.push();
  drawing.translate((width - rw) / 2, 0);
  float startLineY = (height - rh) / 2;
  float gradientPos = lerpValue(QUARTER_PI, 0.5, 0.2, 0.5);
  float gradientSize = lerpValue(0, 1, 0.15, 0.25);

  for (int i = 0; i <= rh; i++) {
    float y = startLineY + i;
    float gradientFac = computeGradient(i / rh, gradientPos, gradientSize);
    color lineCol = lerpColor(blue, pink, gradientFac);
    drawing.stroke(lineCol);
    drawing.line(0, y, rw, y);
  }
  drawing.pop();

  // Fuji
  float fujiPos = lerpValue(PI, 0.5, 0.7, 0.8);
  float fujiHeightFac = 0.4;
  float fujiTopWidthFac = 0.1;
  float fujiY = height / 2 + (fujiPos - 0.5) * rh;
  float fujiTopWidth = fujiTopWidthFac * rw;
  float fujiHeight = fujiHeightFac * rw;

  PGraphics fuji = createGraphics(width, height);

  float anchorDistance = (width * 1.5) / 2;
  float topDist = fujiTopWidth / 2;
  float topCurvatureDist = 0.2 * fujiHeight;
  float bottomCurvatureDist = 0.5 * rw;

  fuji.beginDraw();
  fuji.fill(blue);
  fuji.noStroke();

  fuji.push();
  fuji.translate(width / 2, fujiY);
  fuji.beginShape();

  fuji.vertex(-anchorDistance, 0);
  fuji.bezierVertex(
    -bottomCurvatureDist, 
    0, 
    -topDist, 
    -fujiHeight + topCurvatureDist, 
    -topDist, 
    -fujiHeight
    );
  fuji.bezierVertex(
    -topDist, 
    -fujiHeight, 
    -topDist, 
    -fujiHeight, 
    topDist, 
    -fujiHeight
    );
  fuji.bezierVertex(
    topDist, 
    -fujiHeight + topCurvatureDist, 
    bottomCurvatureDist, 
    0, 
    anchorDistance, 
    0
    );

  fuji.endShape();
  fuji.pop();

  // Bottom fuji blue
  fuji.rect((width - rw) / 2, fujiY - 10, rw, rh);
  fuji.endDraw();

  // Top snow
  PGraphics fujiSnow = createGraphics(width, height);
  float fujiSnowRatio = lerpValue(PI, 0.5, 0.7, 0.9);

  fujiSnow.beginDraw();
  fujiSnow.background(0);
  fujiSnow.fill(255);
  fujiSnow.noStroke();
  fujiSnow.rectMode(CENTER);
  fujiSnow.rect(width / 2, fujiY - fujiHeight, rw, fujiSnowRatio * fujiHeight);
  // fujiSnow.image(fuji, 0, 0);
  fujiSnow.endDraw();

  drawing.image(fuji, 0, 0);

  // Apply snow
  maskWith(fuji, fujiSnow, true);
  drawing.image(fuji, 0, 0);

  drawing.endDraw();

  // Mask the whole thing
  maskWith(drawing, rectMask, false);

  // Background
  background(red);
  image(drawing, 0, 0);

  // Border
  noFill();
  stroke(255);
  strokeWeight(10);
  rectMode(CENTER);
  rect(width / 2, height / 2, rw, rh, 40);

  // Red circle
  float angle = animValue;
  fill(red);
  noStroke();
  circle(width / 2 + rw / 4 + cos(angle) * 20, height / 2 - rh / 3 + sin(angle * 2) * 20, 15);

  animValue += 0.05;

  if (frameCount % 2 == 0) saveFrame("anim.####.png");
  if (animValue > TWO_PI * 2) noLoop();
}
