// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

color[] colors = {#264653, #2a9d8f, #e9c46a, #f4a261, #e76f51};
float offset = 0;

void shuffleArray(color[] colors) {
  for (int i = colors.length - 1; i >= 1; i--) {
    int j = int(random(i));
    int temp = colors[j];
    colors[j] = colors[i];
    colors[i] = temp;
  }
}

/**
 * Display nCircles circles at location (x, y) with specified
 * max and min diameter. Use the offset to control the animation
 */
void circles(float x, float y, int nCircles, float maxDiam, float minDiam, float offset) {
  push();
  translate(x, y);
  
  for (int i = 0; i < nCircles; i++) {
    float n = map(i, 0, nCircles - 1, 0, 1);
    
    float diameter = map(n, 0, 1, maxDiam, minDiam);
    
    float xx = i * n * cos(offset) * 10;
    float yy = (diameter / 2) * n * sin(offset);
    
    noStroke();
    
    // Shadow
    fill(0, 30);
    circle(xx + 5, yy + 2, diameter);
    
    // Colored circle
    int colorIndex = i % colors.length;
    fill(colors[colorIndex]);
    circle(xx, yy, diameter);
  }
  
  pop();
}

void setup() {
  size(500, 500);
  
  // Shuffle the colors randomly at each run
  // From : https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
  shuffleArray(colors);
}

void draw() {
  background(#003344);
  
  circles(width / 2, height / 2, 10, 300, 50, cos(offset) - sin(offset) * log((cos(offset) + 1) * TWO_PI));
  
  offset += 0.03;
}

