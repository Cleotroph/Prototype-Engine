package com.tempname.core.graphics;

import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;
import java.util.HashMap;

import static processing.core.PConstants.ARGB;

// Static container for all de-atlasing utils
// No persistent variables, only a function container
AtlasLoader atlasLoader = new AtlasLoader();
public class AtlasLoader {
    public void splitAtlas(String name, HashMap<String, TextureSet> output){
        splitAtlas("data/textures", name, output);
    }

    public void splitAtlas(String path, String name, HashMap<String, TextureSet> output){
        PImage sourceAtlas = .loadImage(path + "/" + name + ".png");
        sourceAtlas.loadPixels();
        JSONObject rule = .loadJSONObject(path + "/" + name + ".json");
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
                        img = .createImage(w, h, ARGB);
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
                            img = .createImage(w, h, ARGB);
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
                                img = .createImage(w, h, ARGB);
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
