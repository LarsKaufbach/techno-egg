import java.util.List;
import java.util.ArrayList;

private final int TEXT_SIZE = 16;


class GUI {

  private final PFont arial;
  private final List<Line> lines = new ArrayList<Line>();
  
  GUI() {
    arial = createFont("Arial", TEXT_SIZE);
  }
  
  void render() {
    camera();
    noLights();
    fill(255);
    textAlign(LEFT, TOP);
    textFont(arial);
    
    int y = 4;
    for (Line line : lines) {
      text(line.text, 4, y);
      y += TEXT_SIZE;
    }
    checkOld();
  }
  
  void addLine(String line) {
    lines.add(new Line(frameCount, line));
  }
  
  void checkOld() {
    while(!lines.isEmpty() && lines.get(0).created < frameCount - 100) {
      lines.remove(0);
    }
  }
}

class Line {
  
  private final int created;
  private final String text;
  
  Line(int created, String text) {
    this.created = created;
    this.text = text;
  }
}
