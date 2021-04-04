class Camera {
  
   float eyeX = width / 2.0;
   float eyeY = height / 2.0;
   float eyeZ = (height/2.0) / tan(PI*30.0 / 180.0);
   
   float centerX = width / 2.0;
   float centerY = height / 2.0;
   float centerZ = 0;
   
   float upX = 0;
   float upY = 1;
   float upZ = 0;
  
  void render() {
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  }
}

abstract class CameraControl {

  protected final Camera cam;
      
  CameraControl(Camera cam) {
    this.cam = cam;
  }
  
  abstract void moved();
  abstract void mousePressed(int button);
  abstract void mouseReleased(int button);
}

class MouseCameraControl extends CameraControl {
  
  private final GUI gui;

  private int lastMouseX = -1;
  private int lastMouseY = -1;
  private float rotation = HALF_PI;
  private float distance = 900;
  
  private boolean pressed = false;
  
  MouseCameraControl(Camera cam, GUI gui) {
    super(cam);
    
    this.gui = gui;
    cam.eyeX = 0;
    cam.eyeY = 0;    
    cam.eyeZ = distance;
    cam.centerX = 0;
    cam.centerY = 0;
    cam.centerZ = 0;
    updateCamPos();
  }
  
  void moved() {
    
    if (!pressed) return;
    
    final int nowMouseX = mouseX, nowMouseY = mouseY;
    if (lastMouseX != -1) {
      final int divX = nowMouseX - lastMouseX, divY = nowMouseY - lastMouseY;
      rotation -= divX / 100.0;
      distance += divY;
      updateCamPos();
    }
    lastMouseX = nowMouseX;
    lastMouseY = nowMouseY;
  }
  
  void updateCamPos() {
    cam.eyeX = sin(rotation) * distance;
    cam.eyeZ = cos(rotation) * distance;
  }
  
  void mousePressed(int button) {
    lastMouseX = mouseX;
    lastMouseY = mouseY;
    pressed = true;
  }
  
  void mouseReleased(int button) {
    pressed = false;
  }
}
