// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

int margin = 50;
int iteration = 0;

/**
 * Fill a cell with diagonal cross hatches
 */
void fillCell(float x, float y, float cellSize, float step) {
  float offset = step;

  while (offset <= cellSize * 2 - step) {
    if (offset < cellSize) {
      line(x + offset, y, x, y + offset);
    } else {
      line(x + cellSize, y + offset - cellSize, x + offset - cellSize, y + cellSize);
    }

    offset += step;
  }
}

/**
 * Modulo with non negative number (for indices)
 * See : https://stackoverflow.com/questions/1082917/mod-of-negative-number-is-melting-my-brain
 */
int mod(int x, int m) {
  return (x % m + m) % m;
}

/**
 * Rule 30
 * See : https://en.wikipedia.org/wiki/Rule_30
 */
boolean rule30(boolean left, boolean center, boolean right) {
  return left ^ (center | right);
}

/**
 * Grid class with cells
 */
class Grid {
  boolean[][] grid;
  int gridSize;
  
  // The row we are currently checking
  int currentRow;
  
  Grid(int gridSize) {
    this.currentRow = 1;

    this.gridSize = gridSize;
    grid = new boolean[gridSize][gridSize];
    
    // The middle top cell is on
    grid[gridSize / 2][0] = true;
  }
  
  /**
   * Apply rule 30 to the current row
   */
  void applyRule30() {
    // Go through every cells in the row
    for (int i = 0; i < this.gridSize; i++) {
      int pRow = mod(this.currentRow - 1, this.gridSize);
      
      // Get left, right and center and loop at the corners
      boolean left = this.grid[mod(i - 1, this.gridSize)][pRow];
      boolean center = this.grid[i][pRow];
      boolean right = this.grid[mod(i + 1, this.gridSize)][pRow];
      
      this.grid[i][currentRow] = rule30(left, center, right);
    }

    this.currentRow++;
    if (currentRow == this.gridSize) {
      iteration++;
      currentRow = 0;
    }
  }

  void display() {
    float cellSize = (width - margin * 2) / this.gridSize;

    for (int i = 0; i < this.gridSize; i++) {
      float x = margin + i * cellSize;

      for (int j = 0; j < this.gridSize; j++) {
        float y = margin + j * cellSize;

        stroke(255);
        noFill();
        square(x, y, cellSize);

        float chSpace = map(j, 0, this.gridSize * 2, 3, 10);
        if (this.grid[i][j]) fillCell(x, y, cellSize, chSpace);
      }
    }
  }
  
  void update() {
    this.display();
    this.applyRule30();
  }
}

Grid grid;

void setup() {
  size(500, 500);
  
  grid = new Grid(30);
}

void draw() {
  background(#003344);
  grid.update();
}

