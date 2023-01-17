// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.List;

float easeOutElastic(float x) {
  float c4 = (2 * PI) / 3;

  return x == 0
    ? 0
    : x == 1
    ? 1
    : pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
}

color lighten(color c, float l) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return color(r * l, g * l, b * l);
}

PImage fillPImage(int w, int h, color from, color to) {
  noiseSeed((long) random(1000));
  noiseDetail(4, 0.2);

  PImage pg = createImage(w, h, RGB);
  pg.loadPixels();
  for (int x = 0; x < pg.width; x++) {
    for (int y = 0; y < pg.height; y++) {
      float n = noise(x / 2, y / 2);
      pg.pixels[x + y * pg.width] = lerpColor(from, to, 1.0 - n);
    }
  }
  pg.updatePixels();
  return pg;
}

class Shape {
  PImage img;
  float x, y, w, h, rotation;
  color from, to;

  Shape(color c) {
    int gap = 50;
    x = random(gap, width - gap);
    y = random(gap, height - gap);
    w = random(100);
    h = random(100);
    rotation = random(TWO_PI);
    from = c;
    to = lighten(c, random(1.1, 1.5));

    img = fillPImage((int)w, (int)h, from, to);
  }

  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    image(img, 0, 0);
    popMatrix();
  }
}

PImage background;
int animTime = 0;
int animDuration = 2000;
List<Shape> fromShapes, toShapes;

final color[] COLORS = {#c29f03, #332836, #a82217, #083277, #196f25};

List<Shape> generateShapes() {
  List<Shape> shapes = new ArrayList<Shape>();

  for (int i = 0; i < 20; i++) {
    color rColor = COLORS[int(random(COLORS.length))];
    shapes.add(new Shape(rColor));
  }

  return shapes;
}

void setup() {
  size(400, 400);

  background = fillPImage(width, height, #f4f3ee, #d6cec9);
  fromShapes = new ArrayList<Shape>();
  toShapes = new ArrayList<Shape>();

  fromShapes = generateShapes();
  toShapes = generateShapes();

  animTime = millis();
}

void draw() {
  imageMode(CORNER);
  image(background, 0, 0);

  int timeDiff = millis() - animTime;

  if (timeDiff >= animDuration) {
    animTime = millis();
    fromShapes = toShapes;
    toShapes = generateShapes();
  }

  float animFac = easeOutElastic  ((float) timeDiff / animDuration);

  for (int i = 0; i < toShapes.size(); i++) {
    Shape s1 = fromShapes.get(i);
    Shape s2 = toShapes.get(i);

    float x = lerp(s1.x, s2.x, animFac);
    float y = lerp(s1.y, s2.y, animFac);
    float rotation = lerp(s1.rotation, s2.rotation, animFac);
    float w = lerp(s1.w, s2.w, animFac);
    float h = lerp(s1.h, s2.h, animFac);

    pushMatrix();
    translate(x, y);
    rotate(rotation);
    imageMode(CENTER);
    image(s1.img, 0, 0, w, h);
    popMatrix();
  }
}
