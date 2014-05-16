class Particlevector{
  float x, y;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector Goal;
  float r;
  float angle;
   float topspeed;
  //float maxforce;    // Maximum steering force
  //float maxspeed;  
  
  Particlevector(float x, float y){
    acceleration =new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    location = new PVector((random(width)),(random(height)));
 
    r = 0.1;
    topspeed = 3;
    //maxspeed = 1.1;
    //maxforce = 0.03;
    
    //Goal = new PVector((random(width)),(random(height)));
   Goal = new PVector(x, y);

  }
  
  void Update(){
    location.add(velocity);
    velocity.add(acceleration);

    if (!free){
     angle = atan2(Goal.y-location.y, Goal.x-location.x);
     acceleration.x=pAccel*cos(angle);
     acceleration.y=pAccel*sin(angle);
    
    if (abs(location.x - Goal.x) <velocity.x*3 || abs(location.y-Goal.y) <velocity.y*3){
      velocity.x*=0.8;
      velocity.y*=0.8;
    }
  }
  else{
    CheckEdge();
     // Our algorithm for calculating acceleration:
    PVector mouse = new PVector(mouseX,mouseY);
    PVector dir = PVector.sub(mouse,location);  // Find vector pointing towards mouse
    dir.normalize();     // Normalize
    dir.mult(0.1);       // Scale 
    acceleration = dir;  // Set to acceleration

    // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    
    
  }
  
  go();
  }
  void go(){
  if(free)
  {
    stroke(farColor);
  }
  else
  {
    if (abs(location.x - Goal.x) < 10 && abs(location.y-Goal.y) < 10)
    {
      stroke(nearColor);
    }
    else
    {
      stroke(farColor);
    }
  }
  point (location.x, location.y);
}

void CheckEdge(){
  
  if (location.x>width || location.x<0 || location.y>height || location.y<0){
    velocity.x = 0;
    velocity.y = 0;
    if(location.y>height){
      acceleration.y*=-1;
      location.y=height-1;
    }else if (location.y<0){
      acceleration.y*=-1;
      location.y=1;
    }else if (location.x>width){
      acceleration.x*=-1;
      location.x=width-1;
    }else if (location.x<0){
      acceleration.x*=-1;
      location.x=1;
    }
  }
}
}
      
      
  
