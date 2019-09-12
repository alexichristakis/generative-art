import java.util.Arrays;

ArrayList<Particle> particles;

void setup() {
  size(1000, 1000); 
  colorMode(HSB, 360);
  background(0);

	particles = new ArrayList<Particle>();
}

void draw() {
	noStroke();
	fill(0, 30);
	rect(0, 0, width, height);

	// println(particles.size());

	// for (int i = particles.size() - 1; i > -1; i--) {
	// 	particles.get(i).move(particles);
		
	// 	if (particles.get(i).vel.mag() < 0.01) {
	// 		particles.remove(i);
	// 	}
	// }

	if (particles.size() >= 3) {

		// ArrayList<float[]> points = new ArrayList<float[2]>();
		// for (Particle particle : particles) {
		// 	points.add({ particle.p.x, particle.p.y });
		// }

		ArrayList<Integer> triangles = triangulate(particles);

		println("triangles: ", triangles.size());

		for (int i = 0; i < triangles.size(); i+=3) {
			Particle p1 = particles.get(triangles.get(i));
			Particle p2 = particles.get(triangles.get(i + 1));
			Particle p3 = particles.get(triangles.get(i + 2));

			

			fill(165+p1.life*1.5, 360, 360);
			triangle(p1.pos.x, p1.pos.y, 
               p2.pos.x, p2.pos.y, 
               p3.pos.x, p3.pos.y);

		}

	}
}

void mouseDragged() {
  particles.add(new Particle(mouseX, mouseY, 5));
}

Circle circumcircle(ArrayList<PVector> vertices, int i, int j, int k) {
	float x1 = vertices.get(i).x;
  float y1 = vertices.get(i).y;
	float x2 = vertices.get(j).x;
	float y2 = vertices.get(j).y;
	float x3 = vertices.get(k).x;
	float y3 = vertices.get(k).y;
  float fabsy1y2 = Math.abs(y1 - y2);
  float fabsy2y3 = Math.abs(y2 - y3);

  float xc, yc, m1, m2, mx1, mx2, my1, my2, dx, dy;

  /* Check for coincident points */
  if (fabsy1y2 < EPSILON && fabsy2y3 < EPSILON) return null;

	if(fabsy1y2 < EPSILON) {
		m2  = -((x3 - x2) / (y3 - y2));
		mx2 = (x2 + x3) / 2.0;
		my2 = (y2 + y3) / 2.0;
		xc  = (x2 + x1) / 2.0;
		yc  = m2 * (xc - mx2) + my2;
  } else if (fabsy2y3 < EPSILON) {
		m1  = -((x2 - x1) / (y2 - y1));
		mx1 = (x1 + x2) / 2.0;
		my1 = (y1 + y2) / 2.0;
		xc  = (x3 + x2) / 2.0;
		yc  = m1 * (xc - mx1) + my1;
	} else {
		m1  = -((x2 - x1) / (y2 - y1));
		m2  = -((x3 - x2) / (y3 - y2));
		mx1 = (x1 + x2) / 2.0;
		mx2 = (x2 + x3) / 2.0;
		my1 = (y1 + y2) / 2.0;
		my2 = (y2 + y3) / 2.0;
		xc  = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
		yc  = (fabsy1y2 > fabsy2y3) ?
			m1 * (xc - mx1) + my1 :
			m2 * (xc - mx2) + my2;
	}

  dx = x2 - xc;
  dy = y2 - yc;

	return new Circle(i, j, k, xc, yc, dx * dx + dy * dy);
}

PVector[] supertriangle(ArrayList<PVector> vertices, int[] indices) {
	float xMin = -1;
	float yMin = -1;
	float xMax = width + 1; 
	float yMax = height + 1;
	for (int i = indices.length - 1; i > 0; i--) {
		PVector vertex = vertices.get(i);
		if (vertex.x < xMin) xMin = vertex.x;
		if (vertex.x > xMax) xMax = vertex.x;
		if (vertex.y < yMin) yMin = vertex.y;
		if (vertex.y > yMax) yMax = vertex.y;
	}

	float dx = xMax - xMin;
	float dy = yMax - yMin;
	float dMax = max(dx, dy);
	float xMid = xMin + dx * 0.5;
	float yMid = yMin + dy * 0.5;

	PVector[] st = {
		new PVector(xMid - 20 * dMax, yMid - dMax), 
		new PVector(xMid, yMid + 20 * dMax),
		new PVector(xMid + 20 * dMax, yMid - dMax)
	};

	return st;
}

ArrayList<Integer> triangulate(ArrayList<Particle> particles) {
	int n = particles.size();
	ArrayList<PVector> vertices = new ArrayList<PVector>();
	// Particle[] particleArray = new Particle[particles.size()];
	// particleArray = particles.toArray(particleArray);

	for (int i = 0; i < particles.size(); i++) {
		Particle particle = particles.get(i);
		vertices.add(new PVector(particle.pos.x, particle.pos.y));
	}
	
	int[] indices = new int[particles.size()];
	for (int i = indices.length - 1; i > 0; i--) indices[i] = i;

	// Arrays.sort(vertices, new Comparator<PVector>() {
	// 	public Integer compare(Integer idx1, Integer idx2) {
	// 		return Float.compare(vertices[idx1].x, vertices[idx2].x);
	// 	}
	// });

	PVector[] st = supertriangle(vertices, indices);
	vertices.add(st[0]);
	vertices.add(st[1]);
	vertices.add(st[2]);

	Circle circCircle = circumcircle(vertices, n, n + 1, n + 2);
	if (circCircle == null) return new ArrayList<Integer>();

	ArrayList<Circle> closed = new ArrayList<Circle>();
	ArrayList<Circle> open = new ArrayList<Circle>();
	ArrayList<Integer> edges = new ArrayList<Integer>();

	for (int i = indices.length - 1; i > 0; i--) {
		int c = indices[i];

		println(i);

		for (int j = open.size(); j > 0; j--) {
			edges.clear();

			float dx = vertices.get(c).x - open.get(j).x;
			if (dx > 0.0 && dx * dx > open.get(j).r) {
				closed.add(open.get(j));
				open.remove(j);
				continue;
			}


			float dy = vertices.get(c).y - vertices.get(j).y;
			if (dx * dx + dy * dy - open.get(j).r > EPSILON) continue;

			edges.add(open.get(j).i);
			edges.add(open.get(j).j);
			edges.add(open.get(j).k);
			edges.add(open.get(j).k);
			edges.add(open.get(j).i);

			// float[] newEdges = { 
			// 	open[j].i, open[j].j, 
			// 	open[j].j, open[j].k, 
			// 	open[j].k, open[j].i 
			// };

			// edges.addAll(newEdges);
			open.remove(j);

		}
		// TODO: remove dup edges

		for (int j = edges.size() - 1; j > 0;) {
			int b = edges.get(--j);
			int a = edges.get(--j);
			open.add(circumcircle(vertices, a, b, c));
		}
	}

	for (int i = open.size() - 1; i > 0; i--) {
		closed.add(open.get(i));
	}
	open.clear();

	ArrayList<Integer> ret = new ArrayList<Integer>();
	for (int i = closed.size() - 1; i > 0; i--) {
		if (closed.get(i).i < n && closed.get(i).j < n && closed.get(i).k < n) {
			ret.add(closed.get(i).i);
			ret.add(closed.get(i).j);
			ret.add(closed.get(i).k);
			// float[] newOpen = { closed[i].i, closed[i].j, closed[i].k };
			// open.addAll(newOpen);
		}
	}

	println("CLOSED: ", closed.size());

	return ret;
}
