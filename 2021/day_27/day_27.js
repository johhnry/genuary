// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * From: https://easings.net/#easeInExpo
 */
function easeOutBounce(x) {
  const n1 = 7.5625;
  const d1 = 2.75;

  if (x < 1 / d1) {
    return n1 * x * x;
  } else if (x < 2 / d1) {
    return n1 * (x -= 1.5 / d1) * x + 0.75;
  } else if (x < 2.5 / d1) {
    return n1 * (x -= 2.25 / d1) * x + 0.9375;
  } else {
    return n1 * (x -= 2.625 / d1) * x + 0.984375;
  }
}

/**
 * From: https://p5js.org/reference/#/p5/pixels
 */
function setPixel(x, y, r, g, b) {
  const d = pixelDensity();

  for (let i = 0; i < d; i++) {
    for (let j = 0; j < d; j++) {
      const index = 4 * ((y * d + j) * width * d + (x * d + i));
      pixels[index] = r;
      pixels[index + 1] = g;
      pixels[index + 2] = b;
      pixels[index + 3] = 255;
    }
  }
}

function putPixels(x, y, offset) {
  loadPixels();
  for (let i = 0; i < 100; i++) {
    const rx = int(x + Math.cos(easeOutBounce(random(1)) + offset) * random(200));
    const ry = int(y - Math.sin(easeOutBounce(random(1)) + offset) * random(200));

    const p = easeOutBounce(map(rx + ry, 0, width + height, 1, 0));

    const r = 255 - random(p) * 100;
    const g = 153 - random(p) * 153;
    const b = 0;

    setPixel(rx, ry, r, g, b);
  }
  updatePixels();
}

let offset = 0;

function setup() {
  createCanvas(500, 500);

  background("#003344");
}

function draw() {
  putPixels(width / 2, height / 2, offset);
  
  if (frameCount % 100 == 0) offset += QUARTER_PI;
}
