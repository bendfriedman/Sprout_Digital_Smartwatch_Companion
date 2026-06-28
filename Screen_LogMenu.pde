class Screen_LogMenu extends Screen {

  PImage[] icons = new PImage[4];
  String[] targetScreens = {"logExercise", "logFood", "logSleep", "logHydration"};

  final int cols = 2, rows = 2;
  final int tileMargin = SCREEN_PADDING;
  final int gap = 5;

  float tileW, tileH;
  Rect[] tiles = new Rect[4];

  Screen_LogMenu() {
    icons[0] = loadImage("images/Log_exercise.jpg");
    icons[1] = loadImage("images/Log_food.jpg");
    icons[2] = loadImage("images/Log_sleep.jpg");
    icons[3] = loadImage("images/Log_hydration.jpg");

    tileW = (width  - 2 * tileMargin - gap) / (float)cols;
    tileH = (height - 2 * tileMargin - gap) / (float)rows;

    for (int i = 0; i < 4; i++) {
      float tx = tileMargin + (i % 2) * (tileW + gap);
      float ty = tileMargin + (i / 2) * (tileH + gap);
      tiles[i] = new Rect(tx, ty, tileW, tileH);
    }
  }

  void draw() {
    for (int i = 0; i < 4; i++) {
      drawFitted(icons[i], tiles[i]);
    }
    drawBackButton();
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.switchTo("hub");
      return;
    }
    for (int i = 0; i < 4; i++) {
      if (hitRect(x, y, tiles[i])) {
        manager.switchTo(targetScreens[i]);
        return;
      }
    }
  }

  void update() {
  }
  void onEnter() {
  }
}
