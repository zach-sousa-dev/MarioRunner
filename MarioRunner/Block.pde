class Block {

PVector   pos;                 //current position
PImage[]  tileset;             //array of images
int       tileID;              //represents tile type, behaviors and looks (according to index of tileset)
boolean   isSolid  = true;     //can player stand on the floor??
double    scrlSpd  = 2.5;



//BLOCK CONSTRUCTORS
public Block(PVector pos, PImage[] tileset, int tileID) {
  this.pos     = pos;
  this.tileset = tileset;
  this.tileID  = tileID;
}

public Block(PVector pos, PImage[] tileset, int tileID, double scrlSpd) {
  this.pos     = pos;
  this.tileset = tileset;
  this.tileID  = tileID;
  this.scrlSpd = scrlSpd;
}

void Block(PVector pos, PImage[] tileset, int tileID, boolean isSolid) {
  this.pos     = pos;
  this.tileset = tileset;
  this.tileID  = tileID;
  this.isSolid = isSolid;
}

void Block(PVector pos, PImage[] tileset, int tileID, double scrlSpd, boolean isSolid) {
  this.pos     = pos;
  this.tileset = tileset;
  this.tileID  = tileID;
  this.scrlSpd = scrlSpd;
  this.isSolid = isSolid;
}
//END BLOCK CONSTRUCTORS



//getPos returns the PVector of this position
PVector getPos() {
  return pos;
}
//end getPos



//update should be run inside the main game's draw() function
void update() {
  this.pos.x -= scrlSpd;
}
//end update



//show draws the image
void show(float imgScale) {
  image(tileset[tileID], pos.x, pos.y, imgScale, imgScale);
}
//end show

}
