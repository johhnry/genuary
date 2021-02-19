// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.List;

/**
 * Grid class holding cells
 */
class Grid {
  int cols, rows;
  float margin, cellSize;
  
  boolean[][] cells;
  
  Grid(int cols, int rows, float margin) {
    // 2D boolean array
    this.cells = new boolean[cols][rows];
    
    this.cols = cols;
    this.rows = rows;
    
    // Fill the grid
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        this.cells[i][j] = true;
      }
    }
    
    this.margin = margin;

    // The size of a cell
    this.cellSize = (width - 2 * margin) / (float) cols;
  }
  
  void display() {
    noStroke();
    
    // Loop through every cells
    for (int i = 0; i < this.cols; i++) {
      float x = this.margin + i * this.cellSize;
      
      for (int j = 0; j < this.rows; j++) {
        // Test if the cell is activated
        if (this.cells[i][j]) {
          fill(255, 153, 0, 100);
        } else {
          fill(0, 51, 68, 20);
        }
        
        float y = this.margin + j * this.cellSize;
        circle(x, y, this.cellSize * 1.5);
      }
    }
  }
}

/**
 * Basic particle class, location direction and speed
 */
class Particle {
  PVector location, direction;
  float speed;
  color col;
  
  Particle(float x, float y, float angle, float speed) {
    this.location = new PVector(x, y);
    this.direction = PVector.fromAngle(angle);
    this.speed = speed;

    // Assign random color (blue)
    this.col = lerpColor(color(#0066ff), color(#0047b3), random(1));
    
    // Change the noise seed so that the movement is different each time
    noiseSeed((long)random(10000));
  }
  
  /**
   * Return the next location of the particle based on the direction and speed
   */
  PVector getNextLocation() {
    return PVector.add(this.location, PVector.mult(this.direction, this.speed));
  }
  
  /**
   * Return the heading angle of the particle
   */
  float getHeading() {
    return this.direction.heading();
  }
  
  /**
   * Update the particle's location and direction
   */
  void update() {
    this.location = this.getNextLocation();
    
    float angleRange = this.speed / 10.0;
    this.direction.rotate(map(noise(this.location.x / 100, this.location.y / 100), 0, 1, -angleRange, angleRange));
    
    this.speed -= 0.06;
  }
  
  /**
   * Display the particle as line segments
   */
  void display() {
    PVector nextLocation = this.getNextLocation();
    stroke(this.col);
    strokeWeight(this.speed);
    line(this.location.x, this.location.y, nextLocation.x, nextLocation.y);
  }
}

List<Particle> particles;
Grid grid;

/**
 * Initialize a new simulation
 */
void initialize() {
  background(#003344);
  
  particles = new ArrayList<Particle>();
  grid = new Grid(50, 50, 50);
  
  // Create new particles
  for (int i = 0; i < int(random(200, 300)); i++) {
    float randomAngle = random(0, TWO_PI);
    float randomSpeed = random(1, 10);
    particles.add(new Particle(width / 2, height / 2, randomAngle, randomSpeed));
  }
}

void setup() {
  size(500, 500);
  
  initialize();
}

void draw() {
  
  grid.display();
  
  // For every particle (in reverse order to delete it)
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle particle = particles.get(i);
    
    particle.display();
    particle.update();
    
    // Compute grid cell index under the particle
    int col = constrain(round((particle.location.x - grid.margin) / grid.cellSize), 0, grid.cols - 1);
    int row = constrain(round((particle.location.y - grid.margin) / grid.cellSize), 0, grid.rows - 1);
    
    // Invert it
    grid.cells[col][row] = !grid.cells[col][row];
    
    PVector nextLocation = particle.getNextLocation();
    
    // Delete if stopped or if out of bounds
    if (particle.speed <= 0 || 
        nextLocation.x < grid.margin || 
        nextLocation.x > width - grid.margin || 
        nextLocation.y < grid.margin || 
        nextLocation.y > height - grid.margin) {
      particles.remove(i);
    }
  }
  
  // If there's no more particles, start again
  if (particles.size() == 0) {
    initialize();
  }
}
