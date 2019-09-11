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

public class zero_one extends PApplet {

int frame;
int NOISE_SCALE = 800;
int[] colors = { color(69,33,124), color(7,153,242), color(255) };
ArrayList<Row> rows = new ArrayList<Row>();


class Row {
    Box[] boxes;
    float rowSize, numCells, top;

    Row(float rowSize, float top) {
        this.rowSize = rowSize;
        this.top = top;

        int numCells = (int) (width / rowSize) + 1;
        boxes = new Box[numCells];
        for (int i = 0; i < boxes.length; i++) {
            boxes[i] = new Box(i, rowSize);
        }
    }

    public void draw() {
        top -= 60 / (frame + 10);
        for (int i = 0; i < boxes.length; i++) {
            boxes[i].draw(top);
        }
    }
}


class Box {
    int col;
    float speed, index, size, progress, offset;
    ArrayList<Particle> particles = new ArrayList<Particle>();

    Box(int index, float size) {
        this.size = size;
        this.index = index;
        this.speed = random(0.01f, 0.2f);
        this.offset = random(1, 50);
        this.progress = 0;
        this.col = colors[(int) random(0, 2)];
    }

    public void draw(float top) {
        float offsetProgress = max(map(progress, 0, 1, offset, 0), 0);
        float fillProgress = min(map(progress, 0, 0.5f, 0, size), size);

        fill(0);
        rect(index * size, top + offsetProgress, size, size);

        fill(255);
        rect(index * size, top + offsetProgress, size, size - fillProgress);

        strokeWeight(4);
        fill(0);

        float cx = index * size + size / 2;
        float cy = top + offsetProgress + size / 2;

        float x2 = map(cos(progress), -1, 1, cx - size / 2, cx + size / 2);
        float y2 = map(sin(progress), -1, 1, cy - size / 2, cy + size / 2);
        // circle(cx, cy, offsetProgress - size);
        line(cx, cy, x2, y2);

        for (Particle particle : particles) {
            particle.move();
            particle.draw(random(1, 4), (int) random(0, 250));
        }
        
        

        if (progress % 1 == 0) {
            particles.add(new Particle(x2, y2, col));
        }

        progress += speed;
    }
}

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
    
    background(0);

    frame = 0;
    rows.add(new Row(random(10, 100), height / 2));
}

public float updateRows(ArrayList<Row> rows) {
    for (int i = rows.size() - 1; i > 0; i--) {
        Row row = rows.get(i);
        if (row.top + row.rowSize < 0) {
            rows.remove(i);
        }
    }


    float rowsHeight = 0;
    for (Row row : rows) rowsHeight += row.rowSize;

    return rowsHeight;
}


public void draw() {
    background(0);
    fill(0);
    stroke(255);

    float rowsHeight = updateRows(rows);
    float availHeight = height - rowsHeight;

    if (frame % 60 == 0) {
        if (availHeight / 2 > 30) {
            Row prevRow = rows.get(0);
            Row newRow = new Row(random(10, availHeight / 2), prevRow.top + prevRow.rowSize);
            rows.add(0, newRow);
        }

        frame = 0;  
    }

    for (Row row : rows) {
        row.draw();
    }

    frame++;
}
  public void settings() {  size(1000,1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "zero_one" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
