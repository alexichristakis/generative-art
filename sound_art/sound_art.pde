import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioInput input;
FFT fft;
BeatDetect beat;
BeatListener bl;


float bass = 0;
float lowMid = 0;
float mid = 0;
float highMid = 0;
float high = 0;

float kickSize, snareSize, hatSize;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;
  
  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup() {
  size(1500, 1000, P3D);
  colorMode(HSB);

  minim = new Minim(this);

  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
}

void draw() {
  bass = 0.7 * bass; //,  , highMid, high = 0, 0, 0, 0, 0;
  lowMid = 0.7 * lowMid;
  mid = 0.7 * mid;

  fft.forward(input.mix);

  for (float freq = 0; freq < 50; freq+=5) {
    bass += fft.getFreq(freq);
  }

  float col = map(bass, 20, 800, 60, 400);
  background(col, 360, 360);

  fill(255);
  circle(width / 4, height / 2, bass);

  for (float freq = 150; freq < 400; freq+=5) {
    lowMid += fft.getFreq(freq);
  }

  fill(230);
  circle(width / 2, height / 2, lowMid / 2);

  for (float freq = 400; freq < 1000; freq+=5) {
    mid += fft.getFreq(freq);
  }

  fill(230);
  circle(3 * width / 4, height / 2, mid / 2);

  for (float freq = 150; freq < 500; freq+=5) {
    lowMid += fft.getFreq(freq);
  }
 
  for (float freq = 0; freq < 1000; freq++) {
    float val = fft.getFreq(freq);
    rect(freq / 1000 * width, height, width / 1000, -1*val*20);
  }

}