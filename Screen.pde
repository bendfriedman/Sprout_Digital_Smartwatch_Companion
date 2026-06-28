abstract class Screen {
  abstract void draw();
  abstract void handleTouch(int x, int y);
  abstract void update();
  abstract void onEnter();
}
