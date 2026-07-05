class Screen_Progress extends Screen {

  PImage steps_img;
  PImage exercise_icon;
  PImage hydration_icon;
  PImage sleep_icon;

  Rect forwardBox;
  Rect stepsBox;

  // status bar colors
  final color EX_FILL   = #FF9F0A;
  final color EX_BORDER = DANGER;
  final color HY_FILL   = #1E88E5;
  final color SL_FILL   = #7C1FE0;
  final color TRACK     = #9E9E9E;

  Screen_Progress() {
    steps_img      = loadImage("images/progress_steps.jpg");
    exercise_icon  = loadImage("images/exercise_progress_icon.jpg");
    hydration_icon = loadImage("images/hydration_progress_icon.jpg");
    sleep_icon     = loadImage("images/sleep_progress_icon.jpg");

    stepsBox = new Rect(6, 6, width - 12, 190);

    // BACK_BOX an den rechten Rand gespiegelt
    forwardBox = new Rect(width - SCREEN_PADDING - BACK_BOX.w, BACK_BOX.y, BACK_BOX.w, BACK_BOX.h);
  }

  void draw() {
    drawFitted(steps_img, stepsBox);

    // three status bars
    drawStatus(exercise_icon, "Exercise", (float) exerciseMin / exerciseGoalMin, EX_FILL, EX_BORDER, 208);
    drawStatus(hydration_icon, "Hydration", (float) hydrationMl / hydrationGoalMl, HY_FILL, TRACK, 266);
    drawStatus(sleep_icon, "Sleep", sleepHours / sleepGoalHours, SL_FILL, TRACK, 324);

    drawBackButton();
    drawForwardArrow();
    drawPageDots(0, 2);
  }

  // one row: icon | label above a rounded progress bar
  void drawStatus(PImage icon, String label, float frac, color fillClr, color borderClr, float rowY) {
    float pad = SCREEN_PADDING;
    float iconW = 30, iconH = 42;
    float gap = 8;

    drawFitted(icon, new Rect(pad, rowY, iconW, iconH));

    float barX = pad + iconW + gap;
    float barW = width - barX - pad;
    float barH = 20;
    float barY = rowY + iconH - barH; // bar sits at bottom of the row

    // label above the progressbar
    fill(TEXT);
    textAlign(LEFT, BOTTOM);
    textSize(16);
    text(label, barX, barY - 4);

    frac = constrain(frac, 0, 1);

    // border
    noFill();
    stroke(borderClr);
    strokeWeight(3);
    rect(barX, barY, barW, barH, barH/2);

    // fill -> inset so it sits inside the border
    if (frac > 0) {
      noStroke();
      fill(fillClr);
      float inner = barW - 4;
      rect(barX + 2, barY + 2, inner * frac, barH - 4, (barH - 4)/2);
    }
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
