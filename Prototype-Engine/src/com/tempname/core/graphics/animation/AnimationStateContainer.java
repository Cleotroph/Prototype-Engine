package com.tempname.core.graphics.animation;

// Container for state animator providers.
// refreshOnAccess specifies whether or not to refresh the animation when it's drawn after not being draw previously.
// can also contain a static animator
class AnimationStateContainer {
    boolean refreshOnAccess;
    AnimationController provider;
    AnimationStateContainer(AnimationController provider, boolean refreshOnAccess){
        this.provider = provider;
        this.refreshOnAccess = refreshOnAccess;
    }
    void optionalRefresh(){
        if(refreshOnAccess){
            provider.refresh();
        }
    }
}
