class Cell {
  PVector p, v;
  float d, dna;
	boolean sick = false;
	boolean dividing = false;
 
  Cell(float x, float y, float d, float dna) {
    this.p = new PVector(x, y);
    this.d = d;
		this.dna = dna;
    this.v = new PVector(random(0.01, MAX_VELOCITY_1), random(0.01, MAX_VELOCITY_1));
  }

  Cell(float x, float y, PVector v, float d, float dna) {
    this.p = new PVector(x, y);
    this.d = d;
		this.v = v;
		this.dna = dna;
  }

  void update(ArrayList<Cell> cells) {
		move();
		display();

		if (!sick && random(1) < GROWTH_CHANCE) {
			d += GROWTH_STEP;
		} else if (sick) {
			if (random(0.5) < GROWTH_CHANCE) d -= GROWTH_STEP;
			if (d <= 0) {
				die(cells);
			}
		}
		
		if (random(1) < SICKNESS_CHANCE) {
			sick = true;
		}

		if (random(1) < DIVIDE_CHANCE && d > MAX_SIZE) {
			mitosis(cells);
		}
  }

  void mitosis(ArrayList<Cell> cells) {
		d /= 2;
		p.x -= d;
		p.y -= d;

		Cell newCell = new Cell(p.x + d/2, p.y + d/2, v.copy(), d, mutate());

		cells.add(newCell);
  }

	float mutate() {
		return min(max(0, dna + random(-20, 20)), 360);
	}

	void die(ArrayList<Cell> cells) {
		cells.remove(this);
	}
  
	void collide(Cell cell) {
		float dx = cell.p.x - p.x;
		float dy = cell.p.y - p.y;

		float distance = sqrt(dx*dx + dy*dy);

		float minDist = cell.d / 2 + d / 2;

		if (distance < minDist) { 
			float angle = atan2(dy, dx);
			float targetX = p.x + cos(angle) * minDist;
			float targetY = p.y + sin(angle) * minDist;
			float ax = (targetX - cell.p.x) * SPRING;
			float ay = (targetY - cell.p.y) * SPRING;

			v.x -= ax;
			v.y -= ay;
			cell.v.x += ax;
			cell.v.y += ay;

			if (sick) {
				if (Math.abs(cell.dna - dna) < 30) {
					cell.sick = true;
				}
			}
		}
  }
  
  void move() {
		// if (p.x > FAST_ZONE) {
		// 	p.x += min(max(v.x, -MAX_VELOCITY_1), MAX_VELOCITY_1);
		// 	p.y += min(max(v.y, -MAX_VELOCITY_1), MAX_VELOCITY_1);
		// } else {
		// 	p.x += min(max(v.x, -MAX_VELOCITY_2), MAX_VELOCITY_2);
		// 	p.y += min(max(v.y, -MAX_VELOCITY_2), MAX_VELOCITY_2);
		// }

		p.x += v.x * FRICTION;
		p.y += v.y * FRICTION;

    if (p.x + d/2 > width) {
      p.x = width - d/2;
      v.x *= BOUNCE_FRICTION; 
    } else if (p.x - d/2 < 0) {
      p.x = d/2;
      v.x *= BOUNCE_FRICTION;
    }
    
		if (p.y + d/2 > height) {
      p.y = height - d/2;
      v.y *= BOUNCE_FRICTION; 
    } else if (p.y - d/2 < 0) {
      p.y = d/2;
      v.y *= BOUNCE_FRICTION;
    }
  }
  
  void display() {
		if (sick) {
			fill(dna, 300, 300);
		} else {
			fill(dna, 360, 360);
		}

    ellipse(p.x, p.y, d, d);
  }
}
