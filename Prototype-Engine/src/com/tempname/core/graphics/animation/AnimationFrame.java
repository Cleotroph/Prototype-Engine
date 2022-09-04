package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

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
