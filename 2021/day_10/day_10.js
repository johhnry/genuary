// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Particle class containing a vector, speed and offset
 */
class Particle {
  constructor(x, y, offset, initialLife, speed) {
    this.location = createVector(x, y);
    this.offset = offset;
    this.initialLife = initialLife;
    this.life = initialLife;
    this.speed = speed;
  }
  
  /**
   * Returns normalized age from 1 to 0
   */
  getAge() {
     return constrain(map(this.life, this.initialLife, 0, 0, 1), 0, 1);
  }
  
  /**
   * Return a new particle when branching at the same location
   */
  branch() {
    return new Particle(this.location.x, this.location.y, this.offset + 5, this.life, this.speed - 0.05);
  }
  
  /**
   * Update the particle, add noise and decrease life
   */
  update() {
    const n = noise((this.offset + this.location.x) * 0.1, (this.offset + this.location.y) * 0.1);
    
    this.location.add(p5.Vector.fromAngle(((n * 2) - 1) * this.getAge() * TWO_PI + HALF_PI).mult(-this.speed));
    
    this.life -= this.speed;
  }
  
  /**
   * Display transparent white dot
   */
  display() {
    stroke(255, 50);
    strokeWeight(2);
    point(this.location.x, this.location.y);
  }
}

/**
 * Create random particles at the bottom of the screen
 * the spread controls the size of the trunk
 */
function createRandomParticles(spread, margin) {
  const particles = [];
  
  for (let x = (width - spread) / 2; x < (width + spread) / 2; x++) {
    const initialLife = random(300, 600);
    const randomSpeed = random(0.2, 2);
    particles.push(new Particle(x, height - margin, x / 2, initialLife, randomSpeed));
  }
  
  return particles;
}

let particles;
const spread = 100;
const margin = 50;

function setup() {
  createCanvas(500, 500);
  
  particles = createRandomParticles(spread, margin);
  
  // Only need to draw the background once in setup
  background("#003344");
}

function draw() {
  
  // Loop through particles
  for (let i = particles.length - 1; i >= 0; i--) {
    const particle = particles[i];
    
    particle.display();
    particle.update();
    
    const age = particle.getAge();
     
    // Delete if dead
    if (particle.life <= 0) {
      particles.pop();
    }
    
    // Branch condition
    if (random(1) < age * 0.05) {
      // Display an orange dot at that point
      stroke("#ff9900");
      strokeWeight(age * 10);
      point(particle.location.x, particle.location.y);
      
      // Add the new particle
      particles.push(particle.branch());
    }
  }
  
  // Stop when there's no more particles
  if (particles.length == 0) {
    noLoop();
  }
}
