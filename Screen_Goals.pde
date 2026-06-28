class Screen_Goals extends Screen {
  AudioPlayer goalSound;

  PImage waveform;
  PImage mic;
  PImage stepsImg;

  Rect stepsBox, micBox, waveBox;

  Screen_Goals() {
    waveform = loadImage("images/waveform.jpg");
    mic = loadImage("images/mic.jpg");
    stepsImg = loadImage("images/steps.jpg");

    goalSound = minim.loadFile("sounds/01_set_step_goal.mp3");
    int padding = SCREEN_PADDING;
    stepsBox = new Rect(padding, 115, width - 2 * padding, 70);
    micBox   = new Rect(padding, 240, 90, 100);
    waveBox  = new Rect(padding + 90 + 12, 240, width - (padding + 90 + 12) - padding, 100);
  }

  void draw() {
    fill(TEXT);
    textAlign(CENTER, TOP);
    textSize(16);
    text("How many steps are you planning today?",
      SCREEN_PADDING, 50, width - 2*SCREEN_PADDING, 50);
    drawFitted(stepsImg, stepsBox);

    textAlign(CENTER, CENTER);
    textSize(22);
    text(stepGoal + " steps", width/2, 200);

    drawFitted(mic, micBox);
    drawFitted(waveform, waveBox);

    drawBackButton();
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.switchTo("hub");
      return;
    }
  }

  void update() {
  }
  void onEnter() {
  }

  void applyResult(int goal) {
    stepGoal = goal;
  }

  void onSpeech(String s) {
    if (s.contains("five")) {
      applyResult(5000);
    } else if (s.contains("six")) {
      applyResult(6000);
    } else if (s.contains("seven")) {
      applyResult(7000);
    } else if (s.contains("eight")) {
      applyResult(8000);
    } else if (s.contains("nine")) {
      applyResult(9000);
    } else if (s.contains("ten")) {
      applyResult(10000);
    } else if (s.contains("eleven")) {
      applyResult(11000);
    } else if (s.contains("twelve")) {
      applyResult(12000);
    } else if (s.contains("fifteen")) {
      applyResult(15000);
    } else if (s.contains("twenty")) {
      applyResult(20000);
    }
    goalSound.rewind();
    goalSound.play();
  }
}
