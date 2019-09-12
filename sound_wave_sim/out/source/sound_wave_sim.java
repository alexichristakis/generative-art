import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sound_wave_sim extends PApplet {





Minim minim;
AudioInput input;
FFT fft;

// float increment = 0.01;
float increment = 0.5f;
float zoff = 0.0f;
float zincrement = 0.02f;
int X_RES = 100;
int Y_RES = 100;

public void setup() {
  
  // fullScreen(P3D);
  colorMode(HSB);
	

  minim = new Minim(this);

  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
}

public void draw() {
  background(0);
  stroke(0);
	// translate(width / 2, height / 2);
  
//   noiseDetail(8,0.65f);

  fft.forward(input.mix);
  
  float xoff = 0.0f;
  
  // beginShape(TRIANGLES);
  // strokeWeight(4);
	// for (int r = 0; r < width / 2; r += 5) {
	// 	xoff += increment;
	// 	float yoff = 0.0;
	// 	for (float theta = 0; theta < TWO_PI; theta += PI / 100) {
	// 		yoff += increment;

	// 		float bright = fft.getFreq(r)*100;
	// 		stroke(bright, 360, 360);
	// 		point(r * cos(theta), r * sin(theta), bright / 2);
	// 	}
	// }

	// float[] spectrum = new float[500];
	// for (int i = 0; i < 500; i++) {
	// 	spectrum[i] = fft.getFreq((float) Math.pow(i, 1.5));
	// }

	float[] spectrum = fft.getSpectrumReal();
	println(spectrum.length);


	strokeWeight(4);
  for (int x = 0; x < X_RES; x++) {
    xoff += increment;
    float yoff = 0.0f;
    for (int y = 0; y < Y_RES; y++) {
      yoff += increment;
      
      // float bright = noise(xoff,yoff,zoff)*255;
			float bright = spectrum[x];
			
			// println(bright);

      // stroke(bright * 255, 360, 360);
			stroke(0, 360, 360);
      point(x * width / X_RES, y * height / Y_RES, bright * 10);

    }
  }
  // endShape();
  
  zoff += zincrement;
}
  public void settings() {  size(1000, 1000, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sound_wave_sim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
