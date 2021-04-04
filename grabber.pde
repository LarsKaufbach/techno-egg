import processing.sound.*;

class AudioGrab {

  private final AudioIn in;
  private final PApplet applet;
  private FFT fft;
  private float[] spectrum;
  
  AudioGrab(PApplet applet, int inputDevice, int bands) {
    this.applet = applet;
    new Sound(applet).inputDevice(inputDevice);
    in = new AudioIn(applet, 0);
    in.start();
    initFft(bands);
  }
  
  void initFft(int bands) {
    spectrum = new float[bands];
    fft = new FFT(applet, bands);
    fft.input(in);
  }    
 
  int getBandsCount() { return spectrum.length; }
  
  float[] analyze() {
     fft.analyze(spectrum);
     return spectrum;
  }
}
