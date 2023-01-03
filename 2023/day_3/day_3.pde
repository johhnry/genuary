// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

float time = 0;

float easeOutQuad(float x) {
  return 1 - (1 - x) * (1 - x);
}

class Section {
  color col;
  PImage section;
  PVector center, dir;
  float dist;

  Section(color col, PImage section, int x, int y) {
    this.col = col;
    this.section = section;
    this.center = new PVector(x, y);
    this.dir = PVector.fromAngle(hue(col));
    this.dist = random(5, 15);
  }

  void display() {
    pushMatrix();
    float offset = random(5);
    float offsetX = offset + easeOutQuad(sin(time)) * 10;
    float offsetY = offset + easeOutQuad(cos(time)) * 5;
    translate(center.x + random(-offset, offsetX), center.y + random(-offset, offsetY));
    image(section, 0, 0);
    popMatrix();
  }
}

void sampleSquares() {
  for (int i = 0; i < 100; i++) {
    int size = int(random(5, 50));
    int x = int(random(width - size));
    int y = int(random(height - size));

    PImage section = get(x, y, size, size);
    new Section(pixels[x + y * width], section, x, y).display();
  }
}

void initialGradient() {
  loadPixels();

  for (int x = 0; x < width; x++) {
    float xnorm = x / (float) width;
    for (int y = 0; y < height; y++) {
      float ynorm = y / (float) height;
      int loc = x + y *  width;

      pixels[loc] = color((1 - xnorm) * 200, ynorm * 255, 255);
    }
  }

  updatePixels();
}

void setup() {
  size(400, 400);
  frameRate(30);
  
  initialGradient();
}

void draw() {
  sampleSquares();
  time += 0.05;
}
