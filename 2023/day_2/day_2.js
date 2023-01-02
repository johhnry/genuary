// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

class Loupe {
  constructor(x, y, targetX, targetY) {
    this.origin = new p5.Vector(x, y);
    this.target = new p5.Vector(targetX, targetY);
  }

  display() {
    stroke(0);
    strokeWeight(5);
    line(this.origin.x, this.origin.y, this.target.x, this.target.y);

    fill(255);
    stroke(0);
    strokeWeight(10);

    circle(this.target.x, this.target.y, 60);
  }
}

function randomBorderCoordinate() {
  const side = Math.floor(random(4));
  switch (side) {
    case 0:
      return new p5.Vector(random(width), -10);
    case 1:
      return new p5.Vector(width + 10, random(height));
    case 2:
      return new p5.Vector(random(width) + 10, height);
    case 3:
      return new p5.Vector(-10, random(height));
  }
}

const loupes = [];

function setup() {
  createCanvas(400, 400);

  for (let i = 0; i < 10; i++) {
    const borderPoint = randomBorderCoordinate();
    const randomX = random(width);
    const randomY = random(height);

    loupes.push(new Loupe(borderPoint.x, borderPoint.y, randomX, randomY));
  }
}

function draw() {
  background(255);

  for (const loupe of loupes) {
    loupe.display();
  }

  noLoop();
}
