package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

// Sprite serves as an animation container. This is very important as it
// dynamically updates the position of graphics
public class Sprite extends Graphic {
    AnimationController animator;
    Sprite(AnimationController animator){
        this.animator = animator;
    }
    public void render(){
        Graphic frame = animator.provideFrame();
        //frame.move(x, y);
        frame.render();
    }
}
