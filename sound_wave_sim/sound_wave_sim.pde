import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioInput input;
FFT fft;

// float increment = 0.01;
float increment = 0.5;
float zoff = 0.0;
float zincrement = 0.02;
int X_RES = 100;
int Y_RES = 100;

void setup() {
  size(660, 1000, P3D);
  // fullScreen(P3D);
  colorMode(HSB);
	

  minim = new Minim(this);

  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
}

void draw() {
  background(0);
  stroke(0);
	translate(width / 2, height / 2);
  
//   noiseDetail(8,0.65f);

  fft.forward(input.mix);
  
  float xoff = 0.0;
  
  beginShape(TRIANGLES);
  strokeWeight(4);
	for (int r = 0; r < width / 2; r += 5) {
		xoff += increment;
		float yoff = 0.0;
		for (float theta = 0; theta < TWO_PI; theta += PI / 100) {
			yoff += increment;

			float bright = fft.getFreq(r)*100;
			stroke(bright, 360, 360);
			point(r * cos(theta), r * sin(theta), bright / 2);
		}
	}

	// float[] spectrum = new float[500];
	// for (int i = 0; i < 500; i++) {
	// 	spectrum[i] = fft.getFreq((float) Math.pow(i, 1.5));
	// }

	float[] spectrum = fft.getSpectrumReal();

	// strokeWeight(2);
  // for (int x = 0; x < X_RES; x++) {
  //   xoff += increment;
  //   float yoff = 0.0;
  //   for (int y = 0; y < Y_RES; y++) {
  //     yoff += increment;
      
  //     // float bright = noise(xoff,yoff,zoff)*255;
	// 		float bright = spectrum[x];
			
	// 		// println(bright);

  //     // stroke(bright * 255, 360, 360);
	// 		stroke(0, 360, 360);
  //     point(x * width / X_RES, y * height / Y_RES, bright * 10);

  //   }
  // }
  // endShape();
  
  zoff += zincrement;
}
