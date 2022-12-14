import processing.sound.*;


//GAME RULES
String state         = "title";                           //controls the game state (title, playing, game over)
int delay            = 360;                               //delay between a game over and restart
int delayLeft        = delay;                             //delay time remaining
int paused           = -1;



//POSITON/PHYSICS
/*PVector mPos           = new PVector(0, 0);        //default position
boolean grounded       = false;                    //true if mario is on ground, otherwise false

float mVel             = 0;                        //default y velocity*/
float g                = 0.5;                      //CONSTANT force of gravity

float scrollSpeed      = 2.5;                      //speed of screen scrolling
float scrollSpeedInc   = 0.5;                      //how much the scroll speed should increase

float units            = 0;                        //distance mario has run
float meters           = 0;                        //amount of blocks mario has run past



//DISPLAY VARIABLES
int imgScale                 = 50;                       //CONSTANT sprite scale value
PFont font;                                              //font to be used for UI elements
int fade                     = 0;                        //controls the opacity of the fading screen on a game over
ArrayList<PVector> circles   = new ArrayList<PVector>(); //holds the position and size for each circle in the cursor trail
  


//MARIO ANIMATIONS
PImage[] mFrames     = new PImage[5];    //all sprites are scaled 10x original image (ex. 16x16 ==> 160x160
                                         //inside image processor, not including value of imgScale)
                                         
/*int mCurFrame;                           //stores current Mario animation frame
int rFrameTime       = 3;                //amount frames for each frame of running animation
int rFrameTimeLeft   = rFrameTime;       //how many more frames does the current frame last
  //CONSTANT ANIMATION INDEXES
  int jumpFrame     = 3;*/



//TILES
PImage[] blocks              = new PImage[1];         //all blocks are scaled to 10 times that of the orginal sprite
  //CONSTANT GROUND INDEXES
  int groundBlock            = 0;
PImage[] decoPI              = new PImage[6];      



//OTHER IMAGES
PImage title;
PImage cursor;
PImage[] notes       = new PImage[2];
PVector mutePos      = new PVector(0 + imgScale * 2, 0 + imgScale * 2);
boolean muted        = false;




//GROUND GENERATION
ArrayList<Block> floor        = new ArrayList<Block>();      //defines a new ArrayList of Blocks which 
                                                             //we can add or remove from later
ArrayList<PVector> deco       = new ArrayList<PVector>();                                     
ArrayList<Integer> savedDeco  = new ArrayList<Integer>();    //used to save tile type
int tileCounter               = 0;
int decoFreq                  = 75;                          //percent chance of spawning a bush or hill at every given interval                                                        
                                                        
//SOUNDS
SoundFile jump;
SoundFile lose;
SoundFile pause;
SoundFile[] music = new SoundFile[6];
String[] tracks = new String[6];
int curTrack;
SoundFile coin;



//PLAYER
Mario mario = new Mario(new PVector(0, 0), g, imgScale);




void setup() {

  //size(800, 800);
  fullScreen();
  frameRate(60);
  noCursor();
  background(0);


  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  
  
  text("LOADING...", width/2, height/2);
  
  
  mario.mPos = new PVector(width/2, height/2 + 3 * imgScale);        //sets position to the middle of the screen


  //assign sounds
  jump    = new SoundFile(this, "Sounds/jump.wav");
  lose    = new SoundFile(this, "Sounds/lose.mp3");
  coin    = new SoundFile(this, "Sounds/coin.wav");
  pause   = new SoundFile(this, "Sounds/pause.wav");
  
  curTrack     = 0;
  music[0]     = new SoundFile(this, "Sounds/NSMBW Overworld Remix-Paul LeClair.mp3");
  tracks[0]    = "NSMBW Overworld Remix - Paul Leclair";
  
  music[1]     = new SoundFile(this, "Sounds/BoomBoom.mp3");
  tracks[1]    = "SM3DL Boom Boom Remix - Tater-Tot Tunes";
  
  music[2]     = new SoundFile(this, "Sounds/EggPlanet.mp3");
  tracks[2]    = "SMG Egg Planet Remix - Tater-Tot Tunes";
  
  music[3]     = new SoundFile(this, "Sounds/Raceway.mp3");
  tracks[3]    = "MK64 Raceway Remix - Tater-Tot Tunes";
  
  music[4]     = new SoundFile(this, "Sounds/Remix10.mp3");
  tracks[4]    = "SMR Remix10 Remix - Tater-Tot Tunes";
  
  music[5]     = new SoundFile(this, "Sounds/Slide.mp3");
  tracks[5]    = "SM64 Slide Remix - Tater-Tot Tunes";
  //end assign sounds
  

  
  music[0].loop(1, 0.5);    //loop menu music
  
  
  
  //get fonts
  font = createFont("Fonts/Pixel_NES.otf", 28);
  //end get fonts
  

  //get images
  mFrames[0]     = loadImage("MarioSprites/Walk/walk0.png");
  mFrames[1]     = loadImage("MarioSprites/Walk/walk1.png");
  mFrames[2]     = loadImage("MarioSprites/Walk/walk2.png");
  mFrames[3]     = loadImage("MarioSprites/Other/jump.png");
  mFrames[4]     = loadImage("MarioSprites/Other/die.png");
  
  blocks[0]      = loadImage("BlockSprites/ground1.png");
  
  decoPI[0]        = loadImage("BlockSprites/smallBush.png");
  decoPI[1]        = loadImage("BlockSprites/bigBush.png");
  decoPI[2]        = loadImage("BlockSprites/smallHill.png");
  decoPI[3]        = loadImage("BlockSprites/bigHill.png");
  decoPI[4]        = loadImage("BlockSprites/smallTree.png");
  decoPI[5]        = loadImage("BlockSprites/bigTree.png");
/*decoPI[6]        = loadImage("BlockSprites/dark/bench.png");
  decoPI[7]        = loadImage("BlockSprites/dark/car.png");
  decoPI[8]        = loadImage("BlockSprites/dark/sign1.png");
  decoPI[9]        = loadImage("BlockSprites/dark/sign2.png");
  Still not sure if I want to use these... they high-key ugly  */
  
  notes[0]         = loadImage("BlockSprites/note1.png");
  notes[1]         = loadImage("BlockSprites/note2.png");

  title            = loadImage("OtherSprites/title.png");
  cursor           = loadImage("OtherSprites/cursor.png");
  //end get images
  
  
  

  //rescale all tiles
  for (int i = 0; i < mFrames.length; i++) {

    mFrames[i].resize(imgScale, imgScale);
  }

  for (int i = 0; i < blocks.length; i++) {

    blocks[i].resize(imgScale, imgScale);
  }
  
  for (int i = 0; i < decoPI.length; i++) {

    decoPI[i].resize(imgScale * 5, 0);
  }
  //end rescale all tiles
 
  reset();              //fill floor arraylist
  
  textFont(font);
  
}



void mouseClicked() {
  
  if(mouseX < mutePos.x + imgScale/2 && mouseX > mutePos.x - imgScale/2 && mouseY < mutePos.y + imgScale/2 && mouseY > mutePos.y - imgScale/2 && state == "title") {
   
    if(muted == true) {
      muted = false;
      music[curTrack].loop(1, 0.5);
    } else {
      muted = true;
      music[curTrack].stop();
    }
   //if(!coin.isPlaying()) {
   coin.stop();
   coin.play();
   //}
  }
  
}

void keyReleased() {
 if(key == ' ' && state == "game") {
   paused = paused * -1;
   pause.stop();
   pause.play();
 }
}



void draw() {

  background(92, 148, 252);

  



  //VVV GRAVITY AND JUMPING VVV
  
  
  
  if(keyPressed && key == 'w' && mario.grounded) {                            //if w is pressed and touching ground
    mario.grounded = false;                                                   //leave ground
    mario.mVel = -15;                                                         //decrease velocity (jump)
    jump.play();
    if(state == "title") {
     music[curTrack].stop();                                            //stop menu music
     state = "game";                                                    //now playing
     curTrack = (int)Math.round(Math.random() * (tracks.length - 1));   //randomize music
     if(!muted) {
       music[curTrack].loop(1, 0.5);                                    //loop music
     }
    }
  }
  
  
  
  
  //END GRAVITY AND JUMPING
  
  
  
  
  
  //SCROLLING
  
  if(state == "game") {
    units += scrollSpeed;                                                            //record total scroll distance since start
    meters = units / imgScale;                                                       //count meters
    scrollSpeed = 2.5 + ((int) meters / 10) * scrollSpeedInc;                        //increase scroll speed every 10 meters
  }
  else if(state == "title") {
    scrollSpeed = 2.5;
  }
  else {
   scrollSpeed = 0; 
  }
  
  
  
  
  if(state != "die" && paused == -1) {      //scroll updates
    for(int i = 0; i < floor.size(); i++) {                                                     //runs until tile passes right side 
    
      if(floor.get(i).update(scrollSpeed, imgScale, floor) == false) {                                 //move tile, and check if tile is off screen left
        i--;
        floor.add(new Block(new PVector(floor.get(floor.size() - 1).getPos().x + imgScale, height / 2 + 4 * imgScale), 
                            blocks[0] 
                            ));                                                            //add new position on right
        tileCounter ++;
        
        if(tileCounter == 7) {
         
          if(int(random(0, 100)) < decoFreq) {
            
            deco.add(new PVector(floor.get((floor.size() - 1)).getPos().x + imgScale * 3, height / 2 + 3 * imgScale));
            savedDeco.add(int(random(0, decoPI.length)));
            tileCounter = 0;
            
          } else {
            tileCounter = 0;
          } 
        } 
      }
    }// end scroll updates
    
    
    
    for(int i = 0; i < deco.size(); i++) {                                        //tile pass and remove stuff again but for background elements
      
      deco.get(i).x = deco.get(i).x - scrollSpeed;
      
      if(deco.get(i).x < -imgScale*2.5) {                                         //if tile is off screen left
       
        deco.remove(i);                                                           //remove from ArrayList
    
        savedDeco.remove(i);
        
        i--;                                                                      //here we have to go back one index since the indexes will all shift downward
                                                                                  //by 1 every time an object is removed
      }
    }
  }
  
  //END SCROLLING
  

  


  //DRAWING

  //draw background
  for(int i = 0; i < deco.size(); i++) {                            //runs once for every item in the ArrayList

    image(decoPI[savedDeco.get(i)], deco.get(i).x, deco.get(i).y);  //draws ground

  }
  
  //draw & update mario
  mario.update(floor, state);

  //black backdrop
  rectMode(CORNER);
  fill(0);
  rect(0, height/2 + 3.5 *imgScale, width, height);

  //draw ground
  for(int i = 0; i < floor.size(); i++) {                        //runs once for every item in the ArrayList

    floor.get(i).show(imgScale);                                 //draws ground

  }



  //ui
  fill(255, 255, 255);
  //current track
  if(muted == true){
      text("Muted", width/2, height/2 + imgScale * 8);
    } else {
      text("Now Playing:\n" + tracks[curTrack], width/2, height/2 + imgScale * 8);
    }

  //title
  if(state == "title") {
    
    //show title
    image(title, width/2, height/2 - imgScale * 4);
    
    //start button
    text("W to Jump", width/2, height/2 + imgScale);
    
    //press escape
    text("ESC to QUIT", width/2, height/2 - imgScale * 9);
    
    //mute button
    if(muted == true){
      image(notes[1], mutePos.x, mutePos.y, imgScale, imgScale);
    } else {
      image(notes[0], mutePos.x, mutePos.y, imgScale, imgScale);
    }
    
  } else if (state == "game"){
    //show meters
    text(Math.round(meters) + "M", width/2, mario.mPos.y - imgScale * 2);
  }
  
  
  
  //END DRAWING
  
  
  
  
  
  //DIE 
  
  if(meters > 150 && state != "die") {
   state              = "die"; 
   
   music[curTrack].stop();
   lose.play(); 
   mario.mCurFrame    = 4;           //die animation
   mario.grounded     = false;
   mario.mVel         = -15;         //bounce up
   fade         = 0;
   
   delayLeft = delay;          //reset delay time between game over and reset
  }
  
  
  if(state == "die") {
    
    rectMode(CENTER);
    fill(0, 0, 0, fade);                      //draw rect with fade opacity
    rect(width/2, height/2, width, height);   //fill screen with rect
    
    if(fade < 255) {
      fade++;                                 //increase opacity
    } else {
     
      fill(255);
      //game over text
      text("GAME OVER\n You Ran " + Math.round(meters) + " METERS", width/2, height/2);
      delayLeft--;
      
      if(delayLeft <= 0) {
        reset();
      }
    }
  }//END DIE
  
  
  //draw cursor
  cursor(mouseX + imgScale/2, mouseY + imgScale/2, imgScale, circles);
}
 
 
 
 
/** 
*  cursor draws a cursor at the mouse position and creates a simple trail behind it
*
*  @version     1.00
*  @author      Zachary Sousa
*/
void cursor(float x, float y, float siz, ArrayList<PVector> trail) {

 PVector cur = new PVector(x, y, siz/3);
 
 trail.add(cur);
 
 for(int i = 0; i < trail.size(); i++) {
  
   fill(255);
   noStroke();
   ellipse(trail.get(i).x, trail.get(i).y, trail.get(i).z, trail.get(i).z);
   trail.get(i).z --;
   
   if(trail.get(i).z <= 0){
     trail.remove(i);
   }
   
 }
 
 image(cursor, x, y, siz, siz); 
 
}
  
  
  
  
/** 
*  reset resets all of the gameplay variables and states
*
*  @version     1.00
*  @author      Zachary Sousa
*/
void reset() {
  
   state           = "title";
   
   mario.mPos      = new PVector(width/2, height/2 + 3 * imgScale);
   mario.mVel      = 0;
   
   scrollSpeed     = 2.5;
   units           = 0;
   meters          = 0;
  
   curTrack        = 0;
   if(!muted){
     music[curTrack].loop(1, 0.5);
   }
   
   floor.clear();
   deco.clear();
   tileCounter = 0;
  
  for(int i = 0; (i * imgScale) < width + imgScale * 2; i = i + 1) {                                                        //run until a block can reach too far off screen
                                                                                                                            //Thanks Mr. Rowbottom for helping debug this segment
    floor.add(new Block(new PVector((i * imgScale) + imgScale/2, height / 2 + 4 * imgScale), blocks[0]));            //add new block             
    if(i % 7 == 0 && int(random(0, 99)) < decoFreq) {
     
       deco.add(new PVector((i * imgScale) + imgScale / 2, height / 2 + 3 * imgScale));                   
       savedDeco.add(int(random(0, decoPI.length)));
    }
   
  }//end floor
   
}// end reset
