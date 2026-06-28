class Screen_Sprout extends Screen {

  AudioPlayer waterSound;
  AudioPlayer nextHappinesLevelSound;

  PImage sprout_sad;
  PImage sprout_content;
  PImage sprout_happy;
  PImage sprout;
  PImage wateringCan;

  final int padding = SCREEN_PADDING;
  Rect sproutBox, canBox;

  boolean watering = false;
  int waterCount = 0;
  final int waterCountToBeHappy = 2;
  int waterStart = -1;
  final int WATER_MS = 1500;
  int numDrops = 15;
  float[] dropX = new float[numDrops];
  float[] dropY = new float[numDrops];

  Screen_Sprout() {
    sprout_sad = loadImage("images/Sprout_sad.jpg");
    sprout_content = loadImage("images/Sprout_content.jpg");
    sprout_happy = loadImage("images/Sprout_happy.jpg");
    sprout = sprout_sad;
    wateringCan  = loadImage("images/WateringCan.png");

    int splitY = int(height * 0.65); // trennlinie Sprout / Kanne
    sproutBox = new Rect(padding, padding, width - 2 * padding, splitY - padding);
    canBox = new Rect(padding, splitY, width - 2 * padding, height - splitY - padding);

    waterSound = minim.loadFile("sounds/water-bubbles.mp3");
    nextHappinesLevelSound = minim.loadFile("sounds/09_view_prgress_history.mp3");
  }

  void startWatering() {
    watering = true;
    waterStart = millis();
    for (int i = 0; i < numDrops; i++) {
      dropX[i] = random(width * 0.3, width * 0.7);
      dropY[i] = random(-40, 0);
    }
    waterSound.rewind();
    waterSound.play();
  }

  void draw() {
    drawFitted(sprout, sproutBox);
    drawFitted(wateringCan, canBox);
    drawBackButton();

    if (watering) {
      stroke(#3AA0FF);
      strokeWeight(3);
      for (int i = 0; i < numDrops; i++) {
        dropY[i] += 4;
        line(dropX[i], dropY[i], dropX[i], dropY[i] + 8);
        if (dropY[i] > height * 0.6) {
          dropY[i] = random(-40, 0); // oben außerhalb neu starten
        }
      }
    }
  }

  void handleTouch(int x, int y) {
    if (backPressed(x, y)) {
      manager.switchTo("hub");
      return;
    }
    // tapped wateringCan
    if (hitRect(x, y, canBox)) {
      if (!watering) {
        startWatering();
      }
    }
  }

  void update() {
    if (watering && millis() - waterStart > WATER_MS) {
      watering = false;
      waterCount++;
      if (waterCount == 1) {
        sprout = sprout_content;
      } else if (waterCount == 2) {
        sprout = sprout_happy;
      }
      nextHappinesLevelSound.rewind();
      nextHappinesLevelSound.play();
    }
  }

  void onEnter() {
    // Screen zurücksetzen
    watering = false;
    sprout = sprout_sad;
    waterCount = 0;
  }
}
