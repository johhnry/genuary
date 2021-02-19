// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.List;

int imageCounter = 0;
PImage img;
int time = 0;
int changeTime = 1000;

List<Particle> particles;

/**
 * Basic particle class
 */
class Particle {
  PVector location, speed;
  color col;
  float initialLife, life;
  
  /**
   * @speed is a vector
   */
  Particle(float x, float y, color col, PVector speed, float initialLife) {
    this.location = new PVector(x, y);
    this.col = col;
    this.speed = speed;
    this.initialLife = initialLife;
    this.life = this.initialLife;
  }
  
  /**
   * Return normalized age from 1 to 0
   */
  float getAge() {
    return this.life / this.initialLife;
  }
  
  /**
   * Add speed to location with extra rotation
   * also decrease life
   */
  void update() {
    float rotation = noise(this.location.x * 0.1, this.location.y * 0.1) * PI / 100.0 * (1 - this.getAge());
    this.location.add(this.speed.rotate(rotation));
    
    this.life -= 0.1;
  }
  
  void display() {
    float age = this.getAge();
    stroke(this.col, age * 20);
    strokeWeight(age * 10);
    point(this.location.x, this.location.y);
  }
}

/**
 * Create random particles from the image centered at 0
 */
void createRandomParticlesFromImage(PImage img) {
  img.loadPixels();
  
  for (int i = 0; i < 200; i++) {
    int rx = int(random(img.width));
    int ry = int(random(img.height));
    
    float diffX = rx - img.width / 2;
    float diffY = ry - img.height / 2;
          
    PVector speed = new PVector(diffX, diffY).normalize().mult(random(0.01, 0.5));
    int loc = (rx + ry * img.width);
    
    color col = color(img.pixels[loc], 50);
    
    particles.add(new Particle(diffX, diffY, col, speed, random(100, 500)));
  }
}

/**
 * Get random image from : https://picsum.photos/
 */
void randomImage(int size) {
  // Add random parameter to load a different image each time
  img = loadImage("https://picsum.photos/" + size + "?random=" + (imageCounter++) + ".png", "png");
  createRandomParticlesFromImage(img);
}

void setup() {
  size(500, 500);
  
  background(#003344);
  
  particles = new ArrayList<Particle>();
  
  randomImage(100);
}

void draw() {
  translate(width / 2, height / 2);
  
  // Display the particles
  for (int i = particles.size() - 1; i >= 0; i--) {  
    Particle particle = particles.get(i);
    particle.display();
    particle.update();
    
    float plx = particle.location.x;
    float ply = particle.location.y;
    if (particle.life <= 0 || plx > width / 2 || plx < -width / 2 || ply > height / 2 || ply < -height / 2) {
      particles.remove(i);
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
