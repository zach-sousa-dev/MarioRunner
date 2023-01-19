class Enemy {
  /* ENEMIES I WANNA ADD */
  /*
    REQUIRED FOR RELEASE
    *goomba
    *koopa
    OPTIONAL / ILL DO IT LATER
    *Piranha plant
  */

  String id;    //stores enemy type (allowed are; "goomba"), these are randomly selected via an array in the main program
  int lifetime = 0;  //how many frames has the enemy been alive
  PImage frame = gbaImgs[0];   //stores the current anmation frame
  
  int siz;
  
  double speed = 1;
  
  //POSITON/PHYSICS
  PVector pos;  //enemy position
  //float jumpVel          = 15;                       //starting jump velocity
  float vel              = 0;                        //default y velocity
  float g                = 0.5;                      //CONSTANT force of gravity
  boolean grounded       = false;                    //are we touching the ground
  boolean hit            = false;
  boolean deathAnim      = false;
  boolean isAlive        = true;
  int boost              = 20;
  //STORAGE
  ArrayList<Block> stoodOn = new ArrayList<Block>();   //holds the current blocks that are being stood on (should be only a max of 2 I think)
  
  //PLAYER
  Mario mario;
  
 
  
  public Enemy(PVector pos, String id, int siz, Mario mario) {
    this.id    = id;
    this.pos   = pos;
    this.siz   = siz;
    this.mario = mario;
  }
  
  
  //update should be called once every frame during gameplay
  void update(ArrayList<Block> blocks, String state, float scrollSpeed) {
    vel   += g;                //enemy's velocity increasing by gravity
    pos.y += vel;              //enemy's y is increased (or decreased) by his velocity
    pos.x -= scrollSpeed + speed;
    
    
    animate();
    show();
    stoodOn.clear();            //reset this arLi every frame, otherwise we might be standing on air or something dumb
    if(groundCheck(blocks, state)) {
      vel = 0;                  //enemy's velocity is set to 0 because he is not falling
      pos.y = height/2 + (siz * 3);
    }
    
    lifetime++;   //lifetime is increased at the end of each frame update
    
    if(abs(mario.mPos.x - pos.x) < siz && abs(mario.mPos.y - pos.y) < siz && !deathAnim) {
      println("hit");
      hit = true;
    } else if(abs(mario.mPos.x - pos.x) < siz && abs(mario.mPos.y - (pos.y - imgScale)) < siz/2) {
      deathAnim = true;
      mario.mVel -= boost;
    }
  }
  
  
  boolean groundCheck(ArrayList<Block> blockList, String state) {
    if(state != "die") {
      for(Block b : blockList) {
        if(abs(b.pos.y - pos.y) <= siz && abs(b.pos.x - pos.x) <= siz && b.isSolid) {
          stoodOn.add(b);
          //println(b.isSolid);
        }
      }
      if(stoodOn.size() > 0) {
        return true;
      }
    }
    return false;
  }
  
  
  void animate() {
   
    if(id == "goomba") {
      if(lifetime % 10 == 0) {
        if(frame == gbaImgs[0]) {
          frame = gbaImgs[1];
        } else {
          frame = gbaImgs[0]; 
        }
      }
    }
  }
  
  void show() {
    image(frame, pos.x, pos.y);
  }
}
