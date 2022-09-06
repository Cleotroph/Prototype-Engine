package com.tempname.core.graphics.animation;

import com.tempname.core.graphics.Graphic;

// Notes on using AnimationControllers -
// * It's recommended you only use the high level animators:
//   ~ CycleAnimator
//   ~ StateAnimator
// * These are designed on an observer model: The container requests a graphic,
//    the animation provider polls the current state (via time or a state observer method)
//    the animator changes it's provider if needed
// * Animation resetting is up to the user if it doesn't occur when a state changes.
//    this can be done via calling refresh() or flagRefresh() on the state animator

// Highest level animator, specifies a generic graphic provider
abstract class AnimationController {
    abstract Graphic provideFrame();
    abstract void refresh();
}