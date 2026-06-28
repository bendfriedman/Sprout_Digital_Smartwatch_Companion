class ScreenManager {
  HashMap<String, Screen> screens = new HashMap<>();
  Screen currentScreen;

  void registerScreen(String name, Screen s) {
    screens.put(name, s);
  }

  void switchTo(String name) {
    Screen next = screens.get(name);
    if (next != null) {
      currentScreen = next;
      currentScreen.onEnter();
    }
  }

  void render() {
    if (currentScreen != null) {
      currentScreen.update();
      currentScreen.draw();
    }
  }

  void handleTouch(int x, int y) {
    if (currentScreen != null) {
      currentScreen.handleTouch(x, y);
    }
  }
}
