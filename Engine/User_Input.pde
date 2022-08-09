// mod:core

InputManager ActiveInputManager = new InputManager();


// Container for user-input event listeners
// yeah what he said
// 
public class InputManager {

  ArrayList<MouseClickedListener> mouseClickedListeners;
  ArrayList<MousePressedListener> mousePressedListeners;
  ArrayList<MouseReleasedListener> mouseReleasedListeners;
  ArrayList<KeyPressedListener> keyPressedListeners;
  ArrayList<KeyReleasedListener> keyReleasedListeners;
  ArrayList<MouseScrollListener> mouseScrollListeners;

  public InputManager() {
    this.clearAllListeners();
  }

  void registerListener(MouseClickedListener listener) {
    mouseClickedListeners.add(listener);
  }

  void registerListener(MousePressedListener listener) {
    mousePressedListeners.add(listener);
  }

  void registerListener(MouseReleasedListener listener) {
    mouseReleasedListeners.add(listener);
  }

  void registerListener(KeyPressedListener listener) {
    keyPressedListeners.add(listener);
  }

  void registerListener(KeyReleasedListener listener) {
    keyReleasedListeners.add(listener);
  }

  void registerListener(MouseScrollListener listener) {
    mouseScrollListeners.add(listener);
  }



  void clearAllListeners() {
    clearMouseClickedListeners();
    clearMousePressedListeners();
    clearMouseReleasedListeners();
    clearKeyPressedListeners();
    clearKeyReleasedListeners();
    clearMouseScrollListeners();
  }

  void clearMouseClickedListeners() {
    mouseClickedListeners = new ArrayList<MouseClickedListener>();
  }

  void clearMousePressedListeners() {
    mousePressedListeners = new ArrayList<MousePressedListener>();
  }

  void clearMouseReleasedListeners() {
    mouseReleasedListeners = new ArrayList<MouseReleasedListener>();
  }

  void clearKeyPressedListeners() {
    keyPressedListeners = new ArrayList<KeyPressedListener>();
  }

  void clearKeyReleasedListeners() {
    keyReleasedListeners = new ArrayList<KeyReleasedListener>();
  }

  void clearMouseScrollListeners() {
    mouseScrollListeners = new ArrayList<MouseScrollListener>();
  }
}




// built in processing methods
void mouseClicked() {
  for (MouseClickedListener listener : ActiveInputManager.mouseClickedListeners) {
    listener.onMouseClicked();
  }
}

void mousePressed() {
  for (MousePressedListener listener : ActiveInputManager.mousePressedListeners) {
    listener.onMousePressed();
  }
}

void mouseReleased() {
  for (MouseReleasedListener listener : ActiveInputManager.mouseReleasedListeners) {
    listener.onMouseReleased();
  }
}

void keyPressed() {
  for (KeyPressedListener listener : ActiveInputManager.keyPressedListeners) {
    listener.onKeyPressed();
  }
}

void keyReleased() {
  for (KeyReleasedListener listener : ActiveInputManager.keyReleasedListeners) {
    listener.onKeyReleased();
  }
}

void mouseWheel(MouseEvent event) {
  for (MouseScrollListener listener : ActiveInputManager.mouseScrollListeners) {
    listener.onMouseScroll(event.getCount());
  }
}

// interfaces
  interface MouseClickedListener {
    void onMouseClicked();
  }

  interface MousePressedListener {
    void onMousePressed();
  }

  abstract class mousedPressedListener {
    abstract void onmousePressed();
  }

  interface MouseReleasedListener {
    void onMouseReleased();
  }

  interface KeyPressedListener {
    void onKeyPressed();
  }

  interface KeyReleasedListener {
    void onKeyReleased();
  }

  interface MouseScrollListener {
    void onMouseScroll(int count);
  }
