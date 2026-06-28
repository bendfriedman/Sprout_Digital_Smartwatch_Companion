class Screen_Hub extends Screen {

  PImage[] icons = new PImage[4];
  String[] targetScreens = {"companion", "goals", "add", "stats"}; // ziel-screen je tile

  int cols = 2, rows = 2;
  int margin = 16;
  int gap = 5;
  float tileW, tileH;
  float[] tileX = new float[4];
  float[] tileY = new float[4];
  int iconPadding = 12;


  Screen_Hub() {
    icons[0] = loadImage("images/Sprout_head.jpg");
    icons[1] = loadImage("images/Target.jpg");
    icons[2] = loadImage("images/plus-sign.jpg");
    icons[3] = loadImage("images/arrow-up.jpg");

    tileW = (width  - 2*margin - gap) / (float)cols;
    tileH = (height - 2*margin - gap) / (float)rows;
  }

  void draw() {

    for (int i = 0; i < 4; i++) {
      tileX[i] = margin + (i % 2) * (tileW + gap);
      tileY[i] = margin + (int) (i / 2) * (tileH + gap);
      stroke(ACCENT);
      strokeWeight(STROKE_WEIGHT);
      rect(tileX[i], tileY[i], tileW, tileH, BORDER_RADIUS);

      // quadratisches icon in der tile zentriert
      float iconSize = min(tileW, tileH) - 2 * iconPadding;
      image(icons[i],
        tileX[i] + iconPadding,
        tileY[i] + (tileH - iconSize)/2,
        iconSize, iconSize);
    }
  };

  void handleTouch(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (x >= tileX[i] && x <= tileX[i] + tileW && y >= tileY[i] && y <= tileY[i] + tileH) {
        manager.switchTo(targetScreens[i]);
        return;
      }
    }
  };

  void update() {
  };

  void onEnter() {
  };
}
