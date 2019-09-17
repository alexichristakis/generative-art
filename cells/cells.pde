ArrayList<Cell> cells = new ArrayList<Cell>();
int STARTING_CELLS = 3;

float MAX_VELOCITY_1 = 0.5;
float MAX_VELOCITY_2 = 0.2;

float SPRING = 0.01;
float FRICTION = 0.999;
float BOUNCE_FRICTION = -0.5;
float GROWTH_CHANCE = 0.2;
float SICKNESS_CHANCE = 0.0005;
float DIVIDE_CHANCE = 0.005;
float DEATH_CHANCE = 0.001;
float GROWTH_STEP = 0.5;
float MAX_SIZE = 100;

int FAST_ZONE;

void setup() {
  // size(1000, 1000);
	fullScreen();
  colorMode(HSB, 360);

  FAST_ZONE = width - 660;

  for (int i = 0; i < STARTING_CELLS; i++) {
    Cell cell = new Cell(random(width), random(height), random(60, 100), random(360));
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