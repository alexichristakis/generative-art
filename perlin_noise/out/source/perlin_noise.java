import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class perlin_noise extends PApplet {



int NUM_COLORS = 3;
int NUM_PARTICLES = 800;
int NOISE_SCALE = 800;
Particle[][] particles = new Particle[NUM_COLORS][NUM_PARTICLES];

int[] colors = { color(69,33,124), color(7,153,242), color(255) };

class Particle {
    float speed = 1;
    PVector dir = new PVector(0, 0);
    PVector vel = new PVector(0, 0);
    PVector pos;
    int col;

    Particle(float x, float y, int col) {
        pos = new PVector(x, y);
        this.col = col;
    }

    public void move() {
        float angle = noise(pos.x / NOISE_SCALE, pos.y / NOISE_SCALE) * TWO_PI * NOISE_SCALE;
        dir.x = cos(angle);
        dir.y = sin(angle);
        vel = dir.copy();
        vel.mult(speed);
        pos.add(vel);
    }

    public void checkEdge() {
        if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
            pos.x = random(50, width);
            pos.y = random(50, height);
        }
    }

    public void draw(float r, int alpha) {
        fill(col);
        alpha(alpha);

        circle(pos.x, pos.y, r);
        checkEdge();
    }

}

public void setup() {
    

    background(21, 8, 50);

    for (int col = 0; col < NUM_COLORS; col++) {
        for (int particle = 0; particle < NUM_PARTICLES; particle++) {
            particles[col][particle] = new Particle(random(0, width), random(0,height), colors[col]);
        }
	}
}

public void draw() {
    noStroke();
	smooth();

    fill(21, 8, 50, 10);
    rect(0, 0, width, height);

    for (int col = 0; col < NUM_COLORS; col++) {
        for (int particle = 0; particle < NUM_PARTICLES; particle++) {
            float radius = map(particle, 0, NUM_PARTICLES, 1, 4);
		    int alpha = (int) map(particle, 0, NUM_PARTICLES, 0, 250);

            particles[col][particle].move();
            particles[col][particle].draw(radius, alpha);
        }
	}

}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "perlin_noise" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
