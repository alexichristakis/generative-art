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

public class wave_sim extends PApplet {

float increment = 0.01f;
float zoff = 0.0f;  
float zincrement = 0.02f;
int X_RES = 200;
int Y_RES = 200;

public void setup() {
  // size(1000, 1000, P3D);
  
  colorMode(HSB);
}

public void draw() {
  background(0);
  stroke(0);
  
  noiseDetail(8,0.65f);
  
  float xoff = 0.0f;
  
  // beginShape(TRIANGLES);
  strokeWeight(4);
  for (int x = 0; x < X_RES; x++) {
    xoff += increment;
    float yoff = 0.0f;
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
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "wave_sim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
