// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Stadium shape
 * See : https://en.wikipedia.org/wiki/Stadium_(geometry)
 */
function stadium(x, y, width, height, rotation) {
  const bodyWidth = (width - height);
  const diameter = width - bodyWidth;

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
function hand(x, y, width, height, rotation, fingersRatio, thumbRatio, palmRatio) {
  const totalFingersHeight = height / 2;
  const nFingers = fingersRatio.length;

  const fingersGap = width / 10;
  const fingersWidth = (width - fingersGap * (nFingers - 1)) / nFingers;

  const fingerStartX = -width / 2 + fingersWidth / 2;

  // style
  noFill();
  stroke("#ff9900");
  strokeWeight(2);

  // transform
  push();
  translate(x, y);
  rotate(rotation);

  // fingers
  for (let i = 0; i < fingersRatio.length; i++) {
    const fingerHeight = fingersRatio[i] * totalFingersHeight;
    const yOffset = (fingerHeight - fingersWidth) / 2;
    stadium(fingerStartX + i * (fingersWidth + fingersGap), -yOffset, fingerHeight, fingersWidth, HALF_PI);
  }

  // hand palm
  const palmHeight = height * palmRatio;
  const palmOffsetY = palmHeight / 2 + fingersGap * 2;
  stadium(0, palmOffsetY, palmHeight, width * 0.4, HALF_PI);

  // thumb
  const thumbHeight = thumbRatio * totalFingersHeight;
  const thumbOffset = thumbHeight / (2 * Math.sqrt(2));
  stadium(-width / 2 - thumbOffset, palmOffsetY - width / 2 - thumbOffset, thumbHeight, fingersWidth, QUARTER_PI);

  pop();
}

const margin = 60;
const nHands = 4;
let offset = 0;

const defaultFingersRatio = [0.8, 1, 0.9, 0.6];

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");

  const maxHandSize = (width - 2 * margin) / nHands;

  for (let i = 0; i < nHands; i++) {
    const x = margin + maxHandSize / 2 + i * maxHandSize;
    for (let j = 0; j < nHands; j++) {
      const noiseOffset = (i + j) / 2;

      const fingersRatio = defaultFingersRatio.map((ratio, index) => {
        return noise(offset + (i + j + index) * 100) * ratio;
      });

      const thumbRatio = noise(offset + noiseOffset);
      const palmRatio = noise(offset - noiseOffset);

      const y = margin + maxHandSize / 2 + j * maxHandSize;
      const rotation = QUARTER_PI * ((noise(offset + noiseOffset * 2) * 2) - 1);

      hand(x, y, maxHandSize * (noise(offset) + 0.1), maxHandSize, rotation, fingersRatio, thumbRatio, palmRatio);
    }
  }

  offset += 0.05;
}
