// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

const margin = 70;

/**
 * Here a particle is a sound particle
 * it has a direction, a speed and a source point
 */
class Particle {
  constructor(x, y, direction, speed) {
    this.location = createVector(x, y);
    this.direction = direction;
    this.speed = speed;
  }
  
  /**
   * Move the particle and handle wall collisions
   */
  update() {
    this.location.add(p5.Vector.mult(this.direction, this.speed));
    
    const limit = width / 2 - margin;
    
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
  display() {
    stroke(255, 80);
    strokeWeight(5);
    point(this.location.x, this.location.y);
  }
}

/**
 * A sound wave is composed of multiple sound particles
 */
class Wave {
  constructor(x, y, nParticles, speed) {
    this.x = x;
    this.y = y;
    this.particles = [];
    
    // Create the particles from the center of the wave
    for (let i = 0; i < nParticles; i++) {
      const angle = i * (TWO_PI / nParticles);
      const direction = p5.Vector.fromAngle(angle);
      
      this.particles.push(new Particle(this.x, this.y, direction, speed));
    }
  }
  
  /**
   * Update all the particles
   */
  update() {
    for (const particle of this.particles) {
      particle.update();
    }
  }
  
  /**
   * Display the wave as the line between all the particles
   */
  display() {
    beginShape();
    
    for (const particle of this.particles) {
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
  constructor(w, h, rate) {
    this.w = w;
    this.h = h;
    this.rate = rate;
    this.time = millis();
    
    this.waves = [];
    
    this.emitWaves();
  }
  
  /**
   * Emit one wave on each of the speakers
   */
  emitWaves() {
    const nParticles = 200;
    const speed = random(0.5, 2);
    
    this.waves.push(new Wave(0, this.h / 5, nParticles, speed));
    
    this.waves.push(new Wave(0, -this.h / 5, nParticles / 2, speed / 2));
  }
  
  /**
   * Emit at a constant rate and update waves
   */
  update() {
    // Emit sound wave every rate time
    if (millis() - this.time > this.rate) {
      this.emitWaves();
      this.time = millis();
    }
    
    // Update the waves
    for (const wave of this.waves) {
      wave.update();
    }
  }
  
  /**
   * Display a simplified speaker and the waves
   */
  display() {
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
    
    for (const wave of this.waves) {
      wave.display();
    }
    
    pop();
  }
}

let speaker; 

function setup() {
  createCanvas(500, 500);
  
  speaker = new SoundSpeaker(70, 140, 5000);
}

function draw() {
  background("#003344");
  
  speaker.display();
  speaker.update();
}

