// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

let orange, red;

function easeInOutCubic(x) {
  return x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
}

class Permutation {
  constructor(i, j, startTime, duration) {
    this.indices = [i, j];
    this.startTime = startTime;
    this.duration = duration;
  }
  
  /**
   * Return the current duration of the permutation since the starting time
   */
  getCurrentDuration() {
    return window.performance.now() - this.startTime;
  }
  
  /**
   * Return true if the permutation is over
   */
  isOver() {
    return this.getCurrentDuration() >= this.duration;
  }
  
  /**
   * Return a normalized duration value between [0, 1]
   */
  getNormalizedTime() {
    return this.getCurrentDuration() / this.duration;
  }
  
  /**
   * Return true if i is the first index of the permutation
   */
  isFirst(i) {
    return i == this.indices[0];
  }
  
  /** 
   * Return the distance between the two indices
   * Can be negative
   */
  getDistance() {
    return this.indices[1] - this.indices[0];
  }
}


class Set {
  constructor(size) {
    this.elements = new Array(size);
    
    for (let i = 0; i < size; i++) {
      this.elements
    }

    // Store a list of permutations
    this.permutations = [];
  }
  
  /**
   * Return the permutation of the corresponding element at index i
   * Return null if not found
   */
  getPermutation(i) {
    for (let j = this.permutations.length - 1; j >= 0; j--) {
      const perm = this.permutations[j];
      if (perm.indices.includes(i)) {
        return perm;
      }
    }
    
    return null;
  }

  /**
   * Permute two elements at location i and j
   * Return true if succeded
   */
  permute(i, j, duration) {
    // Check for collision
    if (this.getPermutation(i) || this.getPermutation(j)) {
      return false;
    }
    
    // Otherwise add a new permutation
    this.permutations.push(new Permutation(i, j, window.performance.now(), duration));
    
    return true;
  }
  
  randomPermute(duration) {
    const i = int(random(this.elements.length));
    const j = int(random(this.elements.length));
    this.permute(i, j, duration);
  }
  
  update() {
    for (let i = this.permutations.length - 1; i >= 0; i--) {
      const perm = this.permutations[i];
      
      // If the permutation is over, delete it
      if (perm.isOver()) {
        this.permutations.pop();
      }
    }
  }
  
  display(centerX, centerY, length) {
    const squareSize = length / this.elements.length;
    
    push();
    translate(centerX - length / 2 + squareSize / 2, centerY);
    
    fill("#ff9900");
    stroke("#003344");
    
    strokeWeight(10);
    
    rectMode(CENTER);
    
    for (let i = 0; i < this.elements.length; i++) {
      const x = i * squareSize;
      const perm = this.getPermutation(i);
      
      if (perm) {
        const n = easeInOutCubic(perm.getNormalizedTime());
        const distance = perm.getDistance();
        const factor = perm.isFirst(i) ? 1 : -1;
        
        const radius = (distance / 2) * squareSize;
        
        const circleCenterX = x + radius * factor;
        
        const angle = n * PI + (perm.isFirst(i) ? PI : 0);
        const circleX = Math.cos(angle) * Math.abs(radius);
        const circleY = Math.sin(angle) * Math.abs(radius);
        
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

const sets = [];
const nSets = 10;
const size = 300;

let time = 0;

function setup() {
  createCanvas(500, 500);
  
  for (let i = 0; i < nSets; i++) {
    sets.push(new Set(nSets));
  }
}

function draw() {
  background("#003344");
  
  const rowHeight = size / nSets;
  const startY = height / 2 - size / 2 + rowHeight / 2;
  for (let i = 0; i < nSets; i++) {
    sets[i].display(width / 2, startY + i * rowHeight, 300);
    sets[i].update();
  }
  
  // Every 2s, add some random permutations
  if (millis() - time > 2000) {
    for (let i = 0; i < 10; i++) sets[int(random(sets.length))].randomPermute(random(1000, 2000));
    
    time = millis();
  }
}
