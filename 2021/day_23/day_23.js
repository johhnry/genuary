// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

let colors;
let offset = 0;

/**
 * Display nCircles circles at location (x, y) with specified
 * max and min diameter. Use the offset to control the animation
 */
function circles(x, y, nCircles, maxDiam, minDiam, offset) {
  push();
  translate(x, y);
  
  for (let i = 0; i < nCircles; i++) {
    const n = map(i, 0, nCircles - 1, 0, 1);
    
    const diameter = map(n, 0, 1, maxDiam, minDiam);
    
    const x = i * n * cos(offset) * 10;
    const y = (diameter / 2) * n * sin(offset);
    
    noStroke();
    
    // Shadow
    fill(0, 30);
    circle(x + 5, y + 2, diameter);
    
    // Colored circle
    const colorIndex = i % colors.length;
    fill(colors[colorIndex]);
    circle(x, y, diameter);
  }
  
  pop();
}

function setup() {
  createCanvas(500, 500);
  
  // Shuffle the colors randomly at each run
  // From : https://flaviocopes.com/how-to-shuffle-array-javascript/
  colors = ["#264653", "#2a9d8f", "#e9c46a", "#f4a261", "#e76f51"].map(c => color(c)).sort(() => Math.random() - 0.5);
}

function draw() {
  background("#003344");
  
  circles(width / 2, height / 2, 10, 300, 50, cos(offset) - sin(offset) * log((cos(offset) + 1) * TWO_PI));
  
  offset += 0.05;
}

