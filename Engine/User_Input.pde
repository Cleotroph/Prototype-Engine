ArrayList<MouseClickedListener> mouseClickedListeners;
ArrayList<MousePressedListener> mousePressedListeners;
ArrayList<MouseReleasedListener> mouseReleasedListeners;
ArrayList<KeyPressedListener> keyPressedListeners;
ArrayList<KeyReleasedListener> keyReleasedListeners;
ArrayList<MouseScrollListener> mouseScrollListeners;


void mouseClicked(){
  for(MouseClickedListener listener : mouseClickedListeners){
    listener.onMouseClicked();  
  }
}

void mousePressed(){
  for(MousePressedListener listener : mousePressedListeners){
    listener.onMousePressed();  
  }
}

void mouseReleased(){
  for(MouseReleasedListener listener : mouseReleasedListeners){
    listener.onMouseReleased();  
  }
}

void keyPressed(){
  for(KeyPressedListener listener : keyPressedListeners){
    listener.onKeyPressed();  
  }
}

void keyReleased(){
  for(KeyReleasedListener listener : keyReleasedListeners){
    listener.onKeyReleased();  
  }
}

void mouseWheel(MouseEvent event){
  for(MouseScrollListener listener : mouseScrollListeners){
    listener.onMouseScroll(event.getCount());  
  }
}



void registerListener(MouseClickedListener listener){
  mouseClickedListeners.add(listener);
}

void registerListener(MousePressedListener listener){
  mousePressedListeners.add(listener);
}

void registerListener(MouseReleasedListener listener){
  mouseReleasedListeners.add(listener);
}

void registerListener(KeyPressedListener listener){
  keyPressedListeners.add(listener);
}

void registerListener(KeyReleasedListener listener){
 keyReleasedListeners.add(listener);
}

void registerListener(MouseScrollListener listener){
  mouseScrollListeners.add(listener);  
}



void clearAllListeners(){
  clearMouseClickedListeners();
  clearMousePressedListeners();
  clearMouseReleasedListeners();
  clearKeyPressedListeners();
  clearKeyReleasedListeners();
  clearMouseScrollListeners();
}

void clearMouseClickedListeners(){
  mouseClickedListeners = new ArrayList<MouseClickedListener>();  
}

void clearMousePressedListeners(){
  mousePressedListeners = new ArrayList<MousePressedListener>();  
}

void clearMouseReleasedListeners(){
  mouseReleasedListeners = new ArrayList<MouseReleasedListener>();  
}

void clearKeyPressedListeners(){
  keyPressedListeners = new ArrayList<KeyPressedListener>();  
}

void clearKeyReleasedListeners(){
  keyReleasedListeners = new ArrayList<KeyReleasedListener>();  
}

void clearMouseScrollListeners(){
  mouseScrollListeners = new ArrayList<MouseScrollListener>();  
}



interface MouseClickedListener{
  void onMouseClicked();
}

interface MousePressedListener{
  void onMousePressed();
}

interface MouseReleasedListener{
  void onMouseReleased();
}

interface KeyPressedListener{
  void onKeyPressed();
}

interface KeyReleasedListener{
  void onKeyReleased();
}

interface MouseScrollListener{
  void onMouseScroll(int count);
}
