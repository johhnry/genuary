// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Generic function interface
 */
interface Function<T, U> {
  /**
   * Generic call method with variable number of arguments and return type
   */
  T call(U... args);
}

/**
 * Function that return if the given integer is <= to some value
 */
class InferiorOrEqualTo implements Function<Boolean, Integer> {
  int max;

  InferiorOrEqualTo(int max) {
    super();
    this.max = max;
  }

  Boolean call(Integer... args) {
    return args[0] <= max;
  }
}

/**
 * Function that return a value incremented by some amount 
 */
class Increment implements Function<Integer, Integer> {
  int incr;

  Increment(int incr) {
    this.incr = incr;
  }

  Integer call(Integer... args) {
    return args[0] + incr;
  }
}

/**
 * Body function that draw the arcs, return nothing
 */
class Body implements Function<Void, Integer> {
  Void call(Integer... args) {
    noFill();
    stroke(255);
    strokeCap(SQUARE);

    int i = args[0];
    float r = i * 60;

    float ccos = (easeInOutQuart((cos(offset + i * 0.1) + 1) / 2.0) - 0.5) * 2;
    float ssin = (easeInOutQuart((sin(offset + i * 0.05) + 1) / 2.0) - 0.5) * 2;

    float startAngle = ccos * TWO_PI + ssin * HALF_PI;
    float endAngle = ccos * HALF_PI + ssin * HALF_PI;

    strokeWeight(i + (cos(offset * 2 + args[0] * 0.5) + 1) * 10);

    if (i % 2 == 0) {
      stroke(#ff9900);
    } else {
      stroke(255);
    }

    arc(ccos * 80, ssin * 80, abs(r * ccos), abs(r * ccos), min(startAngle, endAngle), max(startAngle, endAngle));

    return null;
  }
}

/**
 * Recursive function to imitate a for loop
 */
void forLoop(int start, Function<Boolean, Integer> condition, Function<Integer, Integer> update, Function<Void, Integer> body) {
  if (!condition.call(start)) return;
  body.call(start);
  forLoop(update.call(start), condition, update, body);
}

/**
 * From : https://easings.net/#easeInOutQuart
 */
float easeInOutQuart(float x) {
  return x < 0.5 ? 8 * x * x * x * x : 1 - pow(-2 * x + 2, 4) / 2;
}

final int nCircles = 5;
float offset = 0;

Function condition, increment, body;

void setup() {
  size(500, 500);

  condition = new InferiorOrEqualTo(nCircles);
  increment = new Increment(1);
  body = new Body();
}

void draw() {
  background(#003344);

  translate(width / 2, height / 2);

  forLoop(0, condition, increment, body);

  offset += 0.03;
}

