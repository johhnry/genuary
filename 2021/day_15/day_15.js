// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Draw a layer with a hole and stroke
 */
function layer(x, y, z, size, rotationY, rotationZ, fillColor) {
  // Transform
  push();
  translate(x, y, z);
  rotateZ(QUARTER_PI + rotationY);
  rotateY(rotationZ);

  // Base
  rectMode(CENTER);
  fill(fillColor);
  stroke("#003344");
  strokeWeight(20);
  plane(size, size);

  // Hole
  fill("#003344");
  noStroke();
  plane(size * 0.7, size * 0.7);

  pop();
}

/**
 * Easing functions
 * From : https://easings.net/
 */
function easeInSine(x) {
  return 1 - cos((x * PI) / 2);
}

function easeInOutCubic(x) {
  return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
}

let offset = 0;

let fromYellow, toYellow;
let fromBlue, toBlue;

function setup() {
  createCanvas(500, 500, WEBGL);

  // WEBGL attributes
  setAttributes('antialias', true);
  setAttributes('depth', false);

  // Define colors
  fromYellow = color("#ff7300");
  toYellow = color("#ff9900");

  fromBlue = color("#84d0ef");
  toBlue = color("#2790cf");
}

function draw() {
  background("#003344");

  const nLayers = 8;
  const gap = easeInSine(cos(offset)) * 20 + 20;
  const rotationY = easeInSine(sin(offset)) * PI;
  const startX = -(gap * (nLayers - 1)) / 2;

  for (let i = 0; i < nLayers; i++) {
    const x = startX + (gap * i);
    const rotationZ = cos(offset) * PI + i * (sin(offset) * cos(offset) * 0.5);

    const lerp = easeInOutCubic(abs(sin(offset)));
    const from = lerpColor(fromBlue, fromYellow, lerp);
    const to = lerpColor(toBlue, toYellow, lerp);
    const fillColor = lerpColor(from, to, i / nLayers);

    const size = map(i, 0, nLayers, 150, 20);

    layer(0, -x - 40, 0, size, rotationY, rotationZ, fillColor);
  }

  offset += 0.01;
}
