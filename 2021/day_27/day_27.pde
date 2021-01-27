// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * From: https://easings.net/#easeInExpo
 */
float easeOutBounce(float x) {
  float n1 = 7.5625;
  float d1 = 2.75;

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
void setPixel(int x, int y, int r, int g, int b) {
  int loc = x + y * width;
  pixels[loc] = color(r, g, b);
}

void putPixels(float x, float y, float offset) {
  loadPixels();
  for (int i = 0; i < 120; i++) {
    int rx = int(x + cos(easeOutBounce(random(1)) + offset) * random(200));
    int ry = int(y - sin(easeOutBounce(random(1)) + offset) * random(200));

    float p = easeOutBounce(map(rx + ry, 0, width + height, 1, 0));

    float r = 255 - random(p) * 100;
    float g = 153 - random(p) * 153;
    float b = 0;

    setPixel(rx, ry, int(r), int(g), int(b));
  }
  updatePixels();
}

float offset = 0;

void setup() {
  size(500, 500);

  background(#003344);
}

void draw() {
  putPixels(width / 2, height / 2, offset);
  
  if (frameCount % 80 == 0) offset += QUARTER_PI;
}
