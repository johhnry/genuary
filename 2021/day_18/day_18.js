// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Grid class holding cells
 */
class Grid {
  constructor(cols, rows, margin) {
    // 2D boolean array
    this.cells = [];
    
    this.cols = cols;
    this.rows = rows;
    
    // Fill the grid
    for (let i = 0; i < cols; i++) {
      this.cells[i] = [];
      for (let j = 0; j < rows; j++) {
        this.cells[i][j] = true;
      }
    }
    
    this.margin = margin;

    // The size of a cell
    this.cellSize = (width - 2 * margin) / cols;
  }
  
  display() {
    noStroke();
    
    // Loop through every cells
    for (let i = 0; i < this.cols; i++) {
      const x = this.margin + i * this.cellSize;
      
      for (let j = 0; j < this.rows; j++) {
        // Test if the cell is activated
        if (this.cells[i][j]) {
          fill(255, 153, 0, 100);
        } else {
          fill(0, 51, 68, 20);
        }
        
        const y = this.margin + j * this.cellSize;
        circle(x, y, this.cellSize * 1.5);
      }
    }
  }
}

/**
 * Basic particle class, location direction and speed
 */
class Particle {
  constructor(x, y, angle, speed) {
    this.location = createVector(x, y);
    this.direction = p5.Vector.fromAngle(angle);
    this.speed = speed;

    // Assign random color (blue)
    this.color = lerpColor(color("#0066ff"), color("#0047b3"), random(1));
    
    // Change the noise seed so that the movement is different each time
    noiseSeed(random(10000));
  }
  
  /**
   * Return the next location of the particle based on the direction and speed
   */
  getNextLocation() {
    return p5.Vector.add(this.location, p5.Vector.mult(this.direction, this.speed));
  }
  
  /**
   * Return the heading angle of the particle
   */
  getHeading() {
    return this.direction.heading();
  }
  
  /**
   * Update the particle's location and direction
   */
  update() {
    this.location = this.getNextLocation();
    
    const angleRange = this.speed / 10;
    this.direction.rotate(map(noise(this.location.x / 100, this.location.y / 100), 0, 1, -angleRange, angleRange));
    
    this.speed -= 0.06;
  }
  
  /**
   * Display the particle as line segments
   */
  display() {
    const nextLocation = this.getNextLocation();
    stroke(this.color);
    strokeWeight(this.speed);
    line(this.location.x, this.location.y, nextLocation.x, nextLocation.y);
  }
}

let particles;
let grid;

/**
 * Initialize a new simulation
 */
function initialize() {
  background("#003344");
  
  particles = [];
  grid = new Grid(50, 50, 50);
  
  // Create new particles
  for (let i = 0; i < int(random(200, 300)); i++) {
    const randomAngle = random(0, TWO_PI);
    const randomSpeed = random(1, 10);
    particles.push(new Particle(width / 2, height / 2, randomAngle, randomSpeed));
  }
}

function setup() {
  createCanvas(500, 500);
  
  initialize();
}

function draw() {
  
  grid.display();
  
  // For every particle (in reverse order to delete it)
  for (let i = particles.length - 1; i >= 0; i--) {
    const particle = particles[i];
    
    particle.display();
    particle.update();
    
    // Compute grid cell index under the particle
    const col = constrain(round((particle.location.x - grid.margin) / grid.cellSize), 0, grid.cols - 1);
    const row = constrain(round((particle.location.y - grid.margin) / grid.cellSize), 0, grid.rows - 1);
    
    // Invert it
    grid.cells[col][row] = !grid.cells[col][row];
    
    // Delete if stopped or if out of bounds
    if (particle.speed <= 0 || particle.location.x < grid.margin || particle.location.x > width - grid.margin || particle.location.y < grid.margin || particle.location.y > height - grid.margin) {
      particles.pop();
    }
  }
  
  // If there's no more particles, start again
  if (particles.length == 0) {
    initialize();
  }
}
