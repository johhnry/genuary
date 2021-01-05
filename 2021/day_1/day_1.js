// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// The number of circles
const nCircles = 15;

// The radius of the biggest circle
const firstRadius = 150;

let offset = 0;

/**
 * Give the angle on a circle at that index
 */
function angleFromIndex(index, steps) {
  return index * (TWO_PI / steps);
}

/**
 * Translate on a circle at given angle
 */
function translateOnCircle(angle, radius) {
  translate(cos(angle) * radius, sin(angle) * radius);
}


function setup() {
  createCanvas(500, 500);
}

function draw() {
  background(#003344);

  // Go to the center
  translate(width / 2, height / 2);

  // Display first circle
  noFill();
  stroke(255);
  circle(0, 0, firstRadius * 2);

  let angle;

  // First loop
  for (let i = 0; i < nCircles; i++) {
    push();

    // Compute angle and radius
    angle = angleFromIndex(i, nCircles);
    const secondRadius = cos(angle + offset) * firstRadius / 2;

    // Move to the circle
    translateOnCircle(angle, firstRadius);

    // Draw it
    circle(0, 0, secondRadius * 2);

    // Second loop
    for (let j = 0; j < nCircles; j++) {
      push();

      angle = angleFromIndex(j, nCircles);
      const thirdRadius = sin(angle - offset * 2) * secondRadius / 4;

      translateOnCircle(angleFromIndex(j, nCircles), secondRadius);
      circle(0, 0, thirdRadius * 2);

      // Third nested loop!
      for (let k = 0; k < nCircles / 2; k++) {
        push();

        angle = angleFromIndex(k, nCircles);
        const fourthRadius = cos(angle - offset * 4) * thirdRadius / 2;

        translateOnCircle(angleFromIndex(k, nCircles / 2), thirdRadius);
        circle(0, 0, fourthRadius * 2);

        pop();
      }

      pop();
    }

    pop();
  }

  // Increase the offset
  offset += 0.01;
}
