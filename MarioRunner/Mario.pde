class Mario {
  //ANIMATION
  PImage[] frames        = new PImage[1];
  int mCurFrame;                             //stores current Mario animation frame
  int rFrameTime         = 3;                //amount frames for each frame of running animation
  int rFrameTimeLeft     = rFrameTime;       //how many more frames does the current frame last
  int siz                = 0;
    //CONSTANT ANIMATION INDEXES
    int jumpFrame        = 3;
    int dieFrame         = 4;
    
  //POSITON/PHYSICS
  PVector mPos           = new PVector(0, 0);        //default position
  float jumpVel          = 15;                       //starting jump velocity
  float mVel             = 0;                        //default y velocity
  float g                = 0.5;                      //CONSTANT force of gravity
  boolean grounded       = false;                    //are we touching the ground
  
  //STORAGE
  ArrayList<Block> stoodOn = new ArrayList<Block>();   //holds the current blocks that are being stood on (should be only a max of 2 I think)
  
  
  
  
  public Mario(PVector mPos, float g, int siz) {
    this.mPos      = mPos;
    this.g         = g;
    this.siz       = siz;
  }
  
  
  
  void update(ArrayList<Block> blockList, String state) {
      mVel   += g;                 //mario's velocity increasing by gravity
      mPos.y += mVel;              //mario's y is increased (or decreased) by his velocity
      
      stoodOn.clear();            //reset this arLi every frame, otherwise we might be standing on air or something dumb
      grounded = groundCheck(blockList, state);
      if(grounded) {
        mVel = 0;                  //mario's velocity is set to 0 because he is not falling
        mPos.y = height/2 + (siz * 3);
      }
      
      animate(state);                   //choose animation frames
      show();
      
      /*if(grounded) {
       text("grounded", 100, 100);
      } else {
       text("airborne", 100, 100); 
      }*/
  }
  
  
  
  boolean groundCheck(ArrayList<Block> blockList, String state) {
    if(state != "die") {
      for(Block b : blockList) {
        if(abs(b.pos.y - mPos.y) <= siz && abs(b.pos.x - mPos.x) <= siz && b.isSolid) {
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
  
  
  
  void jump() {
    grounded = false;                         //leave ground
    mVel = -jumpVel;                          //decrease velocity (jump)
    jump.play();
  }
  
  
  
  void animate(String state) {
    if(state != "die") {
      if(grounded) {
        if (mCurFrame >= jumpFrame) {
            mCurFrame = 0;
        }
        else if (rFrameTimeLeft == rFrameTime) {        //check if we are on a new animation "frame"
          if (mCurFrame == 2) {
            mCurFrame = 0;                              //reset loop so that we dont accidentally show jump frame
          } else {
            mCurFrame++;                                //otherwise advance to the next frame
          }
          rFrameTimeLeft --;                            //the animation has passed a frame, so reduce frames left by 1
        } else {
          if (rFrameTimeLeft == 0) {                    //if the remaining frame time has reached 0
            rFrameTimeLeft = rFrameTime;                //reset counter
          } else {
            rFrameTimeLeft --;                          //otherwise, animation passes a frame
          }
        } 
      } else {
        mCurFrame = jumpFrame;                          //if not on the ground ----> jumpFrame
      }
    } else {
       mCurFrame = dieFrame; 
    }
  }
  
  
  
  void show() {
   image(mFrames[mCurFrame], mPos.x, mPos.y, siz, siz); 
  }
}
