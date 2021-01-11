// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

let imageCounter = 0;
let img;
let time = 0;
const changeTime = 2000;

let particles = [];

/**
 * Basic particle class
 */
class Particle {
  /**
   * @speed is a vector
   */
  constructor(x, y, color, speed, initialLife) {
    this.location = createVector(x, y);
    this.color = color;
    this.speed = speed;
    this.initialLife = initialLife;
    this.life = this.initialLife;
  }
  
  /**
   * Return normalized age from 1 to 0
   */
  getAge() {
    return this.life / this.initialLife;
  }
  
  /**
   * Add speed to location with extra rotation
   * also decrease life
   */
  update() {
    const rotation = noise(this.location.x * 0.1, this.location.y * 0.1) * PI / 100 * (1 - this.getAge());
    this.location.add(this.speed.rotate(rotation));
    
    this.life -= 0.1;
  }
  
  display() {
    const age = this.getAge();
    stroke(red(this.color), green(this.color), blue(this.color), age * 20);
    strokeWeight(age * 10);
    point(this.location.x, this.location.y);
  }
}

/**
 * Create random particles from the image centered at 0
 */
function createRandomParticlesFromImage(img) {
  img.loadPixels();
  
  for (let i = 0; i < 200; i++) {
    const rx = int(random(img.width));
    const ry = int(random(img.height));
    
    const diffX = rx - img.width / 2;
    const diffY = ry - img.height / 2;
          
    const speed = createVector(diffX, diffY).normalize().mult(random(0.01, 0.5));
    const loc = 4 * (rx + ry * img.width);
    
    const c = color(img.pixels[loc], img.pixels[loc + 1], img.pixels[loc + 2], 50);
    
    particles.push(new Particle(diffX, diffY, c, speed, random(100, 500)));
  }
}

/**
 * Get random image from : https://picsum.photos/
 */
function randomImage(size) {
  // Add random parameter to load a different image each time
  return loadImage("https://picsum.photos/" + size + "?random=" + imageCounter++, (i) => {
    // Callback when loaded, replace the current image
    img = i;
    createRandomParticlesFromImage(img);
  });
}

function preload() {
  randomImage(100);
}

function setup() {
  createCanvas(500, 500);
  
  background("#003344");
}

function draw() {
  translate(width / 2, height / 2);
  
  // Display the particles
  for (let i = particles.length - 1; i >= 0; i--) {  
    const particle = particles[i];
    particle.display();
    particle.update();
    
    const plx = particle.location.x;
    const ply = particle.location.y;
    if (particle.life <= 0 || plx > width / 2 || plx < -width / 2 || ply > height / 2 || ply < -height / 2) {
      particles.pop();
    }
  }
  
  // Display the image
  imageMode(CENTER);
  image(img, 0, 0);
  
  // Change image
  if (millis() - time > changeTime) {
    randomImage(100);
    time = millis();
  }
}
