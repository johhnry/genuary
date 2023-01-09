// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

function lerpMultiple(a, b, c, fac) {
  return lerpColor(lerpColor(a, c, 1 - fac), lerpColor(b, c, 1 - fac), fac);
}

let animValue = 0;

function setup() {
  createCanvas(400, 400);
  noiseSeed(99);
}

function draw() {
  background(220);

  push();
  translate(width / 2, -200);
  rectMode(CENTER);

  const from = color("#326b7e");
  const to = color("#9fc4d4");
  const dark = color("#041a1f");
  const fromShadow = color("#0E373914");
  const toShadow = color("#95C5D133");
  const white = color("#D1ECF105");

  const nTriangles = 20;
  const space = (Math.sqrt(2) * width) / nTriangles;

  for (let i = 0; i < nTriangles; i++) {
    const fac = i / nTriangles;

    const y = (nTriangles - i) * space;

    const offsetX = cos(fac * 7) * 50;
    const w = width;
    const triH = 200;

    noStroke();

    fill(lerpMultiple(from, to, dark, fac));
    triangle(-w, y, offsetX, y + triH, w, y);

    fill(lerpColor(fromShadow, toShadow, fac));
    triangle(-w, y, offsetX, y + triH - 5, w, y);

    stroke(white);
    strokeWeight(random(10, 50));
    line(0, y, random(-w / 2, w / 2), height + triH);
  }
  pop();

  const border = 30;
  const bw = width - 2 * border;
  noFill();
  stroke("#bcdee5");
  strokeWeight(1);
  rectMode(CENTER);
  square(width / 2, height / 2, bw);

  circle(width / 2, height - border * 2, 20);
  circle(width / 2, height - border * 2, 5);

  textAlign(CENTER, CENTER);
  textSize(150);
  noStroke();
  fill("#BCDEE5BF");
  textFont("Verdana");
  text(".¤.", width / 2, height / 2);

  animValue += 0.05;
  noLoop();
}
