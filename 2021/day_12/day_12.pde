// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

JSONObject activity;

void getNewActivity() {
  String requestURL = "https://www.boredapi.com/api/activity/";
  activity = loadJSONObject(requestURL);
}

void vThickLine(float x, float y, float d1, float d2, float length, float rotation) {
  push();
  translate(x, y);
  rotate(rotation);

  beginShape();
  float r2 = d2 / 2;
  for (float angle = PI; angle < TWO_PI; angle += 0.1) {
    vertex(cos(angle) * r2, sin(angle) * r2 - length);
  }

  float r1 = d1 / 2;
  for (float angle = 0; angle < PI; angle += 0.1) {
    vertex(cos(angle) * r1, sin(angle) * r1);
  }
  endShape(CLOSE);

  pop();
}

void bored(float x, float y, float vSize, float factor) {
  push();
  translate(x, y);
  
  noStroke();
  fill(255, 200);

  float headWidth = 60;
  float headHeight = 80;
  
  float headY = headHeight / 2 + (vSize - headHeight / 2) * factor;

  float armLength = vSize - headHeight / 2;
  float lowerDiameter = 30;
  float upperDiameter = 10;
  float handDiameter = upperDiameter / 2;
  
  float handX = (headWidth + upperDiameter) / 2;
  
  float armY = headY - headHeight / 2;
  float armOffset = sqrt(pow(armLength, 2) - pow(armY, 2));
  float armRotation = acos(armOffset / armLength) - HALF_PI;
  float armX = handX + armOffset;
  
  float shoulderDiameter = lowerDiameter * 1.2;
  vThickLine(-headWidth / 2, -(headY - headHeight / 2), shoulderDiameter, lowerDiameter, armLength, -armRotation + PI);
  vThickLine(headWidth / 2, -(headY - headHeight / 2), shoulderDiameter, lowerDiameter, armLength, armRotation + PI);
  
  // Arms
  vThickLine(-armX, 0, lowerDiameter, upperDiameter, armLength, -armRotation);
  vThickLine(armX, 0, lowerDiameter, upperDiameter, armLength, armRotation);
  
  // Hands
  vThickLine(-handX, -armY, upperDiameter, handDiameter, headHeight / 1.5, 0);
  vThickLine(handX, -armY, upperDiameter, handDiameter, headHeight / 1.5, 0);

  ellipse(0, -headY, headWidth, headHeight);
  
  stroke(#ff9900);
  strokeWeight(10);
  point(-headWidth / 4, -headY);
  point(headWidth / 4, -headY);
  
  strokeWeight(2);
  noFill();
  arc(0, -headY + headHeight / 5, 20, factor * 20, 0, PI);
  
  stroke(0);
  strokeWeight(5);
  point(-headWidth / 4 + cos(armRotation * 4) * 2.5, -headY);
  point(headWidth / 4 + cos(armRotation * 4) * 2.5, -headY);

  pop();
}

float offset = 0;
float time = 0;
float incr = 0.05;

void setup() {
  size(500, 500);
  
  getNewActivity();
}

void draw() {
  background(#003344);

  translate(width / 2, height / 2 + 50);

  bored(0, 0, 150, (sin(offset) + 1) / 2);
  
  textSize(8);
  stroke(#ff9900);
  strokeWeight(50);
  line(-200, 105, 200, 105);
  
  textAlign(CENTER, CENTER);
  fill(255);
  noStroke();
  
  textSize(15);
  text("You're bored? Just : ", 0, -220);
  
  fill(255);
  text(activity.getString("activity"), 0, 100);
  
  textSize(8);
  text("type : " + activity.getString("type"), 0, 120);
  
  if (offset - time > TWO_PI) {
    getNewActivity();
    time = offset;
    n++;
  }
  
  offset += incr;
}
