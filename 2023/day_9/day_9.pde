// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

import java.util.List;

float easeInQuint(float x) {
  return x * x * x * x * x;
}

class Branch {
  PVector end, direction;
  float speed;
  float branchingFactor;
  float branchingAngle = radians(50);
  float growDirectionRotateStrength = radians(1);
  int maxBranchingDepth = 3;
  int branchingDepth;
  boolean branchSide;
  int maxSize;
  float originalWidth;
  long noiseSeed;
  int noiseOctaves;
  int leaveAnimation = -1;
  float flowerSize;
  color flowerColor;

  List<PVector> points;
  List<Branch> subBranches;

  Branch(float x, float y, float angle) {
    this(new PVector(x, y), PVector.fromAngle(angle), 1.5, 300, 0.08, 0, 1.5);
  }

  Branch(PVector start, PVector direction, float speed, int maxSize, float branchingFactor, int branchingDepth, float originalWidth) {
    this.end = start;
    this.direction = direction;
    this.points = new ArrayList<PVector>();
    this.subBranches = new ArrayList<Branch>();
    this.speed = speed;
    this.branchingFactor = branchingFactor;
    this.branchingDepth = branchingDepth;
    this.branchSide = random(1) < 0.5;
    this.maxSize = maxSize;
    this.noiseSeed = (long) random(10000);
    this.noiseOctaves = branchingDepth;
    this.originalWidth = originalWidth;
    this.flowerSize = random(2, 12);
    this.flowerColor = lerpColor(#b6567a, #f3b5bc, random(1));
  }

  boolean canGrow() {
    return branchingDepth < maxBranchingDepth;
  }

  boolean finished() {
    return points.size() >= maxSize;
  }

  float directionInfluence(PVector pushDirection, float force) {
    float angle = PVector.angleBetween(direction, PVector.sub(pushDirection, end));
    if (angle > PI) angle -= TWO_PI;
    return angle * force;
  }

  void grow() {
    // Grow sub branches
    for (Branch subBranch : subBranches) {
      if (subBranch.canGrow() || !subBranch.finished()) {
        subBranch.grow();
      }
    }

    if (finished()) return;

    // Compute the next branch point
    PVector next = PVector.add(end, PVector.mult(direction, speed));
    points.add(next);

    // Randomly create a new branch
    if (canGrow() && random(1) < branchingFactor) {
      int branchSign = branchSide ? -1 : 1;
      branchSide = !branchSide;
      float branchAngle = branchSign * branchingAngle;
      PVector branchDirection = direction.copy().rotate(branchAngle);
      int branchSize = int((float) maxSize / random(1.5, 8));
      subBranches.add(new Branch(end, branchDirection, speed * random(0.4, 0.7), branchSize, branchingFactor - 0.02, branchingDepth + 1, originalWidth));
    } else {
      // Otherwise change direction smoothly
      noiseSeed(noiseSeed);
      noiseDetail(noiseOctaves * 5, 0.1);

      float angleToLight = directionInfluence(new PVector(width / 2, 50), 0.01);

      // Left
      float force = 50;
      float pushRight = end.x <= force ? 1 - end.x / force : 0;
      float angleLeft = directionInfluence(new PVector(1, 0), pushRight * 0.03);

      // Right
      float pushLeft = end.x >= width - force ? (width - end.x) / force : 0;
      float angleRight = directionInfluence(new PVector(-1, 0), pushLeft * 0.03);

      float rotate = map(noise(animValue), 0, 1, -growDirectionRotateStrength, growDirectionRotateStrength);
      direction.rotate(rotate + angleToLight + angleLeft - angleRight + directionInfluence(new PVector(width / 4, 100), 0.005));
    }

    // Move the end of the branch
    end = next;
  }

  void display() {
    stroke(lerpColor(#00a168, #0064c1, (float) branchingDepth / maxBranchingDepth));
    noFill();

    for (int i = 0; i < points.size() - 1; i++) {
      PVector point = points.get(i);
      PVector to = points.get(i + 1);
      strokeWeight(((maxSize - i) / (float) maxSize) + originalWidth);
      line(point.x, point.y, to.x, to.y);
    }

    if (points.size() > 0 && finished()) {
      if (leaveAnimation < 0) leaveAnimation = millis();

      PVector branchEnd = points.get(points.size() - 1);
      noStroke();
      fill(flowerColor);
      float leafScale = constrain((millis() - leaveAnimation) / 500.0, 0, 1);
      circle(branchEnd.x, branchEnd.y, easeInQuint(leafScale) * flowerSize);
    }

    for (Branch subBranch : subBranches) subBranch.display();
  }

  int countBranches() { 
    int count = 1;
    for (Branch subBranch : subBranches) count += subBranch.countBranches();
    return count;
  }
}

float animValue = 0;
List<Branch> plants = new ArrayList<Branch>();

void initialize() {
  plants.clear();
  
  plants.add(new Branch(120, height * 0.95, -HALF_PI));
  plants.add(new Branch(width - 120, height * 0.95, -HALF_PI));
}

void setup() {
  size(400, 400);

  initialize();
}

void draw() {
  background(#d8e1cf);
  
  for (Branch plant : plants) {
    plant.display();
    for (int i = 0; i < 5; i++) plant.grow();
  }

  animValue += 1;
}

void mousePressed() {
  initialize();
}
