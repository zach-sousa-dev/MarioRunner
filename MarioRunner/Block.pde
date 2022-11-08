class Block {

PVector   pos;                 //current position
PImage    tile;                //tile to draw
boolean   isSolid  = true;     //can player stand on the floor??
double    scrlSpd  = 2.5;      //speed that the tile moves across the screen
boolean   alive    = true;     //store whether the block is alive

ArrayList<Block> arLi;         //ArrayList that this block is in


//BLOCK CONSTRUCTORS
public Block(PVector pos, PImage tile, ArrayList<Block> arLi) {
  this.pos     = pos;
  this.tile    = tile;
  this.arLi    = arLi;
}

void Block(PVector pos, PImage tile, boolean isSolid, ArrayList<Block> arLi) {
  this.pos     = pos;
  this.tile    = tile;
  this.arLi    = arLi;
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
*  update updates values such as position and should be run once every frame, and removes when off the screen, AND also says whether the block is alive
*
*  @version     1.00
*  @author      Zachary Sousa
*/
boolean update(float scrlSpd, float imgScale) {
  this.scrlSpd = scrlSpd;
  pos.x -= scrlSpd;
  
  if(pos.x < (0 - imgScale/2)) {
    for(int i = 0; i < arLi.size(); i++) {
      if(arLi.get(i).getPos().x == pos.x) {
        arLi.remove(i);
        alive = false;
      }
    }
  } else {
   alive = true; 
  }
  
  return alive;
}
//end update



/** 
*  show draws the block at the current position using the previously inputted PImage[] and using a given scale
*
*  @version    1.00
*  @author     Zachary Sousa
*/
void show(float imgScale) {
  image(tile, pos.x, pos.y, imgScale, imgScale);
}
//end show

}
