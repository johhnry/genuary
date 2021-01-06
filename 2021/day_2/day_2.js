// (c) 2021 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

/**
 * Fill a cell with diagonal cross hatches
 */
function fillCell(x, y, cellSize, step) {
  let offset = step;

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
function mod(x, m) {
  return (x % m + m) % m;
}

/**
 * Rule 30
 * See : https://en.wikipedia.org/wiki/Rule_30
 */
function rule30(left, center, right) {
  return left ^ (center | right);
}

/**
 * Grid class with cells
 */
class Grid {
  constructor(gridSize) {
    // The row we are currently checking
    this.currentRow = 1;

    this.gridSize = gridSize;

    // 2D array of booleans
    this.grid = [];
    
    for (let i = 0; i < gridSize; i++) {
      this.grid[i] = [];
    }
    
    // The middle top cell is on
    this.grid[gridSize / 2][0] = true;
  }
  
  /**
   * Apply a rule to the current row
   */
  applyRule(rule) {
    // Go through every cells in the row
    for (let i = 0; i < this.gridSize; i++) {
      const pRow = mod(this.currentRow - 1, this.gridSize);
      
      // Get left, right and center and loop at the corners
      const left = this.grid[mod(i - 1, this.gridSize)][pRow];
      const center = this.grid[i][pRow];
      const right = this.grid[mod(i + 1, this.gridSize)][pRow];
      
      this.grid[i][this.currentRow] = rule(left, center, right);
    }

    this.currentRow = (this.currentRow + 1) % this.gridSize;
  }

  display() {
    const cellSize = (width - margin * 2) / this.gridSize;

    for (let i = 0; i < this.gridSize; i++) {
      let x = margin + i * cellSize;

      for (let j = 0; j < this.gridSize; j++) {
        let y = margin + j * cellSize;

        stroke(255);
        noFill();
        square(x, y, cellSize);

        let chSpace = map(j, 0, this.gridSize * 2, 3, 10);
        if (this.grid[i][j]) fillCell(x, y, cellSize, chSpace);
      }
    }
  }
  
  update() {
    this.display();
    this.applyRule(rule30);
  }
}

const margin = 50;
const grid = new Grid(30);

function setup() {
  createCanvas(500, 500);
}

function draw() {
  background("#003344");
  grid.update();
}
