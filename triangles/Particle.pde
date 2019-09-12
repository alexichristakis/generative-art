int MAX_LEVEL = 5;

class Circle {
    int i, j, k;
    float x, y, r;

    Circle(int i, int j, int k, float cx, float cy, float r) {
        this.i = i;
        this.j = j;
        this.k = k;
        this.x = cx;
        this.y = cy;
        this.r = r;
    }
}

class Particle {
    PVector vel, pos;
    float level;
    float life = 0;

    Particle(float x, float y, float level) {
        // this.x = x;
        // this.y = y;
        this.level = level;

        this.pos = new PVector(x, y);
        this.vel = PVector.random2D();
        this.vel.mult(map(level, 0, MAX_LEVEL, 5, 2));
    }

    void move(ArrayList<Particle> particles) {
        life++;

        vel.mult(0.9);
        pos.add(vel);

        if (life % 10 == 0) {
            if (level > 0) {
                level -= 1;
                Particle newParticle = new Particle(pos.x, pos.y, level-1);
                particles.add(newParticle);
            }
        }

    }
}