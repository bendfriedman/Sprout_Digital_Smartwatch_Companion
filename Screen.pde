abstract class Screen {
  abstract void draw();
  abstract void handleTouch(int x, int y);
  abstract void update();
  abstract void onEnter();


  void drawBackButton() {
    stroke(BACK_CLR);
    strokeWeight(STROKE_WEIGHT);
    line(BACK_BOX.x + BACK_BOX.w, BACK_BOX.y, BACK_BOX.x, BACK_BOX.y + BACK_BOX.h/2);
    line(BACK_BOX.x, BACK_BOX.y + BACK_BOX.h/2, BACK_BOX.x + BACK_BOX.w, BACK_BOX.y + BACK_BOX.h);
  }

  boolean backPressed(int x, int y) {
    return hitRect(x, y, BACK_BOX);
  }

  void onSwipeLeft() {
  }

  void drawPageDots(int active, int total) {
    float radius = 5;
    float spacing = 18;
    float y = height - SCREEN_PADDING;
    float startX = width/2 - (total - 1) * spacing / 2; // horizontal zentriert

    stroke(BACK_CLR);
    strokeWeight(2);
    for (int i = 0; i < total; i++) {
      if (i == active) {
        fill(BACK_CLR);
      } else {
        noFill();
      }
      ellipse(startX + i * spacing, y, radius * 2, radius * 2);
    }
  }
}
