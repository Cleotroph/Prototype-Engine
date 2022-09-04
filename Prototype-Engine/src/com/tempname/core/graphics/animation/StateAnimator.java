package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

// More complicated Animator which requests a state to move between cycled animations
public abstract class StateAnimator extends AnimationController {
    int lastState = -1;
    abstract int getState();
    AnimationStateContainer[] providers;
    Graphic provideFrame(){
        int state = getState();
        if(state != lastState){
            providers[state].optionalRefresh();
        }
        lastState = state;
        return providers[state].provider.provideFrame();
    }
}