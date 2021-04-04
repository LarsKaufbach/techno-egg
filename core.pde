class Core {
  
  public final Egg egg;
  public final Camera cam;
  public final AudioGrab grabber;
  public final GUI gui;
  
  Core(Egg egg, Camera cam, AudioGrab grabber, GUI gui) {
    this.egg = egg;
    this.cam = cam;
    this.grabber = grabber;
    this.gui = gui;
  }
}
