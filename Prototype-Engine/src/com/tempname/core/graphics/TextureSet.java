package com.tempname.core.graphics;

import processing.core.PImage;

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