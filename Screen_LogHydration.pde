class Screen_LogHydration extends Screen {

  PImage drop;
  PImage[] presetImg = new PImage[3];
  int[]   presetVal  = {1000, 1500, 2000};
  AudioPlayer sound;

  Rect dropBox, minusBox, plusBox;
  Rect[] presetBox = new Rect[3];
  final int STEP = 250;

  Screen_LogHydration() {
    drop = loadImage("images/water_drop.jpg");
    presetImg[0] = loadImage("images/hydration_1000.jpg");
    presetImg[1] = loadImage("images/hydration_1500.jpg");
    presetImg[2] = loadImage("images/hydration_2000.jpg");
    sound = minim.loadFile("sounds/water-bubbles.mp3");

    int pad = SCREEN_PADDING;
    dropBox = new Rect(width/2 - 40, 105, 80, 95);

    int by = 295, bh = 48, gap = 6, sideW = 34;
    minusBox = new Rect(pad, by, sideW, bh);
    plusBox  = new Rect(width - pad - sideW, by, sideW, bh);

    float ps = pad + sideW + gap;
    float pe = width - pad - sideW - gap;
    float pw = (pe - ps - 2*gap) / 3;
    for (int i = 0; i < 3; i++) {
      presetBox[i] = new Rect(ps + i*(pw + gap), by, pw, bh);
    }
  }

  void draw() {
    fill(TEXT);
    textAlign(CENTER, TOP);
    textSize(16);
    text("How much did you drink today?", SCREEN_PADDING, 55, width - 2*SCREEN_PADDING, 40);

    // water drop + aktueller Wert
    drawFitted(drop, dropBox);
    textAlign(CENTER, CENTER);
    textSize(30);
    text(hydrationMl + " ml", width/2, 225);

    // Preset-Buttons (images)
    for (int i = 0; i < 3; i++) {
      drawFitted(presetImg[i], presetBox[i]);
    }

    // − / + Buttons
    drawSquareButton(minusBox, "-");
    drawSquareButton(plusBox, "+");

    drawBackButton();
  }

  void drawSquareButton(Rect b, String label) {
    noFill();
    stroke(ACCENT);
    strokeWeight(STROKE_WEIGHT);
    rect(b.x, b.y, b.w, b.h, 8);
    fill(TEXT);
    textAlign(CENTER, CENTER);
    textSize(24);
    text(label, b.x + b.w/2, b.y + b.h/2 - 2);
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.goBack();
      return;
    }

    if (hitRect(x, y, minusBox)) {
      hydrationMl = max(0, hydrationMl - STEP);
      play();
      return;
    }
    if (hitRect(x, y, plusBox)) {
      hydrationMl += STEP;
      play();
      return;
    }
    // handle Preset-Buttons
    for (int i = 0; i < 3; i++) {
      if (hitRect(x, y, presetBox[i])) {
        hydrationMl = presetVal[i];
        play();
        return;
      }
    }
  }

  void play() {
    sound.rewind();
    sound.play();
  }

  void update() {
  }
  void onEnter() {
  }
}
