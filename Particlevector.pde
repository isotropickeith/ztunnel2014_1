
class Particlevector{
  PVector mLocation;
  PVector mVelocity;
  PVector mAcceleration;
  PVector mGoal;
  float mAccel;

  float mR;
  float mAngle;
  float mTopspeed;
  //float maxforce;    // Maximum steering force
  //float maxspeed;  
  
  Particlevector(float newXGoal,
                 float newYGoal,
                 float accel)
  {
    mAcceleration =new PVector(0, 0);
    mAngle = random(TWO_PI);
    mVelocity = new PVector(cos(mAngle), sin(mAngle));
    mLocation = new PVector((random(width)),(random(height)));
 
    mAccel = accel;
    mR = 0.1;
    mTopspeed = 3;
    //maxspeed = 1.1;
    //maxforce = 0.03;
    
   mGoal = new PVector(newXGoal, newYGoal);

  }

  public float getX()
  {
    return mLocation.x;
  }
 
  public float getY()
  {
    return mLocation.y;
  }
 
//public float getPoint() {
  //return freshx;

//}
  
  public void update(boolean  isFree)
  {
    mLocation.add(mVelocity);
    mVelocity.add(mAcceleration);

    if (!isFree)
    {
      checkEdge();

      mAngle = atan2(mGoal.y - mLocation.y, mGoal.x - mLocation.x);
      mAcceleration.x = mAccel * cos(mAngle);
      mAcceleration.y = mAccel * sin(mAngle);
    
      if (abs(mLocation.x - mGoal.x) < mVelocity.x * 3 ||
          abs(mLocation.y - mGoal.y) < mVelocity.y * 3)
      {
        mVelocity.x *= 0.2;
        mVelocity.y *= 0.2;
      }
    }
    else
    {
//println("locationx : " + p);

      checkEdge();
       // Our algorithm for calculating acceleration:
      PVector mouse = new PVector(freshx, freshy);
      PVector dir = PVector.sub(mouse, mLocation);  // Find vector pointing towards mouse
      dir.normalize();      // Normalize
      dir.mult(0.2);        // Scale 
      mAcceleration = dir;  // Set to acceleration

      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      mVelocity.add(mAcceleration);
      mVelocity.limit(mTopspeed);
      mLocation.add(mVelocity);
    }
  }

//public float mParticles[i].GetDist()
//{
  //return dist(mLocation.x, mLocation.y, mGoal.x, mGoal.y);
//}
   //draws the particle on screen
   public void draw(color particleColor)
   {
      stroke(particleColor);

      point(mLocation.x, mLocation.y);
   }

  public boolean isNear(int distance)
  {
    if (abs(mLocation.x - mGoal.x) < distance &&
        abs(mLocation.y - mGoal.y) < distance)
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
    if (mLocation.x > width  || mLocation.x < 0 ||
        mLocation.y > height || mLocation.y < 0)
    {
      mVelocity.x = 0;
      mVelocity.y = 0;

      if(mLocation.y > height)
      {
        mAcceleration.y *= -1;
        mLocation.y = height - 1;
      }
      else if (mLocation.y < 0)
      {
        mAcceleration.y *= -1;
        mLocation.y = 1;
      }
      else if (mLocation.x > width)
      {
        mAcceleration.x *= -1;
        mLocation.x = width - 1;
      }
      else if (mLocation.x < 0)
      {
        mAcceleration.x *= -1;
        mLocation.x = 1;
      }

    }
  }

  public float getDist()
  {
    return dist(mLocation.x, mLocation.y, mGoal.x, mGoal.y);
  }


};

      
      
  
