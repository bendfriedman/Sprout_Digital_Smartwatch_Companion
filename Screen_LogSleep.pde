class Screen_LogSleep extends Screen {

  final int SLEEPING = 0, AWAKE = 1;
  int state = SLEEPING;

  AudioPlayer sound;

  String sleepTime = "--:--";
  String wakeTime  = "--:--";
  float shakeEnergy = 0;
  final float SHAKE_THRESHOLD = 250;

  Rect sproutBox;
  Rect moonBox;

  PImage sprout_sleeping;
  PImage sprout_content;
  PImage moon;
  PImage sun;

  Screen_LogSleep() {
    sprout_sleeping = loadImage("images/Sprout_sleeping.jpg");
    sprout_content  = loadImage("images/Sprout_content.jpg");
    moon = loadImage("images/moon.jpg");
    sun = loadImage("images/sun.jpg");
    sound = minim.loadFile("sounds/07_log_sleep.mp3");
    int mondGroesse = 40;
    moonBox = new Rect(width - SCREEN_PADDING - mondGroesse, SCREEN_PADDING, mondGroesse, mondGroesse);

    sproutBox = new Rect(width/2 - 55, 120, 110, 120);
  }

  void onEnter() {
    state = SLEEPING;
    sleepTime = now();
    wakeTime  = "--:--";
    shakeEnergy = 0;
  }

  String now() {
    return nf(hour(), 2) + ":" + nf(minute(), 2);   // aktuelle Uhrzeit HH:MM
  }

  void update() {
    if (state == SLEEPING) {
      // Mausbewegung = Uhr schütteln
      shakeEnergy += abs(mouseX - pmouseX) + abs(mouseY - pmouseY); //pmouseX/Y = vorherige Mausposition vom letzten Frame
      shakeEnergy *= 0.85; // klingt ab
      if (shakeEnergy > SHAKE_THRESHOLD) {
        wake();
      };
    }
  }

  void wake() {
    state = AWAKE;
    wakeTime = now();
    sound.rewind();
    sound.play();
  }

  void draw() {
    fill(TEXT);
    textAlign(CENTER, TOP);
    textSize(26);
    text("Log Sleep", width/2, 50);

    // show Mond or sun
    drawFitted(state == SLEEPING ? moon : sun, moonBox);

    drawFitted(state == SLEEPING ? sprout_sleeping : sprout_content, sproutBox);

    textAlign(CENTER, CENTER);
    if (state == SLEEPING) {
      textSize(20);
      text("shake to wake up", width/2, 258);
    } else {
      textSize(20);
      text("Good morning!", width/2, 258);
    }

    textSize(26);
    text("Sleep " + sleepTime + "  \u2192 Wake  " + wakeTime, width/2, 300);

    drawBackButton();
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.goBack();
      return;
    }
  }
}
