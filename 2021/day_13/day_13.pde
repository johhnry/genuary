// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Helper function to get a random point inside a circle
 */
PVector pickRandomPointInCircle(float x, float y, float diameter) {
  float randomAngle = random(TWO_PI);
  float randomRadius = random(0, diameter / 2);
  return new PVector(cos(randomAngle) * randomRadius, sin(randomAngle) * randomRadius);
}

/**
 * Recursive function that draws nested circles
 * no repetitions here since the function draws itself
 */
void recursiveCircles(float x, float y, float diameter, int depth) {
  // End condition
  if (depth == 0) return;
  
  stroke(255, 80);
  noFill();
  strokeWeight(2);
  circle(x, y, diameter);
  
  // Pick depth random points
  for (int i = 0; i < depth; i++) {
    PVector nextPoint = pickRandomPointInCircle(x, y, diameter);
    
    stroke(255, 153, 0, 200);
    strokeWeight(5);
    point(nextPoint.x, nextPoint.y);
    strokeWeight(1);
    line(x, y, nextPoint.x, nextPoint.y);
    
    // Compute next diameter in order to stay inside the previous circle
    float distanceFromCenter = dist(x, y, nextPoint.x, nextPoint.y);
    float nextDiameter = diameter - (2 * distanceFromCenter);
    
    // Recursive call
    recursiveCircles(nextPoint.x, nextPoint.y, nextDiameter, depth - 1);
  }
}

final int timeChange = 500;
int time = 0;

/**
 * Reset background and draw a new configuration
 */
void updateView() {
  background(#003344);
    
  translate(width / 2, height / 2);
  recursiveCircles(0, 0, 350, 3);
}

void setup() {
  size(500, 500);
  
  updateView();
}

void draw() {
  // Change the view when it's time
  if (millis() - time > timeChange) {
    updateView();
    // Reset time
    time = millis();
  }
}

