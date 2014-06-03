public class Bird
{
  float x, y;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector goal;
  float mAccel;

  float r;
  float angle;
  float maxforce;    // Maximum steering force
  float maxspeed;  
  float se = 0.8;
  float al = 1.0;
  float co = 0.92;
  
  Bird(float x,
       float y,
       float accel)
  {
    acceleration =new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    location = new PVector((random(width)),(random(height)));

    mAccel = accel;

    r = 0.1;
    maxspeed = 1.1;
    maxforce = 0.03;
    
   goal = new PVector(x, y);

  }

  public float getX()
  {
    return location.x;
  }
 
  public float getY()
  {
    return location.y;
  }
 


  
  public void run(ArrayList <Bird> birds, boolean isFree)
  {
    flock(birds);
    update(isFree);
    borders();
  }
    
  public void applyForce(PVector force)
  {
    acceleration.add(force);
  }
    
    
 public void flock(ArrayList<Bird> birds)
 {
    PVector sep = separate(birds);
    PVector ali = align(birds);
    PVector coh = cohesion(birds);
    
    sep.mult(se);
    ali.mult(al);
    coh.mult(co);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
    
    
    
    
    
 public PVector seek(PVector target)
 {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }
    
  void borders()
  {
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r;
    if (location.x > width + r) location.x = -r;
    if (location.y > height + r) location.y = -r;
  }
  
  PVector separate (ArrayList<Bird> birds)
  {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    for (Bird other : birds) {
      float d = PVector.dist(location, other.location);
      
      if ((d > 0) && (d < desiredseparation))
      {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    
    if (count > 0)
    {
      steer.div((float)count);
    }
    
    if (steer.mag() > 0)
    {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  PVector align (ArrayList<Bird> birds) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Bird other : birds) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
        
    if (count > 0)
    {
      sum.div((float)count);
      
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    }
    else
    {
      return new PVector(0, 0);
    }
  }
    
  PVector cohesion (ArrayList<Bird> birds)
  {
    float neighbordist = 50;
    PVector sum = new PVector (0, 0);
    int count = 0;
    for (Bird other : birds)
    {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist))
      {
        sum.add(other.location);
        count++;
      }
    }
    if (count > 0)
    {
      sum.div(count);
      return seek(sum);
    }
    else
    {
      return new PVector(0, 0);
    }
  }
  
  public void update(boolean isFree)
  {
    location.add(velocity);
    velocity.add(acceleration);

    if (!isFree)
    {
      angle = atan2(goal.y - location.y, goal.x - location.x);
      acceleration.x = mAccel * cos(angle);
      acceleration.y = mAccel * sin(angle);
      se = 0.8;
      al = 1.0;
      co = 0.92;
       
      se = 0;
      al = 0;
      co = 0;
      checkEdge();
    
    
      if(abs(location.x - goal.x) < velocity.x * 3 ||
         abs(location.y - goal.y) < velocity.y * 3)
      {
        velocity.x *= 0.8;
        velocity.y *= 0.8;
      }
    }
    else
    {
      borders();
     //checkEdge();
      se = 0.8;
      al = 1.0;
      co = 0.92;
      //run(birds);    
      velocity.add(acceleration);
      velocity.limit(maxspeed);
      location.add(velocity);

      acceleration.mult(0);
    }
  }

     //draws the particle on screen
   public void draw(color particleColor)
   {
      stroke(particleColor);

      point(location.x, location.y);
   }

  public boolean isNear(int distance)
  {
    if (abs(location.x - goal.x) < distance &&
        abs(location.y - goal.y) < distance)
    {
      return true;
    }
    else
    {
      return false;  
    }
  }



  private void checkEdge()
  {
    if (location.x > width || location.x < 0 ||
        location.y > height || location.y < 0)
    {
      velocity.x = 0;
      velocity.y = 0;
      if(location.y > height)
      {
        acceleration.y *= -1;
        location.y = height - 1;
      }
      else if (location.y < 0)
      {
        acceleration.y *= -1;
        location.y = 1;
      }
      else if (location.x > width)
      {
        acceleration.x *= -1;
        location.x = width - 1;
      }
      else if (location.x < 0)
      {
        acceleration.x *= -1;
        location.x = 1;
      }
    }
  }

}    
      
  
