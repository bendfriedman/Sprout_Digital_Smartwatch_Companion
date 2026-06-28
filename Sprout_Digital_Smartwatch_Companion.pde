import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


ScreenManager manager;
Minim minim;

int pressX, pressY;

void setup() {
  size(312, 390); // Apple Watch Series 1 dimensions: 312 px * 390 px
  minim = new Minim(this);

  manager = new ScreenManager();
  manager.registerScreen("hub", new Screen_Hub());
  manager.registerScreen("sprout", new Screen_Sprout());
  manager.registerScreen("goals", new Screen_Goals());
  manager.registerScreen("log_menu", new Screen_LogMenu());
  manager.registerScreen("progress", new Screen_Progress());
  manager.registerScreen("streak", new Screen_Streak());
  manager.switchTo("hub");
}

void draw() {
  background(BG);
  manager.render();
}

void mousePressed() {
  pressX = mouseX;
  pressY = mouseY;
}

void mouseReleased() {
  int diffX = mouseX - pressX;
  int diffY = mouseY - pressY;

  if (diffX > (width / 2) && abs(diffX) > abs(diffY) ) { // swipe right
    manager.onSwipeRight();
    return;
  }
  if (diffX < -(width / 2) && abs(diffX) > abs(diffY)) {  // swipe left
    manager.currentScreen.onSwipeLeft();
    return;
  }
  if (abs(diffX) < 12 && abs(diffY) < 12) { // tap
    manager.handleTouch(mouseX, mouseY);
  }
}
