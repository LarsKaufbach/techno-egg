
private final String MODE_GAIN = "gain"; 
private final String MODE_LOG_FACTOR = "logFactor";

private final ModeSwitcher MODE_SWITCHER = new ModeSwitcher('m', "Mode",
  new Mode[] {
    new GainMode(),
    new LogFactorMode(),
    new BandsMode(),
    new DividerMode(),
    new OffsetMode(),
    new DeadzoneMode()
  }
);

private final Action[] ACTIONS = new Action[] {
  new ToggleOrientationAction()
};


class Control {
  
  private final Core core;
  private final HashMap<Character, ModeSwitcher> char2switcher = new HashMap();
  private final HashMap<Character, Action> char2action = new HashMap();
  
  private boolean shiftDown = false;
  private ModeSwitcher switcher = null;
  
  Control(Core core) {
    this.core = core;
    
    add(MODE_SWITCHER);
    for(Action action : ACTIONS) {
      char2action.put(action.keyChar, action);
    }
  }
 
  void add(ModeSwitcher switcher) {
    char2switcher.put(switcher.keyChar, switcher);
  }
  
  void keyDown() {
    if (keyCode == 16) {
      shiftDown = true;
      return;
    }
    if (switcher == null) {
      switcher = char2switcher.get(key);
      if (switcher != null) {
        core.gui.addLine("Switcher: " + switcher.name);
      } else {
        Action action = char2action.get(key);
        if (action != null) {
          String result = action.perform(core, shiftDown);
          if (result != null) {
            core.gui.addLine(action.name + ": " + result);
          }
        }
      }
    } else {
      if (switcher.switchByKeyChar(key)) {
        core.gui.addLine(switcher.name + ": " + switcher.getCurrentMode().name);
        switcher = null;
      }
    }
  }
  
  void keyUp() {
    if (keyCode == 16) {
      shiftDown = false;
      return;
    }
  }
  
  void mouseWheeled(int amount) {
    for(ModeSwitcher switcher : char2switcher.values()) {
      String result = switcher.getCurrentMode().onMouseWheel(core, shiftDown, amount);
      if (result != null) {
        core.gui.addLine(result);
      }
    }
  }
}

abstract class Mode {
  public final char keyChar;
  public final String name;
  
  Mode(char keyChar, String name) {
    this.keyChar = keyChar;
    this.name = name;
  }
  
  String onMouseWheel(Core core, boolean shiftDown, float amount) { return null; }
  String onMouseDown(Core core, boolean shiftDown, int button) { return null; }
  String onMouseKey(Core core, boolean shiftDown, int button) { return null; }
  String onKeyDown(Core core, boolean shiftDown, int keyCode) { return null; }
  String onKeyUp(Core core, boolean shiftDown, int keyCode) { return null; }
}

class ModeSwitcher {
  
  public final char keyChar;
  public final String name;
  private final HashMap<Character, Mode> char2mode = new HashMap();  
  private Mode currentMode = null;
  
  ModeSwitcher(char keyChar, String name, Mode[] modes) {
    this.keyChar = keyChar;
    this.name = name;
    for (Mode mode : modes) {
      char2mode.put(mode.keyChar, mode);
    }
    currentMode = modes[0];
  }
  
  Mode getCurrentMode() { return currentMode; }
  
  boolean switchByKeyChar(char keyChar) {
    if (char2mode.containsKey(keyChar)) {
      currentMode = char2mode.get(keyChar);
      return true;
    }
    return false;
  }
}

class GainMode extends Mode {
  GainMode() { super('g', "Gain"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    Egg egg = core.egg;
    egg.gain = Math.max(1, egg.gain - amount);
    return "Gain: " + egg.gain;
  }
}

class LogFactorMode extends Mode {
  LogFactorMode() { super('l', "LogFactor"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    Egg egg = core.egg;
    egg.logFactor = Math.max(1, egg.logFactor - amount);
    return "LogFactor: " + egg.logFactor;
  }
}

class BandsMode extends Mode {
  BandsMode() { super('b', "Bands"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    int exponent = round(log(core.grabber.getBandsCount()) / log(2));
    exponent = Math.max(0, Math.min(12, exponent - round(amount)));
    final int bands = (int)pow(2, exponent);
    core.grabber.initFft(bands);
    return "Bands: " + bands;
  }
}

class DividerMode extends Mode {
  DividerMode() { super('d', "Divider"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    int value = Math.max(1, Math.min(core.grabber.getBandsCount(), core.egg.divider - round(amount)));
    core.egg.divider = value;
    return "Divider: " + value;
  }
}

class OffsetMode extends Mode {
  OffsetMode() { super('o', "Offset"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    int maxOffset = core.grabber.getBandsCount() - core.grabber.getBandsCount() / core.egg.divider; 
    int value = Math.max(1, Math.min(maxOffset, core.egg.offset - round(amount)));
    core.egg.offset = value;
    return "Offset: " + value;
  }
}

class DeadzoneMode extends Mode {
  DeadzoneMode() { super('d', "Deadzone"); }
  String onMouseWheel(Core core, boolean shiftDown, float amount) {
    float value = core.egg.deadzone - amount / 10.0; 
    value = Math.max(0, Math.min(1, value));
    core.egg.deadzone = value;
    return "Deadzone: " + value;
  }
}
abstract class Action {
  
  public final char keyChar;
  public final String name;

  Action(char keyChar, String name) {
    this.keyChar = keyChar;
    this.name = name;
  }
  
  abstract String perform(Core core, boolean shiftDown);
}

class ToggleOrientationAction extends Action {
  ToggleOrientationAction() { super('o', "Orientation"); }
  String perform(Core core, boolean shiftDown) {
    core.egg.vertical = !core.egg.vertical;
    return core.egg.vertical ? "vertical" : "horizontal";
  }
}
