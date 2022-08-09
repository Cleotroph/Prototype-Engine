// mod:core

// Lowest level container for a positional object.
// Contains a single graphic (provider) which is drawn at the sprite's position
// Position is passed by pointer so positions can be shared/inherited.
class Sprite {
  Vec2 pos;
  AnimationController animator;
  
  Sprite(){
    setPositionProvider(new Vec2(0, 0));
    setAnimationSonctroller(new StaticAnimator(new EmptyGraphic()));
  }
  Sprite(Vec2 positionProvider){
    setPositionProvider(positionProvider);
    setAnimationSonctroller(new StaticAnimator(new EmptyGraphic()));
  }
  Sprite(Graphic g){
    setPositionProvider(new Vec2(0, 0));
    setAnimationSonctroller(new StaticAnimator(g));
  }
  Sprite(AnimationController animator){
    setPositionProvider(new Vec2(0, 0));
    setAnimationSonctroller(animator);
  }
  Sprite(Vec2 positionProvider, Graphic g){
    setPositionProvider(positionProvider);
    setAnimationSonctroller(new StaticAnimator(g));
  }
  Sprite(Vec2 positionProvider, AnimationController animator){
    setPositionProvider(positionProvider);
    setAnimationSonctroller(animator);
  }
  
  void setPositionProvider(Vec2 provider){
    this.pos = provider;
  }
  void setAnimationSonctroller(AnimationController animator){
    this.animator = animator;  
  }
  void setPosition(float x, float y){
    pos.x = x;
    pos.y = y;
  }
  void render(){
    animator.provideFrame().render(pos);  
  }
}
