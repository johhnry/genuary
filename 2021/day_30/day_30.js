// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Metaball class
 * See : https://en.wikipedia.org/wiki/Metaballs
 */
class MetaBall {
  constructor(x, y, diameter) {
    this.location = createVector(x, y);
    this.diameter = diameter;
  }
  
  /**
   * Inverse square law function to evaluate the metaball
   */
  evaluate(x, y) {
    const distSq = pow(this.location.x - x, 2) + pow(this.location.y - y, 2);
    
    if (distSq == 0) {
      return 0;
    }
    
    if (distSq < pow(this.diameter, 2)) {
      if (1 / distSq == 0) console.log("zero");
      return 1 / distSq;
      
    }
    
    return 0;
  }
}

/**
 * Evaluate the scalar at that pixel considering a list of metaballs
 */
function evaluatePixel(x, y, metaballs) {
  let sum = 0;
  
  for (const metaball of metaballs) {
    sum += metaball.evaluate(x, y);
  }
  
  return sum;
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

const metaballs = [];
const nBalls = 10;

function setup() {
  createCanvas(500, 500);
  
  for (let i = 0; i < nBalls; i++) {
    const diameter = 100;
    const radius = diameter / 2;
    
    const x = int(random(radius, width - radius));
    const y = int(random(radius, height - radius));
    
    metaballs.push(new MetaBall(x, y, diameter));
  }
}

function draw() {
  background("#003344");
  
  loadPixels();
  for (let x = 0; x < width; x++) {
    for (let y = 0; y < height; y++) {
      const value = evaluatePixel(x, y, metaballs);
      
      if (value > 0 && value < 0.01) {
        setPixel(x, y, 255, 153, 0);
      }
    }
  }
  updatePixels();
  
  noLoop();
}


