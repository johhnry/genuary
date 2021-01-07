// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Stadium shape
 * See : https://en.wikipedia.org/wiki/Stadium_(geometry)
 */
void stadium(float x, float y, float width, float height, float rotation) {
  float bodyWidth = (width - height);
  float diameter = width - bodyWidth;

  push();
  translate(x, y);
  rotate(rotation);

  line(-bodyWidth / 2, -height / 2, bodyWidth / 2, -height / 2);
  line(-bodyWidth / 2, height / 2, bodyWidth / 2, height / 2);

  arc(-bodyWidth / 2, 0, diameter, diameter, HALF_PI, PI + HALF_PI);
  arc(bodyWidth / 2, 0, diameter, diameter, -HALF_PI, HALF_PI);

  pop();
}

/**
 * Prodecural hand (too much proceduralism... ;)
 */
void hand(float x, float y, float width, float height, float rotation, float fingersRatio[], float thumbRatio, float palmRatio) {
  float totalFingersHeight = height / 2;
  float nFingers = fingersRatio.length;

  float fingersGap = width / 10;
  float fingersWidth = (width - fingersGap * (nFingers - 1)) / nFingers;

  float fingerStartX = -width / 2 + fingersWidth / 2;

  // style
  noFill();
  stroke(#ff9900);
  strokeWeight(2);

  // transform
  push();
  translate(x, y);
  rotate(rotation);

  // fingers
  for (int i = 0; i < fingersRatio.length; i++) {
    float fingerHeight = fingersRatio[i] * totalFingersHeight;
    float yOffset = (fingerHeight - fingersWidth) / 2;
    stadium(fingerStartX + i * (fingersWidth + fingersGap), -yOffset, fingerHeight, fingersWidth, HALF_PI);
  }

  // hand palm
  float palmHeight = height * palmRatio;
  float palmOffsetY = palmHeight / 2 + fingersGap * 2;
  stadium(0, palmOffsetY, palmHeight, width * 0.4, HALF_PI);

  // thumb
  float thumbHeight = thumbRatio * totalFingersHeight;
  float thumbOffset = thumbHeight / (2 * sqrt(2));
  stadium(-width / 2 - thumbOffset, palmOffsetY - width / 2 - thumbOffset, thumbHeight, fingersWidth, QUARTER_PI);

  pop();
}

float margin = 60;
float nHands = 4;
float offset = 0;

float[] defaultFingersRatio = {0.8, 1, 0.9, 0.6};

void setup() {
  size(500, 500);
}

void draw() {
  background(#003344);

  

  float maxHandSize = (width - 2 * margin) / nHands;

  for (int i = 0; i < nHands; i++) {
    float x = margin + maxHandSize / 2 + i * maxHandSize;
    for (int j = 0; j < nHands; j++) {
      float noiseOffset = (i + j) / 2;

      float fingersRatio[] = new float[4];
      for (int index = 0; index < fingersRatio.length; index++) {
        fingersRatio[index] = noise(offset + (i + j + index) * 100) * defaultFingersRatio[index];
      }

      float thumbRatio = noise(offset + noiseOffset);
      float palmRatio = noise(offset - noiseOffset);

      float y = margin + maxHandSize / 2 + j * maxHandSize;
      float rotation = QUARTER_PI * ((noise(offset + noiseOffset * 2) * 2) - 1);

      hand(x, y, maxHandSize * (noise(offset) + 0.1), maxHandSize, rotation, fingersRatio, thumbRatio, palmRatio);
    }
  }

  offset += 0.05;
}

