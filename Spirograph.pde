/**
 * Spirograph drawing application, inspired by javidx9 (https://www.youtube.com/watch?v=AY99hF3kVH8)
 *
 * @author nulltan
 */
import processing.core.PApplet;
import processing.core.PVector;
import java.awt.event.KeyEvent;
import java.io.File;
import processing.core.PFont;
import processing.core.PGraphics;

//public class Spirograph extends PApplet {

int winWidth, winHeight;

float fixedGearRadius, movingGearRadius, penRadius, accumulateAngle, gearRatio;
PVector center, movingGearPos, penOffset, penPos, prevPenPos;
PGraphics spiro;
boolean bFirstDraw, bRainbow;
float spiroHue, penAdvance;
PFont spiroFont;
String message;
int messageTimer;

@Override
  public void settings() {
  size(800, 800);
}

@Override
  public void setup() {
  surface.setResizable(true);

  spiro = createGraphics(width, height);

  center = new PVector();
  movingGearPos = new PVector();
  penOffset = new PVector();
  penPos = new PVector();
  prevPenPos = new PVector();
  bFirstDraw = true;

  resizeComponents();

  fixedGearRadius = 300f;
  movingGearRadius = 200f;
  penRadius = 150f;
  penAdvance = 0f;
  accumulateAngle = 0f;

  colorMode(HSB, 360, 100, 100, 100);
  spiroHue = 0;
  bRainbow = false;

  spiroFont = createFont("Hack-Regular.ttf", 12);
  textFont(spiroFont);
  
  message = "";
  messageTimer = 0;
}

@Override
  public void draw() {
  if (isWindowResized()) {
    resizeComponents();
  }

  if (keyPressed && key == 'r') {
    resetSpiroPos();
  }

  if (keyPressed && key == 'c') {
    clearSpiro();
  }

  if (keyPressed && key == KeyEvent.VK_SPACE) {
    advanceSpiro();
  }

  if (keyPressed && key == 'u') { // lower fixed gear size
    fixedGearRadius -= 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == 'i') { // increase fixed gear size
    fixedGearRadius += 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == 'j') { // lower moving gear size
    movingGearRadius -= 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == 'k') { // increase moving gear size
    movingGearRadius += 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == 'n') { // lower pen offset
    penRadius -= 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == 'm') { // increase pen offset
    penRadius += 0.1f;
    bFirstDraw = true;
  }

  if (keyPressed && key == KeyEvent.VK_COMMA) { // lower pen advance
    advancePen(-0.01f);
  }

  if (keyPressed && key == KeyEvent.VK_PERIOD) { // increase pen advance
    advancePen(0.01f);
  }

  if (keyPressed && keyCode == KeyEvent.VK_LEFT) { // rotate ccw
    rotateSpiro(-0.01f);
  }

  if (keyPressed && keyCode == KeyEvent.VK_RIGHT) { // rotate cw
    rotateSpiro(0.01f);
  }

  if (keyPressed && key == '[') { // lower hue
    spiroHue -= 1f;
    if (spiroHue < 0)
      spiroHue += 360;
  }

  if (keyPressed && key == ']') { // increase hue
    spiroHue += 1f;
    spiroHue %= 360;
  }

  movingGearPos.set(
    (fixedGearRadius - movingGearRadius) * cos(accumulateAngle),
    (fixedGearRadius - movingGearRadius) * sin(accumulateAngle)
    ).add(center);

  gearRatio = fixedGearRadius / movingGearRadius;

  penOffset.set(
    penRadius * cos((-accumulateAngle * gearRatio) + penAdvance),
    penRadius * sin((-accumulateAngle * gearRatio) + penAdvance)
    );

  penPos.set(movingGearPos).add(penOffset);

  if (bFirstDraw) {
    prevPenPos.set(penPos);
    bFirstDraw = false;
  }

  if (keyPressed && key == KeyEvent.VK_SPACE) {
    spiro.beginDraw();
    spiro.noFill();
    spiro.stroke(spiroHue, 90, 100);
    spiro.strokeWeight(4);
    spiro.line(prevPenPos.x, prevPenPos.y, penPos.x, penPos.y);
    spiro.endDraw();
    prevPenPos.set(penPos);
  }

  background(0);

  // draw spirograph pattern
  image(spiro, 0, 0);

  //draw the gears
  noFill();
  stroke(0, 0, 90);

  ellipse(center.x, center.y, fixedGearRadius * 2, fixedGearRadius * 2);
  ellipse(movingGearPos.x, movingGearPos.y, movingGearRadius * 2, movingGearRadius * 2);
  ellipse(penPos.x, penPos.y, 4, 4);

  // draw text info
  text(String.format("u/i  fixed gear: %.1f", fixedGearRadius), 10, 12);
  text(String.format("j/k moving gear: %.1f", movingGearRadius), 10, 24);
  text(String.format("n/m  pen offset: %.1f", penRadius), 10, 36);
  text("(S)ave to file. " + message, 10, 48);

  text(String.format(",/. advance: %.1f\u00b0", map(penAdvance, 0, TAU, 0, 360)), 200, 12);
  text(String.format("</>   angle: %.1f\u00b0", map(accumulateAngle, 0, TAU, 0, 360)), 200, 24);
  if (bRainbow) {
    text("p/[/]   hue: Rainbow", 200, 36);
  } else {
    text(String.format("p/[/]   hue: %.3f", spiroHue), 200, 36);
  }
  
  if(messageTimer > 0) {
    messageTimer--;
  } else if (messageTimer == 0) {
    message = "";
  }
}

public void keyPressed() {
  if (key == 's') {
    selectOutput("Select a file to save spirograph.", "saveSpiro");
  } else if (key == 'p') {
    bRainbow = !bRainbow;
  }
}

public void resetSpiroPos() {
  accumulateAngle = 0f;
  penAdvance = 0f;
  bFirstDraw = true;
}

public void clearSpiro() {
  spiro.beginDraw();
  spiro.colorMode(HSB, 360, 100, 100, 100);
  spiro.clear();
  spiro.endDraw();
}

public void saveSpiro(File selection) {
  if (selection == null) {
    logMessage("No file selected.");
    //} else if (!selection.canWrite()) {
    //System.out.println("Can not write to file.");
  } else {
    String filepath = selection.getAbsolutePath();
    if (!filepath.endsWith(".png")) {
      filepath += ".png";
    }
    spiro.save(filepath);
    logMessage("Saved to " + new File(filepath).getName());
  }
}

public void advancePen(float v) {
  penAdvance += v;
  bFirstDraw = true;
}

public void rotateSpiro(float r) {
  accumulateAngle += r;
  bFirstDraw = true;
}

public void advanceSpiro() {
  float delta = 1 / frameRate;
  accumulateAngle += delta;
  if (bRainbow) {
    spiroHue += delta * 3;
    spiroHue %= 360;
  }
}

public boolean isWindowResized() {
  if (winWidth != width || winHeight != height) {
    return true;
  }
  return false;
}

public void resizeComponents() {
  winWidth = width;
  winHeight = height;
  center.set(width / 2, height / 2);

  spiro.setSize(width, height);
}

public void logMessage(String m) {
  message = m;
  messageTimer = 300;
}
