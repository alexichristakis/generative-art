int NUM_COLORS = 3;
int NOISE_SCALE = 800;
int NUM_BALLS = 12;
float SPRING = 0.05;
float GRAVITY = 0.03;
float FRICTION = -0.9;

Ball[] balls = new Ball[NUM_BALLS];
ArrayList<Particle>[] particles = new ArrayList[NUM_COLORS];

color[] colors = { color(69,33,124), color(7,153,242), color(255) };

class Particle {
    float speed = 5;
    PVector dir = new PVector(0, 0);
    PVector vel = new PVector(0, 0);
    PVector pos;
    color col;

    Particle(float x, float y, color col) {
        pos = new PVector(x, y);
        this.col = col;
    }

    void move() {
        float angle = noise(pos.x / NOISE_SCALE, pos.y / NOISE_SCALE) * TWO_PI * NOISE_SCALE;
        dir.x = cos(angle);
        dir.y = sin(angle);
        vel = dir.copy();
        vel.mult(speed);
        pos.add(vel);
    }

    void checkEdge() {
        if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
            pos.x = random(50, width);
            pos.y = random(50, height);
        }
    }

    void draw(float r, int alpha) {
        fill(col);
        alpha(alpha);

        circle(pos.x, pos.y, r);
        checkEdge();
    }

}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * SPRING;
        float ay = (targetY - others[i].y) * SPRING;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += GRAVITY;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= FRICTION; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= FRICTION;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= FRICTION; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= FRICTION;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}

void setup() {
    fullScreen(P3D);

    background(21, 8, 50);

    // for (int col = 0; col < NUM_COLORS; col++) {
    //     for (int particle = 0; particle < NUM_PARTICLES; particle++) {
    //         particles[col][particle] = new Particle(random(0, width), random(0,height), colors[col]);
    //     }
	// }
}

void draw() {
    fill(21, 8, 50, 10);
    rect(0, 0, width, height);



    for (ArrayList<Particle> particleList : particles) {
        for (int particle = 0; particle < partcileList.size(); particle++) {
            float radius = map(particle, 0, NUM_PARTICLES, 1, 4);
		    int alpha = (int) map(particle, 0, NUM_PARTICLES, 0, 250);

            particleList[particle].move();
            particleList[particle].draw(radius, alpha);
        }
	}

    for (Ball ball : balls) {
        ball.collide();
        ball.move();
        ball.display();  
    }


}