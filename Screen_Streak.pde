class Screen_Streak extends Screen {

  PImage streak_screen;
  AudioPlayer streakSound;

  Screen_Streak() {
    streak_screen = loadImage("images/streak_screen.jpg");
    streakSound = minim.loadFile("sounds/08_view_streak.mp3");
  }

  void draw() {
    image(streak_screen, 0, 0, width, height);
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
