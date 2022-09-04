package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

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
        if(frames[frame].duration < (provideFrame().millis() - lastMS)){
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
        lastMS = provideFrame().millis();
    }
}