// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

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

float easeInOutBack(float x) {
  float c1 = 1.70158;
  float c2 = c1 * 1.525;

  return x < 0.5
    ? (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
    : (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;
}

interface SDF {
  float compute(int x, int y);
}

class ConstantSDF implements SDF {
  float value;

  ConstantSDF(float value) { 
    this.value = value;
  }

  float compute(int x, int y) {
    return value;
  }
}

class CircleSDF implements SDF {
  float cx, cy, diam;

  CircleSDF(float cx, float cy, float diam) {
    this.cx = cx;
    this.cy = cy;
    this.diam = diam;
  }

  float compute(int x, int y) {
    return dist(x, y, cx, cy) - diam / 2;
  }
}

class SDFSubtract implements SDF {
  SDF sdf1, sdf2;

  SDFSubtract(SDF sdf1, SDF sdf2) {
    this.sdf1 = sdf1;
    this.sdf2 = sdf2;
  }

  float compute(int x, int y) {
    return max(sdf1.compute(x, y), -sdf2.compute(x, y));
  }
}

class SDFAdd implements SDF {
  SDF sdf1, sdf2;

  SDFAdd(SDF sdf1, SDF sdf2) {
    this.sdf1 = sdf1;
    this.sdf2 = sdf2;
  }

  float compute(int x, int y) {
    return min(sdf1.compute(x, y), sdf2.compute(x, y));
  }
}

void displaySDF(SDF sdf, float threshold) {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float val = easeOutBounce(constrain(sdf.compute(x, y), -threshold, threshold) / threshold);
      pixels[x + y * width] = lerpColor(#f69333, #774e7e, val);
    }
  }
  updatePixels();
}

float animValue = 0;

float animOffset(float offset) {
  return cos(animValue + offset);
}

void setup() {
  size(400, 400);
  frameRate(30);
}

void draw() {
  background(255);
  
  float aCos = easeInOutBack((cos(animValue) + 1) / 2);
  float mAcos = 1 - aCos;

  SDF sdf = new SDFAdd(
    new SDFSubtract(
      new CircleSDF(width / 2, height / 2, 200), 
      new CircleSDF(width / 2, height / 2, 200)
    ), 
    new SDFSubtract(
      new SDFAdd(
        new CircleSDF(width / 2 + mAcos * width / 4, height / 2 + 50, 100), 
        new CircleSDF(width / 2 - mAcos * width / 4, height / 2 - 50, 100)
      ), 
      new CircleSDF(width / 2, height / 2, 100 * aCos)
    )
  );

  displaySDF(sdf, 10 + aCos * 80);

  animValue += 0.05;
}
