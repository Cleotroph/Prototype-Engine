// Notes on using AnimationControllers -
// * It's recommended you only use the high level animators:
//   ~ CycleAnimator
//   ~ StateAnimator
// * These are designed on an observer model: The container requests a graphic,
//    the animation provider polls the current state (via time or a state observer method)
//    the animator changes it's provider if needed
// * Animation resetting is up to the user if it doesn't occur when a state changes.
//    this can be done via calling refresh() or flagRefresh() on the state animator

// This can be used to build animators
static class AnimationFactory{
   static AnimationController BuildFromJSON(){
      return null;
   }
}

// Highest level animator, specifies a generic graphic provider
abstract class AnimationController {
  abstract Graphic provideFrame();
  abstract void refresh();
}

// This is a container for any static states in the AnimationStateContainer
// i.e. use this when one state is a static graphic instead of an animation
// Don't use this to draw static graphics otherwise, use a Graphic
class StaticAnimator extends AnimationController {
  Graphic content;
  Graphic provideFrame(){
    return content;  
  }
  void refresh(){}
}

// Simple animator which cycles through provided frames in given order with specified frame duration.
// If possible, these should be constructed during loading phases and recycled.
// looped boolean defines whether or not to repeat the animation on completion - The idle is the frame in the tail position
public class CycleAnimator extends AnimationController {
  boolean looped;
  int frame;
  int lastMS;
  AnimationFrame[] frames;
  CycleAnimator(AnimationFrame[] frames, boolean looped){
    this.frames = frames;
    this.looped = looped;
    refresh();
  }
  Graphic provideFrame(){
      if(frames[frame].duration < (millis() - lastMS)){
        if(looped || frame < frames.length - 1){
          lastMS+=frames[frame].duration;
          frame++;
          frame %= frames.length;
        }
      }
    return frames[frame].content;
  }
  void refresh(){
    frame = 0;
    lastMS = millis();
  }
}

// Container for animation frames
// Duration specifies lenght in MS for an animation frame
class AnimationFrame {
  Graphic content;
  int duration;
  AnimationFrame(Graphic content, int duration){
    this.content = content;
    this.duration = duration;
  }
}

// More complicated Animator which requests a state to move between cycled animations
public abstract class StateAnimator extends AnimationController {
  int lastState = -1;
  abstract int getState();
  AnimationStateContainer[] providers;
  Graphic provideFrame(){
    int state = getState();
    if(state != lastState){
      providers[state].optionalRefresh();
    }
    lastState = state;
    return providers[state].provider.provideFrame();
  }
}

// Container for state animator providers.
// refreshOnAccess specifies whether or not to refresh the animation when it's drawn after not being draw previously.
// can also contain a static animator
class AnimationStateContainer {
  boolean refreshOnAccess;
  AnimationController provider;
  AnimationStateContainer(AnimationController provider, boolean refreshOnAccess){
    this.provider = provider;
    this.refreshOnAccess = refreshOnAccess;
  }
  void optionalRefresh(){
    if(refreshOnAccess){
      provider.refresh();  
    }
  }
}

// Sprite serves as an animation container. This is very important as it
// dynamically updates the position of graphics
public class Sprite extends Graphic {
  AnimationController animator;
  Sprite(AnimationController animator){
    this.animator = animator;
  }
  void render(){
    Graphic frame = animator.provideFrame();
    frame.move(x, y);
    frame.render();
  }
}
public class Entity{
  int posX;
  int posY;
  boolean gravity;
  
}
// Highest level drawable
// anchored - specifies either UI locked or global offset driven.
// Layer specifies the level at which to draw. Defaults to 0 and drawn in a undefined order
// x and y can be modified directly, drawX and drawY should be accessed only during draw and not modified.
public abstract class Graphic {
  int drawX;
  int drawY;
  int x;
  int y;
  boolean anchored;
  int layer;
  boolean enabled;
  void disable(){
    enabled = false;  
  }
  void enable(){
    enabled = true;  
  }
  void move(int x, int y){
    this.x = x;
    this.y = y;
  }
  void renderGraphic(){
    if(enabled){
      render();  
    }
  }
  abstract void render();
}

// Simple PImage container - can receive a texture from a set or as a source image
public class Texture extends Graphic {
  PImage source;
  Texture(PImage source){
    this.source = source;
  }
  Texture(TextureSet set){
    this.source = set.getTex();  
  }
  Texture(TextureSet set, int index){
    this.source = set.getTex(index);  
  }
  void render(){
    image(source, x, y);
  }
}

public class TextureSet {
  PImage[] source;
  TextureSet(int size){
    source = new PImage[size];  
  }
  PImage getTex(){
    return source[0];
  }
  PImage getTex(int index){
    return source[index];
  }
  Graphic[] getFrameSet(){
    Graphic[] out = new Graphic[source.length];
    for(int i = 0; i < source.length; i++){
      out[i] = new Texture(source[i]);
    }
    return out;
  }
  AnimationFrame[] getAnimFrameSet(int duration){
    AnimationFrame[] out = new AnimationFrame[source.length];
    for(int i = 0; i < source.length; i++){
      out[i] = new AnimationFrame(new Texture(source[i]), duration);  
    }
    return out;
  }
}

// Static container for all de-atlasing utils
// No persistent variables, only a function container
AtlasLoader atlasLoader = new AtlasLoader();
class AtlasLoader {
  public void splitAtlas(String name, HashMap<String, TextureSet> output){
    splitAtlas("data/textures", name, output);
  }
  
  // Reads a JSON, list of sources with different modes:
  // - SOLO: single image at a set position
  // - LINE: horizontal row of images
  // - GRID: a nxm grid of images
  // Supports import of multiple sets under different names as long as the source atlas is merged into a single image file
  public void splitAtlas(String path, String name, HashMap<String, TextureSet> output){
    PImage sourceAtlas = loadImage(path + "/" + name + ".png");
    sourceAtlas.loadPixels();
    JSONObject rule = loadJSONObject(path + "/" + name + ".json");
    JSONArray sprites = rule.getJSONArray("resources");
    for (int i = 0; i < sprites.size(); i++) {
      JSONObject sprite = sprites.getJSONObject(i);
      String sname = sprite.getString("name");
      JSONArray sources = sprite.getJSONArray("sources");
      int srcListSize = 0;
      for(int j = 0; j < sources.size(); j++){
        JSONObject source = sources.getJSONObject(j);
        String type = source.getString("type");
        switch(type){
          case "SOLO":
            srcListSize++;
            break;
          case "LINE":
            srcListSize += source.getInt("count");
            break;
          case "GRID":
            srcListSize += source.getInt("row") * source.getInt("col");
            break;
        }
      }
      TextureSet set = new TextureSet(srcListSize);
      int setPos = 0;
      for(int j = 0; j < sources.size(); j++){
        JSONObject source = sources.getJSONObject(j);
        String type = source.getString("type");
        int x = source.getInt("x");
        int y = source.getInt("y");
        int w = source.getInt("height");
        int h = source.getInt("width");
        PImage img;
        switch(type){
          case "SOLO":
            img = createImage(w, h, ARGB);
            img.loadPixels();
            for (int xi = 0; xi < w; xi++) {
              for (int yi = 0; yi < h; yi++){
                img.pixels[xi + yi * w] = sourceAtlas.pixels[(x + xi) + (y + yi) * sourceAtlas.width];
              }
            }
            img.updatePixels();
            set.source[setPos] = img;
            setPos++;
            break;
          case "LINE":
            int count = source.getInt("count");
            for(int c = 0; c < count; c++){
              img = createImage(w, h, ARGB);
              img.loadPixels();
              for (int xi = 0; xi < w; xi++) {
                for (int yi = 0; yi < h; yi++){
                  img.pixels[xi + yi * w] = sourceAtlas.pixels[(x + xi + c * w) + (y + yi) * sourceAtlas.width];
                }
              }
              img.updatePixels();
              set.source[setPos] = img;
              setPos++;
            }
            break;
          case "GRID":
            int col = source.getInt("col");
            int row = source.getInt("row");
            for(int r = 0; r < row; r++){
              for(int c = 0; c < col; c++){
                img = createImage(w, h, ARGB);
                img.loadPixels();
                for (int xi = 0; xi < w; xi++) {
                  for (int yi = 0; yi < h; yi++){
                    img.pixels[xi + yi * w] = sourceAtlas.pixels[(x + xi + c * w) + (y + yi + r * h) * sourceAtlas.width];
                  }
                }
                img.updatePixels();
                set.source[setPos] = img;
                setPos++;
              }
            }
            break;
        }
      }
      output.put(sname, set);
    }
  }
}
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

/* LOGGING */
ArrayList<LogOutput> loggers;

// Interface for any log output you may choose to use; typically just a console out or file out.
interface LogOutput {
  void log(String identifier, LOGTYPE type, String s);  
}

// Initializes/resets the logging system.
void initLog(){
  loggers = new ArrayList<LogOutput>();
}

// Creates a stock java console logger and registers it.
void initDefaultLogger(){
  registerLogger(new LogOutput(){
    public void log(String identifier, LOGTYPE type, String s){
      println("[" + identifier + "/" + type + "]: " + s);  
    }
  });
}

void registerLogger(LogOutput out){
  loggers.add(out);
}

void log(String identifier, LOGTYPE type, String s){
  for(LogOutput out : loggers){
    out.log(identifier, type, s);  
  }
}

enum LOGTYPE{
  INFO {
      public String toString() {
          return "INFO";
      }
  },

  WARN {
      public String toString() {
          return "WARN";
      }
  },
  
  ERROR {
      public String toString() {
          return "ERROR";
      }
  }
}
