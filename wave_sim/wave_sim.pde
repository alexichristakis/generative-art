float INCREMENT = 0.01;
float Z_INCREMENT = 0.02;

float zoff = 0.0;

String[] lines;
ArrayList<Rectangle> bectonScreens = new ArrayList<Rectangle>();

class Rectangle {
  float x1, x2, y1, y2, w, h;
  int i;

  Rectangle(float[] upperLeft, float[] bottomRight, int i) {
    x1 = upperLeft[0];
    y1 = upperLeft[1];
    x2 = bottomRight[0];
    y2 = bottomRight[1];

    w = Math.abs(x2 - x1);
    h = Math.abs(y2 - y1);

    this.i = i;
  }

  void draw() {
    int xRes = (int) w / 5;
    int yRes = (int) h / 5;

    strokeWeight(6);

    float xoff = 0;
    for (int x = 0; x < xRes; x++) {
      xoff += INCREMENT;
      float yoff = 0.0;
      for (int y = 0; y < yRes; y++) {
        yoff += INCREMENT;
        
        float bright = noise(xoff, yoff, zoff) * 280;
        stroke(bright, 360, 360);

        if (i == 0) {
          point(x1 - 100 + x * (w + 100) / xRes, y1 + y * h / yRes, bright);
        } else {
          point(x1 - 100 + x * w / xRes, y1 - 100 + y * (h + 100) / yRes, bright);
        }
      }
    }

  }

  void print(int i) {
    int regionNumber = i + 1;
    println("Region " + regionNumber + ": " + Math.abs(w) + " x " + Math.abs(h));
  }
}


void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  noiseDetail(8,0.3f);

  lines = loadStrings("screen_positions.txt");
  for (int i = 0; i < lines.length; i++) {
    String[] coords = lines[i].split(", ", 4);
    
    float[] coord1 = { parseFloat(coords[0]), parseFloat(coords[2]) };
    float[] coord2 = { parseFloat(coords[1]), parseFloat(coords[3]) };
    
    bectonScreens.add(new Rectangle(coord1, coord2, i));
  }
}

void draw() {
  background(0);
    
  float xoff = 0.0;
  for (int i = 0; i < bectonScreens.size(); i++) {
    bectonScreens.get(i).draw();
  }

  zoff += Z_INCREMENT;
}
