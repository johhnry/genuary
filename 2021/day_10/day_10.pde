// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Particle class containing a vector, speed and offset
 */
class Particle {
  PVector location;
  float offset, initialLife, life, speed;
  
  Particle(float x, float y, float offset, float initialLife, float speed) {
    this.location = new PVector(x, y);
    this.offset = offset;
    this.initialLife = initialLife;
    this.life = initialLife;
    this.speed = speed;
  }
  
  /**
   * Returns normalized age from 1 to 0
   */
  float getAge() {
     return constrain(map(this.life, this.initialLife, 0, 0, 1), 0, 1);
  }
  
  /**
   * Return a new particle when branching at the same location
   */
  Particle branch() {
    return new Particle(this.location.x, this.location.y, this.offset * 2, this.life, this.speed);
  }
  
  /**
   * Update the particle, add noise and decrease life
   */
  void update() {
    float n = noise((this.offset + this.location.x) * 0.1, (this.offset + this.location.y) * 0.1);
    
    this.location.add(PVector.fromAngle(((n * 2) - 1) * this.getAge() * TWO_PI + HALF_PI).mult(-this.speed));
    
    this.life -= this.speed;
  }
  
  /**
   * Display transparent white dot
   */
  void display() {
    stroke(255, 50);
    strokeWeight(2);
    point(this.location.x, this.location.y);
  }
}

/**
 * Create random particles at the bottom of the screen
 * the spread controls the size of the trunk
 */
ArrayList<Particle> createRandomParticles(float spread, float margin) {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  for (float x = (width - spread) / 2.0; x < (width + spread) / 2.0; x++) {
    float initialLife = random(100, 500);
    float randomSpeed = random(0.2, 2);
    particles.add(new Particle(x, height - margin, x / 2.0, initialLife, randomSpeed));
  }
  
  return particles;
}

ArrayList<Particle> particles;
float spread = 100;
float margin = 50;

void setup() {
  size(500, 500);
  
  particles = createRandomParticles(spread, margin);
  
  // Only need to draw the background once in setup
  background(#003344);
}

void draw() {
  
  // Loop through particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle particle = particles.get(i);
    
    particle.display();
    particle.update();
    
    float age = particle.getAge();
     
    // Delete if dead
    if (particle.life <= 0) {
      particles.remove(i);
    }
    
    // Branch condition
    if (random(2) < age * 0.02) {
      // Display an orange dot at that point
      stroke(#ff9900);
      strokeWeight(age * 10);
      point(particle.location.x, particle.location.y);
      
      // Add the new particle
      particles.add(particle.branch());
    }
  }
  
  // Stop when there's no more particles
  if (particles.size() == 0) {
    noLoop();
  }
}

