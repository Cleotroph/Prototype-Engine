// mod:core

// Low level drawable, used to contain anything renderable, it is up to the user to de-duplicate resources
public interface Graphic {
  void render(Vec2 pos);
}

// A no-draw graphic used as the nullable type for sprites.
public class EmptyGraphic implements Graphic {
  void render(Vec2 pos){}
}


// Simple PImage container - can receive a texture from a set or as a source image
public class TextureGraphic implements Graphic {
  PImage source;
  TextureGraphic(PImage source){
    this.source = source;
  }
  TextureGraphic(TextureSet set, int index){
    this.source = set.getTex(index);  
  }
  void render(Vec2 pos){
    image(source, pos.x, pos.y);
  }
}

// A collection of textures
// Usually returned by a scanner/generator such as the deatlasing utility.
// Ordered by scan/generation order.
public class TextureSet {
  PImage[] source;
  TextureSet(int size){
    source = new PImage[size];  
  }
  PImage getTex(int index){
    return source[index];
  }
  Graphic[] getFrameSet(){
    Graphic[] out = new Graphic[source.length];
    for(int i = 0; i < source.length; i++){
      out[i] = new TextureGraphic(source[i]);
    }
    return out;
  }
  AnimationFrame[] getAnimFrameSet(int duration){
    AnimationFrame[] out = new AnimationFrame[source.length];
    for(int i = 0; i < source.length; i++){
      out[i] = new AnimationFrame(new TextureGraphic(source[i]), duration);  
    }
    return out;
  }
  AnimationFrame[] getAnimFrameSet(int[] durations){
    AnimationFrame[] out = new AnimationFrame[source.length];
    for(int i = 0; i < source.length; i++){
      out[i] = new AnimationFrame(new TextureGraphic(source[i]), durations[i]);  
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
