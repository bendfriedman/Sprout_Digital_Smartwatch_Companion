class ScreenManager {
  HashMap<String, Screen> screens = new HashMap<>();
  Screen currentScreen;
  String currentName = "";

  void registerScreen(String name, Screen s) {
    screens.put(name, s);
  }

  void switchTo(String name) {
    Screen next = screens.get(name);
    if (next != null) {
      currentScreen = next;
      currentName = name;
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

  void goBack() {
    if (currentName.equals("streak")) {
      switchTo("progress");
    } else if (currentName.equals("logHydration") || currentName.equals("logSleep")
      || currentName.equals("logExercise")  || currentName.equals("logFood")) {
      switchTo("logMenu");
    } else if (!currentName.equals("hub")) {
      switchTo("hub");
    }
  }

  void onSwipeRight() {
    goBack();
  }
}
