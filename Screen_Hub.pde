class Screen_Hub extends Screen {

  PImage[] icons = new PImage[4];
  String[] targetScreens = {"sprout", "goals", "log_menu", "progress"}; // ziel-screen je tile

  final int cols = 2, rows = 2;
  final int tileMargin = SCREEN_PADDING;
  final int gap = 5;
  final int iconPadding = 12;

  float tileW, tileH;
  float[] tileX = new float[4];
  float[] tileY = new float[4];
  Rect[] tiles = new Rect[4];

  Screen_Hub() {
    icons[0] = loadImage("images/Sprout_head.jpg");
    icons[1] = loadImage("images/Target.jpg");
    icons[2] = loadImage("images/plus-sign.jpg");
    icons[3] = loadImage("images/arrow-up.jpg");

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
      stroke(ACCENT);
      strokeWeight(STROKE_WEIGHT);
      rect(tiles[i].x, tiles[i].y, tiles[i].w, tiles[i].h, BORDER_RADIUS);

      // quadratisches icon zentriert in der tile
      float iconSize = min(tiles[i].w, tiles[i].h) - 2 * iconPadding;
      image(icons[i],
        tiles[i].x + iconPadding,
        tiles[i].y + (tiles[i].h - iconSize)/2,
        iconSize, iconSize);
    }
  };

  void handleTouch(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (hitRect(x, y, tiles[i])) {
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
