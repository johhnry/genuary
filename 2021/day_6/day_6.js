// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Return a list of points in a triangle centered on (0, 0)
 * with a size defining it's circumcircle diameter
 */
function trianglePoints(size) {
  const r = size / 2;
  const a = r * sin(PI / 3);
  const b = r * cos(PI / 3);

  return [
    createVector(0, -r),
    createVector(a, b),
    createVector(-a, b)
  ]
}

/**
 * Draw a triangle with inside lines
 */
function triangleC(x, y, size, rotation = 0, invert = false) {
  push();
  translate(x, y);
  rotate(rotation);
  
  // Get points
  const pts = trianglePoints(size);

  if (!invert) {
    stroke(255);
    fill(0, 20, 27, 100);
  } else {
    strokeWeight(2);
    stroke("#003344");
    fill(255, 200);
  }
  
  triangle(pts[0].x, pts[0].y, pts[1].x, pts[1].y, pts[2].x, pts[2].y);
  
  // Draw lines inside
  line(0, 0, pts[0].x, pts[0].y);
  line(0, 0, pts[1].x, pts[1].y);
  line(0, 0, pts[2].x, pts[2].y);
  
  pop();
}

/**
 * Recursively draw triangles from previous triangle points
 * with animation
 */
function triForce(x, y, size, depth, offset) {
  if (depth == 0) return;
  
  const triangleSize = size;
  points = trianglePoints(size);
  
  push();
  translate(x, y);
  triForce(0, 0, triangleSize, depth - 1, offset + depth * 0.1);
  triangleC(0, 0, triangleSize, cos(offset) * PI);
  
  for (let i = 0; i < points.length; i++) {
    triangleC(points[i].x, points[i].y, triangleSize, (sin(offset + i * 0.1) - cos(offset)) * PI, depth%2 != 0);
    triForce(points[i].x, points[i].y, triangleSize * 0.5, depth - 1, offset);
  }
  pop();
}

let offset = 0;

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  
  translate(width / 2, height / 2 + 25);
  triForce(0, 0, 200, 3, offset);

  offset += 0.01;
}
