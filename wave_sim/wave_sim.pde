float increment = 0.01;
float zoff = 0.0;  
float zincrement = 0.02;
int X_RES = 200;
int Y_RES = 200;

void setup() {
  // size(1000, 1000, P3D);
  fullScreen(P3D);
  colorMode(HSB);
}

void draw() {
  background(0);
  stroke(0);
  
  noiseDetail(8,0.65f);
  
  float xoff = 0.0;
  
  // beginShape(TRIANGLES);
  strokeWeight(4);
  for (int x = 0; x < X_RES; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < Y_RES; y++) {
      yoff += increment;
      
      float bright = noise(xoff,yoff,zoff)*255;
      stroke(bright, 360, 360);
      point(x * width / X_RES, y * height / Y_RES, bright);

    }
  }
  // endShape();
  
  zoff += zincrement;
}
