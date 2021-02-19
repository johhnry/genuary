// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.List;

float easeInOutCubic(float x) {
  return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
}

class Permutation {
  int[] indices;
  float duration, maxDuration;
  
  Permutation(int i, int j, float duration) {
    this.indices = new int[2];
    this.indices[0] = i;
    this.indices[1] = j;
    this.maxDuration = duration;
    this.duration = duration;
  }
  
  /**
   * Return the current duration of the permutation since the starting time
   */
  float getCurrentDuration() {
    return this.duration;
  }
  
  /**
   * Return true if the permutation is over
   */
  boolean isOver() {
    return this.duration <= 0;
  }
  
  /**
   * Return a normalized duration value between [0, 1]
   */
  float getNormalizedTime() {
    return this.getCurrentDuration() / (float) this.maxDuration;
  }
  
  /**
   * Return true if i is the first index of the permutation
   */
  boolean isFirst(int i) {
    return i == this.indices[0];
  }
  
  /** 
   * Return the distance between the two indices
   * Can be negative
   */
  int getDistance() {
    return this.indices[1] - this.indices[0];
  }
}


class Set {
  float[] elements;
  List<Permutation> permutations;
  
  Set(int size) {
    this.elements = new float[size];
    
    for (int i = 0; i < size; i++) {
      this.elements[i] = random(1);
    }

    // Store a list of permutations
    this.permutations = new ArrayList<Permutation>();
  }
  
  /**
   * Return the permutation of the corresponding element at index i
   * Return null if not found
   */
  Permutation getPermutation(int i) {
    for (int j = this.permutations.size() - 1; j >= 0; j--) {
      Permutation perm = this.permutations.get(j);
      if (perm.indices[0] == i || perm.indices[1] == i) {
        return perm;
      }
    }
    
    return null;
  }

  /**
   * Permute two elements at location i and j
   * Return true if succeded
   */
  boolean permute(int i, int j, int duration) {
    // Check for collision
    if (this.getPermutation(i) != null || this.getPermutation(j) != null) {
      return false;
    }
    
    // Otherwise add a new permutation
    this.permutations.add(new Permutation(i, j, duration));
    
    return true;
  }
  
  void randomPermute(int duration) {
    int i = int(random(this.elements.length));
    int j = int(random(this.elements.length));
    this.permute(i, j, duration);
  }
  
  void update() {
    for (int i = this.permutations.size() - 1; i >= 0; i--) {
      Permutation perm = this.permutations.get(i);
      
      perm.duration -= 30;
      
      // If the permutation is over, delete it
      if (perm.isOver()) {
        this.permutations.remove(this.permutations.size() - 1);
      }
    }
  }
  
  void display(float centerX, float centerY, float length) {
    float squareSize = length / this.elements.length;
    
    push();
    translate(centerX - length / 2 + squareSize / 2, centerY);
    
    stroke(#003344);
    
    strokeWeight(10);
    
    rectMode(CENTER);
    
    for (int i = 0; i < this.elements.length; i++) {
      float x = i * squareSize;
      Permutation perm = this.getPermutation(i);
      
      fill(lerpColor(color(#ff9900), color(#ff4d00), this.elements[i]));
      
      if (perm != null) {
        float n = easeInOutCubic(perm.getNormalizedTime());
        float distance = perm.getDistance();
        int factor = perm.isFirst(i) ? 1 : -1;
        
        float radius = (distance / 2) * squareSize;
        
        float circleCenterX = x + radius * factor;
        
        float angle = n * PI + (perm.isFirst(i) ? PI : 0);
        float circleX = cos(angle) * abs(radius);
        float circleY = sin(angle) * abs(radius);
        
        push();
        
        translate(circleCenterX + circleX, circleY);
        rotate(n * TWO_PI * factor);
        square(0, 0, squareSize);
        
        pop();
      } else {
        
        square(x, 0, squareSize);
      }
    }
    
    pop();
  }
}

List<Set> sets = new ArrayList<Set>();
int nSets = 10;
int size = 300;

int time = 0;

void setup() {
  size(500, 500);
  
  for (int i = 0; i < nSets; i++) {
    sets.add(new Set(nSets));
  }
  
  for (int i = 0; i < 20; i++) sets.get(int(random(sets.size()))).randomPermute(int(random(2000, 3000)));
}

void draw() {
  background(#003344);
  
  float rowHeight = size / nSets;
  float startY = height / 2 - size / 2 + rowHeight / 2;
  
  for (int i = 0; i < nSets; i++) {
    sets.get(i).display(width / 2, startY + i * rowHeight, 300);
    sets.get(i).update();
  }
  
  // Every 2s, add some random permutations
  if (millis() - time > 2000) {
    for (int i = 0; i < 20; i++) sets.get(int(random(sets.size()))).randomPermute(int(random(2000, 3000)));
    time = millis();
  }
}
