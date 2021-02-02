// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

final float margin = 70;

/**
 * Here a particle is a sound particle
 * it has a direction, a speed and a source point
 */
class Particle {
  PVector location, direction;
  float speed;
  
  Particle(float x, float y, PVector direction, float speed) {
    this.location = new PVector(x, y);
    this.direction = direction;
    this.speed = speed;
  }
  
  /**
   * Move the particle and handle wall collisions
   */
  void update() {
    this.location.add(PVector.mult(this.direction, this.speed));
    
    float limit = width / 2 - margin;
    
    // Touch left or right wall
    if (this.location.x < -limit || this.location.x > limit) {
      this.direction.x *= -1;
    }
    
    // Touch top or bottom wall
    if (this.location.y < -limit || this.location.y > limit) {
      this.direction.y *= -1;
    }
  }
  
  /**
   * Display the particle as a dot
   */
  void display() {
    stroke(255, 80);
    strokeWeight(5);
    point(this.location.x, this.location.y);
  }
}

/**
 * A sound wave is composed of multiple sound particles
 */
class Wave {
  float x, y;
  ArrayList<Particle> particles;
  
  Wave(float x, float y, int nParticles, float speed) {
    this.x = x;
    this.y = y;
    this.particles = new ArrayList<Particle>();
    
    // Create the particles from the center of the wave
    for (int i = 0; i < nParticles; i++) {
      float angle = i * (TWO_PI / nParticles);
      PVector direction = PVector.fromAngle(angle);
      
      this.particles.add(new Particle(this.x, this.y, direction, speed));
    }
  }
  
  /**
   * Update all the particles
   */
  void update() {
    for (Particle particle : this.particles) {
      particle.update();
    }
  }
  
  /**
   * Display the wave as the line between all the particles
   */
  void display() {
    beginShape();
    
    for (Particle particle : this.particles) {
      particle.display();
      vertex(particle.location.x, particle.location.y);
    }
    
    strokeWeight(2);
    stroke(255, 153, 0, 60);
    noFill();
    
    endShape(CLOSE);
  }
}

/**
 * A sound speaker is an object that emit sound waves
 * It has a constant rate
 */
class SoundSpeaker {
  float w, h;
  int rate, time;
  ArrayList<Wave> waves;
  
  SoundSpeaker(float w, float h, int rate) {
    this.w = w;
    this.h = h;
    this.rate = rate;
    this.time = millis();
    
    this.waves = new ArrayList<Wave>();
    
    this.emitWaves();
  }
  
  /**
   * Emit one wave on each of the speakers
   */
  void emitWaves() {
    int nParticles = 200;
    float speed = random(0.5, 2);
    
    this.waves.add(new Wave(0, this.h / 5, nParticles, speed));
    
    this.waves.add(new Wave(0, -this.h / 5, nParticles / 2, speed / 2));
  }
  
  /**
   * Emit at a constant rate and update waves
   */
  void update() {
    // Emit sound wave every rate time
    if (millis() - this.time > this.rate) {
      this.emitWaves();
      this.time = millis();
    }
    
    // Update the waves
    for (Wave wave : this.waves) {
      wave.update();
    }
  }
  
  /**
   * Display a simplified speaker and the waves
   */
  void display() {
    push();
    translate(width / 2, height / 2);
    
    noFill();
    stroke(255, 153, 0);
    strokeWeight(3);
    rectMode(CENTER);
    
    rect(0, 0, this.w, this.h, 5);
    
    strokeWeight(2);
    
    circle(0, this.h / 5, this.w * 0.7);
    circle(0, -this.h / 5, this.w * 0.4);
    
    fill(255, 153, 0);
    circle(0, this.h / 5, this.w * 0.2);
    circle(0, -this.h / 5, this.w * 0.1);
    
    for (Wave wave : this.waves) {
      wave.display();
    }
    
    pop();
  }
}

SoundSpeaker speaker; 

void setup() {
  size(500, 500);
  
  speaker = new SoundSpeaker(70, 140, 1000);
}

void draw() {
  background(#003344);
  
  speaker.display();
  speaker.update();
}

