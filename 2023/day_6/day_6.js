function computeGradient(fac, middle, size) {
  const half = size / 2;
  if (fac <= middle - half) return 0;
  else if (fac >= middle + half) return 1;
  return (fac - (middle - half)) / size;
}

function easeInOutSine(x) {
  return -(Math.cos(Math.PI * x) - 1) / 2;
}

function windowMask(w, h) {
  const mask = createGraphics(width, height);

  mask.fill(255);
  mask.stroke(255);
  mask.strokeWeight(10);
  mask.rectMode(CENTER);

  mask.rect(width / 2, height / 2, w, h, 40);

  return mask;
}

let blue;
let pink;
let red;

let rh, rw;
let rectMask;
let drawing;
let animValue = 0;

function lerpValue(offset, speed, min, max) {
  return min + (max - min) * easeInOutSine(animValue * speed + offset);
}

function setup() {
  createCanvas(400, 400);

  blue = color("#2e3e8c");
  pink = color("#fbc9be");
  red = color("#fd312b");

  rh = width * 0.8;
  rw = rh / 1.5;
}

function draw() {
  drawing = createGraphics(width, height);
  rectMask = windowMask(rw, rh);

  // Lines
  drawing.push();
  drawing.translate((width - rw) / 2, 0);
  const startLineY = (height - rh) / 2;
  const gradientPos = lerpValue(QUARTER_PI, 0.5, 0.2, 0.5);
  const gradientSize = lerpValue(0, 1, 0.15, 0.25);

  for (let i = 0; i <= rh; i++) {
    const y = startLineY + i;
    const gradientFac = computeGradient(i / rh, gradientPos, gradientSize);
    const lineCol = lerpColor(blue, pink, gradientFac);
    drawing.stroke(lineCol);
    drawing.line(0, y, rw, y);
  }
  drawing.pop();

  // Fuji
  const fujiPos = lerpValue(PI, 0.5, 0.7, 0.8);
  const fujiHeightFac = 0.4;
  const fujiTopWidthFac = 0.1;
  const fujiY = height / 2 + (fujiPos - 0.5) * rh;
  const fujiTopWidth = fujiTopWidthFac * rw;
  const fujiHeight = fujiHeightFac * rw;

  let fuji = createGraphics(width, height);

  const anchorDistance = (width * 1.5) / 2;
  const topDist = fujiTopWidth / 2;
  const topCurvatureDist = 0.2 * fujiHeight;
  const bottomCurvatureDist = 0.5 * rw;

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

  // Top snow
  let fujiSnow = createGraphics(width, height);
  const fujiSnowRatio = lerpValue(PI, 0.5, 0.7, 0.9);
  fujiSnow.fill(255);
  fujiSnow.noStroke();
  fujiSnow.rectMode(CENTER);
  fujiSnow.rect(width / 2, fujiY - fujiHeight, rw, fujiSnowRatio * fujiHeight);
  fujiSnow.drawingContext.globalCompositeOperation = "destination-in";
  fujiSnow.image(fuji, 0, 0);

  // Apply snow
  drawing.image(fuji, 0, 0);
  drawing.image(fujiSnow, 0, 0);

  // Mask
  rectMask.drawingContext.globalCompositeOperation = "source-in";
  rectMask.image(drawing, 0, 0);

  // Background
  background(red);
  image(rectMask, 0, 0);

  // Border
  noFill();
  stroke(255);
  strokeWeight(10);
  rectMode(CENTER);
  rect(width / 2, height / 2, rw, rh, 40);

  // red circle
  const angle = animValue;
  fill(red);
  noStroke();
  circle(
    width / 2 + rw / 4 + cos(angle) * 20,
    height / 2 - rh / 3 + sin(angle) * 20,
    15
  );

  // Clean
  fuji.remove();
  fujiSnow.remove();
  drawing.remove();
  rectMask.remove();
  fuji = null;
  fujiSnow = null;
  drawing = null;
  rectMask = null;

  animValue += 0.05;
}
