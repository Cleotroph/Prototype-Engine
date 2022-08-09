HashMap<String, TextureSet> spells = new HashMap<String, TextureSet>();
Sprite spell;
PImage test;
void setup(){
  size(400,400,P2D);
  initLog();
  initDefaultLogger();
  atlasLoader.splitAtlas("data", "MinifolksUndead/MiniLichSpell", spells);
  CycleAnimator spellAnim = new CycleAnimator(spells.get("spell").getAnimFrameSet(250), true);
  spell = new Sprite(spellAnim);
  test = loadImage("data/MinifolksUndead/MiniLichSpell.png");
  
  noSmooth();
  ((PGraphicsOpenGL)g).textureSampling(3); // Enables noSmooth for images -- Doesn't work on text??? try not to scale vectors - set scale to 0 while drawing
  frameRate(1000);
  
  ActiveInputManager.registerListener(
    new MousePressedListener(){
      public void onMousePressed(){
        spell.animator.refresh();
      }
  });
}

void draw(){
  background(5);
  noSmooth();
  scale(5.0);
  text(frameRate, 0, 10);
  spell.render();
  //image(spells.get("nums").getTex(15), 50, 50);
  spell.setPosition(mouseX / 5 - 8, mouseY / 5 - 8);
  /*for(int i = 0; i < 10000; i++){
    image(test, 0, 0);
  }*/
  
}
