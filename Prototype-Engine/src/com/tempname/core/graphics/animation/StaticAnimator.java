package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

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