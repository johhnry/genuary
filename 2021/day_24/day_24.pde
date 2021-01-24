// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Display a square of n * n lines
 */
void squareOfLines(float x, float y, float n, float size, float offset) {
  push();
  translate(x, y);
  
  float cellSize = size / n;
  
  for (int i = 0; i < n; i++) {
    float xx = i * cellSize;
    for (int j = 0; j < n; j++) {
      float yy = j * cellSize;
      
      float noiseOffset = noise(i + cos(offset) * 5, j + sin(offset) * 5);
      
      stroke(#ff9900);
      strokeWeight(noiseOffset * 4);
      line(xx, yy + cellSize * (1 - noiseOffset), xx + cellSize * noiseOffset * cos(offset + i / 10) * 2, yy );
    }
  }
  
  pop();
}

float offset = 0;

// Margin between the grid and the canvas
float margin = 50;

// Gap between squares of lines
float gap = 5;

// Size of the square of lines
int n = 5;

float totalSize, cellSize, start;


void setup() {
  size(500, 500);
  
  totalSize = (width - 2 * margin);
  cellSize = (totalSize - gap * (n - 1)) / n;
  start = (width - totalSize) / 2;
}

void draw() {
  background(#003344);
  
  for (int i = 0; i < n; i++) {
    float x = start + i * (cellSize + gap);
    for (int j = 0; j < n; j++) {
      float y = start + j * (cellSize + gap);
      
      squareOfLines(x, y, 10, cellSize, offset + i + j);
    }
  }
  
  offset += 0.03;
}
