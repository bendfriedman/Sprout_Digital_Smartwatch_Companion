class Screen_LogExercise extends Screen {

  PImage sprout_moving, sprout_alert, sprout_content, twoTap;
  AudioPlayer startSound, alertSound;

  Rect sproutBox, twoTapBox;

  boolean running = false;
  int elapsed = 0;
  int lastStart = 0;
  boolean alerted = false;

  int lastTap = -1000;
  final int DOUBLE_MS = 350;
  final int PULSE_LIMIT = 120;


  Screen_LogExercise() {
    sprout_moving = loadImage("images/Sprout_moving.jpg");
    sprout_alert = loadImage("images/Sprout_alert.jpg");
    sprout_content = loadImage("images/Sprout_content.jpg");
    twoTap = loadImage("images/two_tap.jpg");
    startSound = minim.loadFile("sounds/05_log_workout.mp3");
    alertSound = minim.loadFile("sounds/10_live_vital_updates.mp3");

    sproutBox = new Rect(width/2 - 48, 60, 96, 95);
    twoTapBox = new Rect(SCREEN_PADDING, 278, width - 2*SCREEN_PADDING, 92);
  }

  void onEnter() {
    running = false;
    elapsed = 0;
    alerted = false;
  }

  // --- Zeit & Puls ---
  int totalMs() {
    return running ? elapsed + (millis() - lastStart) : elapsed;
  }

  int pulse() {
    final int PULSE_GROWTH = 2; // bpm pro Sekunde
    final int PULSE_REST = 95;

    if (!running) return PULSE_REST;
    int sec = (millis() - lastStart) / 1000; // zeit seit dem letzten Start (nicht total!!)
    return min(160, PULSE_REST + sec * PULSE_GROWTH);
  }

  void toggleTimer() {
    if (running) {
      elapsed += millis() - lastStart;
      running = false;
      alertSound.pause();
      alertSound.rewind();
    } else {
      lastStart = millis();
      running = true;
      startSound.rewind();
      startSound.play();
    }
  }

  void update() {
    boolean alarm = running && pulse() >= PULSE_LIMIT;
    if (alarm && !alertSound.isPlaying()) {
      alertSound.rewind();
      alertSound.play();
    }
  }

  void draw() {
    fill(TEXT);
    textAlign(CENTER, TOP);
    textSize(22);
    text("Log Workout", width/2, 26);

    PImage s = !running ? sprout_content : (pulse() >= PULSE_LIMIT ? sprout_alert : sprout_moving);
    drawFitted(s, sproutBox);

    int sec = totalMs() / 1000;
    textAlign(CENTER, CENTER);
    fill(TEXT);
    textSize(46);
    text(nf(sec/60, 2) + ":" + nf(sec%60, 2), width/2, 180); // nf macht aus Zahl -> String mit leading zeros

    // Alarm (nur während des Laufens)
    if (running) {
      textSize(16);
      if (pulse() >= PULSE_LIMIT) {
        fill(DANGER);
        text("Take a break!", width/2, 218);
        text("pulse: " + pulse() + " bpm", width/2, 238);
      } else {
        fill(TEXT);
        text("pulse: " + pulse() + " bpm", width/2, 228);
      }
    }

    fill(TEXT);
    textSize(19);
    text(running ? "double tap to pause" : "double tap to start", width/2, 260);
    drawFitted(twoTap, twoTapBox);

    drawBackButton();
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.goBack();
      return;
    }

    int t = millis();
    if (t - lastTap < DOUBLE_MS) { // zweiter Tap schnell genug -> Double-Tap
      toggleTimer();
      lastTap = -1000; // reset, damit ein dritter tap nicht sofort zählt
    } else {
      lastTap = t;
    }
  }
}
