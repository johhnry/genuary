// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Recursive function to imitate a for loop
 */
function forLoop(start, condition, update, body) {
  if (!condition(start)) return;
  body(start);
  forLoop(update(start), condition, update, body); 
}

/**
 * From : https://easings.net/#easeInOutQuart
 */
function easeInOutQuart(x) {
  return x < 0.5 ? 8 * x * x * x * x : 1 - pow(-2 * x + 2, 4) / 2;
}

const nCircles = 5;
let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  
  translate(width / 2, height / 2);
  
  noFill();
  stroke(255);
  strokeCap(SQUARE);
  
  forLoop(
    0,
    i => (i <= nCircles),
    i => (i + 1),
    i => {
      const r = i * 60;
      const ccos = (easeInOutQuart((cos(offset + i * 0.1) + 1) / 2) - 0.5) * 2;
      const ssin = (easeInOutQuart((sin(offset + i * 0.05) + 1) / 2) - 0.5) * 2;
      
      const startAngle = ccos * TWO_PI + ssin * HALF_PI;
      const endAngle = ccos * HALF_PI + ssin * HALF_PI;
      
      strokeWeight(i + (cos(offset * 2 + i * 0.5) + 1) * 10);
      
      if (i % 2 == 0) {
        stroke("#ff9900");
      } else {
        stroke(255);
      }
      
      arc(ccos * 80, ssin * 80, r * ccos, r * ccos, min(startAngle, endAngle), max(startAngle, endAngle));
    }
  );
  
  offset += 0.03;
}

