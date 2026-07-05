import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import simpleSpeech.*;


ScreenManager manager;
Minim minim;
Listen listener;

int pressX, pressY;
int stepGoal = 10000;

// progress current values + goals for the status bars
int hydrationMl = 1500;
int hydrationGoalMl = 3000;

int exerciseMin = 5;
int exerciseGoalMin = 30;

float sleepHours = 7.2;
float sleepGoalHours = 8.0;

int[] meatWeek = new int[7]; // 0=leer, 1=fleischfrei, 2=Fleisch
int veggieStreak = 0; // in days

void setup() {
  size(312, 390); // Apple Watch Series 1 dimensions: 312px * 390 px
  minim = new Minim(this);
  listener = new Listen(this, "\\sample.config.xml");

  manager = new ScreenManager();
  manager.registerScreen("hub", new Screen_Hub());
  manager.registerScreen("sprout", new Screen_Sprout());
  manager.registerScreen("goals", new Screen_Goals());
  manager.registerScreen("logMenu", new Screen_LogMenu());
  manager.registerScreen("progress", new Screen_Progress());
  manager.registerScreen("streak", new Screen_Streak());
  manager.registerScreen("logHydration", new Screen_LogHydration());
  manager.registerScreen("logSleep", new Screen_LogSleep());
  manager.registerScreen("logExercise", new Screen_LogExercise());
  manager.registerScreen("logFood", new Screen_LogFood());
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

  if (diffX > (width / 2) && abs(diffX) > abs(diffY) ) { // Swipe right
    manager.onSwipeRight();
    return;
  }
  if (diffX < -(width / 2) && abs(diffX) > abs(diffY)) {  // Swipe left
    manager.currentScreen.onSwipeLeft();
    return;
  }
  if (abs(diffX) < 12 && abs(diffY) < 12) { // tap
    manager.handleTouch(mouseX, mouseY);
  }
}

void listenEvent(Listen l) {
  String s = l.readString();
  if (s == null) return;
  if (manager.currentName.equals("goals") || manager.currentName.equals("logFood")) {
    println("heard: " + s);
    manager.currentScreen.onSpeech(s);
  }
}
