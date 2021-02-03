// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

void band(float x, float y, float w, float h, float gap, int nBands, float offset) {
  push();
  translate(x, y);
  
  fill(#ff9900);
  noStroke();
  
  float size = h - ((nBands - 1) * gap);
  float ratio = 0;
  
  for (int i = 0; i < nBands; i++) {
    float pieceRatio;
    
    if (i == nBands - 1) {
      pieceRatio = 1 - ratio;
    } else {
      pieceRatio = noise(ratio / 5 + offset + i * 0.5) * (1 - ratio) * 0.9;
    }
    
    float yy = ratio * size + i * gap;
    
    rect(0, yy, w, pieceRatio * size);
    
    ratio += pieceRatio;
  }
  
  pop();
}

final float margin = 70;
final int nBands = 5;
final float gap = 10;
float bandSize;
float bandWidth;
float offset = 0;

void setup() {
  size(500, 500);
  
  // The size of the band
  bandSize = width - 2 * margin;
  
  // The thickness of each band, considering the gaps
  bandWidth = (bandSize - ((nBands - 1) * gap)) / nBands;
}

void draw() {
  background(#003344);
  
  // Draw the bands
  for (int i = 0; i < nBands; i++) {
    float x = margin + i * (bandWidth + gap);
    float bandOffset = cos(TWO_PI + offset + i * 5) / 5;
    
    band(x, margin, bandWidth, bandSize, gap, 6, bandOffset);
  }
  
  offset += 0.05;
}

