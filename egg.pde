

class Egg {

  final Color lowColor = new Color(255, 0, 0);
  final Color highColor = new Color(0, 255, 255);
  final Color[] colorArray = new Color[] {
    new Color(255, 0, 0),
    new Color(255, 255, 0),
    new Color(0, 255, 0),
    new Color(0, 255, 255),
    new Color(0, 0, 255),
    new Color(255, 0, 255)
  };
  final int coneSegs = 36;

  float gain = 26;
  boolean logMode = true;
  float logFactor = 1;
  int divider = 26;
  int offset = 0;
  boolean vertical = true;
  float deadzone = 0.0;
    
  void render(float[] spectrum) {
    
    ambientLight(255, 255, 255);
    //lightSpecular(128, 128, 128);
    directionalLight(96, 96, 96, -1, 0, -1);

    Band bassBand = new Band(spectrum, offset, spectrum.length / divider);

    //pointLight(255, 0, 0, 0, height / 2, 600);
    //renderBox();
    
    pushMatrix();
    if (vertical) {
      translate(0, width / 2.1, 0);
      rotateZ(PI);
    } else {
      translate(- width / 2, 0, 0);
      rotateZ(-HALF_PI);
    }

    noStroke();
    renderCylinders(bassBand);
    popMatrix();
  }
  
  void renderBox() {
    pushMatrix();
    //fill(24);
    translate(0, height / 2, 0);
    box(2000, 10, 2000);
    popMatrix();
  }
  
  void renderCylinders(Band band) {
    
    final float cylLength = width / (float)band.count;
    float lastIntensity = -1;
    float lastDiameter = -1;

    ambient(32, 16, 8);
    //specular(16);
    shininess(5.0);

    for (int i = 0; i < band.count; i ++) {
      
      float currentIntensity;
      if (logMode)
        currentIntensity =  (1 / logFactor) * log( logFactor * gain * band.get(i) + 1);
      else
        currentIntensity = gain * band.get(i);
      
      if (currentIntensity < deadzone)
        currentIntensity = 0.0;
        
      final float currentDiameter = diameterFor(i, band.count, currentIntensity);
      final float currentLength = lengthFor(i, band.count, currentIntensity);
      if (lastIntensity > -1) {
        Color emission = colorFor(i, band.count, Math.max(lastIntensity, currentIntensity)); 
        emissive(emission.r, emission.g, emission.b);        
        cone(lastDiameter, currentDiameter, currentLength, coneSegs);
        translate(0, currentLength);
      }
      lastIntensity = currentIntensity;
      lastDiameter = currentDiameter;
    }
    
  }
  
  Color colorFor(int index, int count, float intensity) {
    int stage = floor(colorArray.length * index / (float)count);
    return colorArray[stage].scale(0.7*intensity);
  }
  
  float diameterFor(int index, int count, float intensity) {
    final float maxRadius = height / 3;
    final float progress = index / ((float)count - 1);
    final float radius = sin(progress * PI) * maxRadius;
    final float disturbance = intensity * maxRadius;
    return (radius + disturbance);
  }
  
  float lengthFor(int index, int count, float intensity) {
    final float progress = index / ((float)count - 1);
    return (1.5*width / (float)count) * sin(progress * PI);
  }
  
}

static class Color {
  
  static Color lerp(Color from, Color to, float progress) {
    return new Color(
      round(from.r + (to.r - from.r) * progress),
      round(from.g + (to.g - from.g) * progress),
      round(from.b + (to.b - from.b) * progress)
    );
  }
  
  public int r;
  public int g;
  public int b;
  Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  Color scale(float ratio) {
    return new Color(
      round(this.r * ratio),
      round(this.g * ratio),
      round(this.b * ratio)
    );
  }
}
