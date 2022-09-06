package com.tempname.core.graphics;

import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;

import java.util.HashMap;

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
    public void move(int x, int y){
        this.x = x;
        this.y = y;
    }
    void renderGraphic(){
        if(enabled){
            render();
        }
    }
    public abstract void render();
}




