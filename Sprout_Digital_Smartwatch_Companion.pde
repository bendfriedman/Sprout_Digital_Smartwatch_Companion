import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


ScreenManager manager;


void setup() {
  size(312, 390); // Apple Watch Series 1 dimensions: 312 px * 390 px

  manager = new ScreenManager();
  manager.registerScreen("hub", new Screen_Hub());
  manager.switchTo("hub");
}

void draw() {
  background(BG);
  manager.render();
}

void mousePressed() {
  manager.handleTouch(mouseX, mouseY);
}
