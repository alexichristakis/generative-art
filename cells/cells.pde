int numStartingCells = 3;
ArrayList<Cell> cells = new ArrayList<Cell>();


void setup() {
  // size(1000, 1000);
	fullScreen();
  
  colorMode(HSB, 360);


  for (int i = 0; i < numStartingCells; i++) {
    Cell cell = new Cell(new Point(random(width), random(height)), random(60, 100), random(360), i);
    cells.add(cell);
  }
  noStroke();
  // fill(255, 204);
}

void draw() {
  background(0);
	// println(cells.size());
  for (int i = 0; i < cells.size(); i++) {
    cells.get(i).update(cells);
		for (int j = i + 1; j < cells.size(); j++) {
			cells.get(i).collide(cells.get(j));
		}
  }
}