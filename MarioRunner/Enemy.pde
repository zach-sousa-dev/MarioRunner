class Enemy {

  PVector pos;
  
  
  String id;
  
  int lifetime = 0;
  
  PImage frame = gbaImgs[0];
  
  
  public Enemy(PVector pos, String id) {
    this.id    = id;
    this.pos   = pos;
  }
  
  
  
  void update() {
    animate();
    show();
    
    
    lifetime++;   //lifetime is increased at the end of each frame update
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
    println(frame);
  }
}
