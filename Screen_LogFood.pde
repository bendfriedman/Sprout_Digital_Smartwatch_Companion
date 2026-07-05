class Screen_LogFood extends Screen {

  PImage sprout, mic, waveform, leaf, cross;
  AudioPlayer sound;

  String[] dayLabels = {"Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"};
  Rect sproutBox, micBox, waveBox;

  Screen_LogFood() {
    sprout = loadImage("images/Sprout_content.jpg");
    mic = loadImage("images/mic.jpg");
    waveform = loadImage("images/waveform.jpg");
    leaf = loadImage("images/tiny_leaf.jpg");
    cross = loadImage("images/tiny_red_x.jpg");
    sound = minim.loadFile("sounds/04_log_meal.mp3");

    int pad = SCREEN_PADDING;
    sproutBox = new Rect(width/2 - 40, 128, 80, 85);
    micBox = new Rect(pad, 268, 68, 68);
    waveBox = new Rect(pad + 68 + 10, 268, width - (pad + 68 + 10) - pad, 68);

    int today = todayIndex();
    for (int i = 0; i < today; i++) { // nur Tage VOR heute
      meatWeek[i] = int(random(3)); // 0=leer, 1=fleischfrei, 2=Fleisch
    }
  }

  int todayIndex() {
    java.util.Calendar c = java.util.Calendar.getInstance();
    int dow = c.get(java.util.Calendar.DAY_OF_WEEK); // So=1..Sa=7
    return (dow + 5) % 7; // -> Mo=0..So=6
  }

  void logToday(int val) {
    int t = todayIndex();
    if (val == 1) { // fleischfrei
      if (meatWeek[t] != 1) veggieStreak++; // nur einmal pro Tag zählen
      meatWeek[t] = 1;
    } else { // Fleisch
      meatWeek[t] = 2;
      veggieStreak = 0;
    }
    sound.rewind();
    sound.play();
  }

  void onSpeech(String s) {
    if (s.contains("yes")) {
      logToday(1);
    } // nur vegetarisch
    else if (s.contains("no")) {
      logToday(2);
    } // fleiscg
  }

  void draw() {
    // Mo–So
    float cellW = (width - 2*SCREEN_PADDING) / 7.0;
    float rowY = 60;
    int today = todayIndex();
    textAlign(CENTER, CENTER);
    for (int i = 0; i < 7; i++) {
      float xc = SCREEN_PADDING + cellW * i + cellW/2;
      fill(i == today ? ACCENT : TEXT); // heutiger Tag markiert
      textSize(13);
      text(dayLabels[i], xc, rowY);

      imageMode(CENTER);
      float ms = cellW * 0.55;
      if (meatWeek[i] == 1) {
        image(leaf, xc, rowY + 24, ms, ms);
      } else if (meatWeek[i] == 2) {
        image(cross, xc, rowY + 24, ms, ms);
      }
      imageMode(CORNER);
    }

    drawFitted(sprout, sproutBox);
    fill(TEXT);
    textSize(22);
    text("Only vegetarian today?", width/2, 232);

    drawFitted(mic, micBox);
    drawFitted(waveform, waveBox);

    textSize(16);
    text("say \"yes\" or \"no\"", width/2, 352);

    drawBackButton();
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.goBack();
      return;
    }
  }

  void update() {
  }
  void onEnter() {
  }
}
