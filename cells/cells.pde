int numStartingCells = 2;
ArrayList<Cell> cells = new ArrayList<Cell>();

void setup() {
  // size(640, 360);
	fullScreen();
  for (int i = 0; i < numStartingCells; i++) {
    Cell cell = new Cell(new Point(random(width), random(height)), random(20, 50), i);
    cells.add(cell);
  }
  noStroke();
  fill(255, 204);
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