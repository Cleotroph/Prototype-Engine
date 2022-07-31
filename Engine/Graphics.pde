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
