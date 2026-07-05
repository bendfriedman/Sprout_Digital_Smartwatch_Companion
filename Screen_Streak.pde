class Screen_Streak extends Screen {

  PImage streak_screen;
  AudioPlayer streakSound;

  Screen_Streak() {
    streak_screen = loadImage("images/streak_screen.jpg");
    streakSound = minim.loadFile("sounds/08_view_streak.mp3");
  }

  void draw() {
    image(streak_screen, 0, 0, width, height);
    // Streak-Zahl auf Stern
    fill(TEXT);
    textAlign(CENTER, CENTER);
    textSize(30);
    text(veggieStreak, width * 0.23, height * 0.82);

    drawBackButton();
    drawPageDots(1, 2);
  };

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.switchTo("progress");
      return;
    }
  };

  void update() {
  };

  void onEnter() {
    streakSound.rewind();
    streakSound.play();
  };
}
