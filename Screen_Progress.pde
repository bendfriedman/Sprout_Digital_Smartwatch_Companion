class Screen_Progress extends Screen {

  PImage progress_screen;
  Rect forwardBox;

  Screen_Progress() {
    progress_screen = loadImage("images/progress_screen.jpg");
    // BACK_BOX an den rechten Rand gespiegelt
    forwardBox = new Rect(width - SCREEN_PADDING - BACK_BOX.w, BACK_BOX.y, BACK_BOX.w, BACK_BOX.h);
  }

  void draw() {
    image(progress_screen, 0, 0, width, height);
    drawBackButton();
    drawForwardArrow();
    drawPageDots(0, 2);
  }

  void drawForwardArrow() {
    stroke(BACK_CLR);
    strokeWeight(STROKE_WEIGHT);
    line(forwardBox.x, forwardBox.y,
      forwardBox.x + forwardBox.w, forwardBox.y + forwardBox.h/2);
    line(forwardBox.x + forwardBox.w, forwardBox.y + forwardBox.h/2,
      forwardBox.x, forwardBox.y + forwardBox.h);
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.goBack();
      return;
    }
    if (hitRect(x, y, forwardBox)) {
      manager.switchTo("streak");
      return;
    }
  }

  void onSwipeLeft() {
    manager.switchTo("streak");
  }

  void update() {
  }

  void onEnter() {
  }
}
