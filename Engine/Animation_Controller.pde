// Notes on using AnimationControllers -
// * It's recommended you only use the high level animators:
//   ~ CycleAnimator
//   ~ StateAnimator
// * These are designed on an observer model: The container requests a graphic,
//    the animation provider polls the current state (via time or a state observer method)
//    the animator changes it's provider if needed
// * Animation resetting is up to the user if it doesn't occur when a state changes.
//    this can be done via calling refresh() or flagRefresh() on the state animator

// This can be used to build animators
static class AnimationFactory{
   static AnimationController BuildFromJSON(){
      return null;
   }
}

// Highest level animator, specifies a generic graphic provider
abstract class AnimationController {
  abstract Graphic provideFrame();
  abstract void refresh();
}

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
      if(frames[frame].duration < (millis() - lastMS)){
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
    lastMS = millis();
  }
}

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

// Sprite serves as an animation container. This is very important as it
// dynamically updates the position of graphics
public class Sprite extends Graphic {
  AnimationController animator;
  Sprite(AnimationController animator){
    this.animator = animator;
  }
  void render(){
    Graphic frame = animator.provideFrame();
    frame.move(x, y);
    frame.render();
  }
}
