import java.util.Arrays;

final int bands = 2048;
final int sketchWidth = 720;
final int sketchHeight = 720;

Control control;
Core core;
Egg egg;
AudioGrab grabber;
Camera cam;
CameraControl camControl;
GUI gui;

void settings() {
  //fullScreen();
  size(sketchWidth, sketchHeight, P3D);
}

void setup() {
  frameRate(60);
  surface.setLocation(displayWidth - sketchWidth, (displayHeight - sketchHeight) / 2);
  grabber = new AudioGrab(this, 6, bands);
  egg = new Egg();
  cam = new Camera();
  gui = new GUI();
  core = new Core(egg, cam, grabber, gui);
  control = new Control(core);
  camControl = new MouseCameraControl(cam, gui);
}      

void draw() { 
  background(49, 54, 59);
  pushMatrix();
  cam.render();
  egg.render(grabber.analyze());
  popMatrix();
  gui.render();
}

void mouseMoved() {
  camControl.moved();
}

void mouseDragged() {
  camControl.moved();
}

void mouseWheel(MouseEvent evt) {
  control.mouseWheeled(evt.getCount());
}

void mousePressed() {
  camControl.mousePressed(mouseButton);
}

void mouseReleased() {
  camControl.mouseReleased(mouseButton);
}

void keyPressed() {
  control.keyDown();
}

void keyReleased() {
  control.keyUp();
}
