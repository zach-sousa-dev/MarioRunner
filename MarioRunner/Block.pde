class Block {

PVector   pos;                 //current position
PImage[]  tileset;             //array of images
int       tileID;              //represents tile type, behaviors and looks (according to index of tileset)
boolean   isSolid  = true;     //can player stand on the floor??
double    scrlSpd  = 2.5;      //speed that the tile moves across the screen



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



/** 
*  getPos returns this object's position in a PVector
*
*  @return    position PVector
*
*  @version   1.00
*  @author    Zachary Sousa
*/
PVector getPos() {
  return pos;
}
//end getPos



/** 
*  update updates values such as position and should be run once every frame
*
*  @version     1.00
*  @author      Zachary Sousa
*/
void update() {
  pos.x -= scrlSpd;
}
//end update



/** 
*  show draws the block at the current position using the previously inputted PImage[] and using a given scale
*
*  @version    1.00
*  @author     Zachary Sousa
*/
void show(float imgScale) {
  image(tileset[tileID], pos.x, pos.y, imgScale, imgScale);
}
//end show

}
