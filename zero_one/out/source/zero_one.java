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
int RESOLUTION = 50;
int[] colors = { color(69,33,124), color(7,153,242), color(255) };
ArrayList<Row> rows = new ArrayList<Row>();

class Point {
    float x, y, z;
    Point(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    Point(float x, float y) {
        this.x = x;
        this.y = y;
        this.z = 0;
    }
}

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
        stroke(255);

        top -= max(60 / (frame + 10), 0.8f);
        for (int i = 0; i < boxes.length; i++) {
            boxes[i].draw(top);
        }
    }
}


class Box {
    int col;
    float speed, index, size, progress, offset;

    Box(int index, float size) {
        this.size = size;
        this.index = index;
        this.speed = random(0.01f, 0.2f);
        this.offset = random(1, 3 * size / 4);
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

        // strokeWeight(2);
        // fill(0);

        // float cx = index * size + size / 2;
        // float cy = top + offsetProgress + size / 2;

        // float x2 = map(cos(progress), -1, 1, cx - size / 2, cx + size / 2);
        // float y2 = map(sin(progress), -1, 1, cy - size / 2, cy + size / 2);
        // circle(cx, cy, offsetProgress - size);
        // line(cx, cy, x2, y2);

        // push();
        // drawCylinder(new Point(cx, cy), 10, size / 2, 50, speed);
        // pop();

        progress += speed;
    }
}

public void setup() {
    
    background(0);

    frame = 0;
    rows.add(new Row(random(10, 100), height / 2));
}

public void cleanRows(ArrayList<Row> rows) {
    for (int i = rows.size() - 1; i > 0; i--) {
        Row row = rows.get(i);
        if (row.top + row.rowSize < 0) {
            rows.remove(i);
        }
    }
}


public void drawCylinder(Point center, float topRadius, float bottomRadius, float tall, float speed) {
  float angle = frame * speed * TWO_PI / 60;
  float angleIncrement = (TWO_PI / 3) / RESOLUTION;
  fill(232);
  noStroke();
  beginShape(QUAD_STRIP);
  for (int i = 0; i < RESOLUTION + 1; ++i) {
    vertex(topRadius*cos(angle) + center.x, topRadius*sin(angle) + center.y, tall);
    vertex(bottomRadius*cos(angle) + center.x, center.y + bottomRadius*sin(angle), 0);
    angle += angleIncrement;
  }
  endShape();
}


public void draw() {
    background(0);
    // directionalLight(51, 102, 126, -1, 0, 0);


    cleanRows(rows);
    float availHeight = height - rows.get(0).top - rows.get(0).rowSize;

    println(availHeight);

    // rotateY(map(mouseX, 0, width, 0, PI));
    // rotateZ(map(mouseY, 0, height, 0, -PI));


    

    if (frame % 30 == 0) {
        if (availHeight / 2 > 100) {
            Row prevRow = rows.get(0);
            Row newRow = new Row(random(50, availHeight / 2), prevRow.top + prevRow.rowSize);
            rows.add(0, newRow);

            frame = 0;
        }
    }

    for (Row row : rows) {
        row.draw();
    }

    // fill(232);
    // stroke(232);
    // strokeWeight(1);
    // drawCylinder(width / 2, height / 2, 10, 100, 50, 50);

    frame++;
}
  public void settings() {  size(1000,1000, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "zero_one" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
