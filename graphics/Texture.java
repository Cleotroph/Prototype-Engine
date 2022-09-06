package com.tempname.core.graphics;

import processing.core.PImage;

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
    public void render(){
        image(source, x, y);
    }
}