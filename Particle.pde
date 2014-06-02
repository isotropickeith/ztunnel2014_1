public class Particle
{
  float mXGoal;   //the point that the particle wants to return to
  float mYGoal;
  float mAccel;

  float mX;       //x and y locaiton of particle
  float mY;

  float mXVel;    //x and y velocity of particle
  float mYVel;  
  //float mXVelMax;  //will hold the maximum velocity for the particle
  //float mYVelMax;
  float mXAccel;  //x and y accelaration
  float mYAccel;
  float mAng;  //angle ind egrees that particle should be moving at
 
 
 
  //constructor
  Particle(float newXGoal,
           float newYGoal,
           float accel)
  {
    mXGoal = newXGoal;
    mYGoal = newYGoal;
    mAccel = accel;
    mX = random(width);
    mY = random(height);
    mAng = random(0, TWO_PI);  //we're using radians
    mXVel = 0;
    mYVel = 0;

    mXAccel = mAccel * cos(mAng);
    mYAccel = mAccel * sin(mAng);
  }

  float getX()
  {
    return mX;
  }
 
  float getY()
  {
    return mY;
  }
 
 //deals with the frame to frame changes of the particle
 public void update(boolean  isFree)
 {
   //println(degrees(ang));
   mX += mXVel;
   mY += mYVel;
   
   mXVel += mXAccel;
   mYVel += mYAccel;
   
   //if the particles are not free, move this particle toward its goal
   if (!isFree)
   {
     //get the ange of the thing point the particle should move toward
     mAng = atan2(mYGoal - mY, mXGoal -  mX);
     mXAccel = mAccel * cos(mAng);
     mYAccel = mAccel * sin(mAng);
     
     //slow it down a lot if it's close to the point
     if (abs(mX - mXGoal) < mXVel * 3 || abs(mY - mYGoal) < mYVel * 3)
     {
       mXVel *= 0.8;
       mYVel *= 0.8;
     }
   }
   else
   {
     //make it bounce off edges if it's free moving
     checkEdge();
   }
   
   
   /* MIGHT NOT NEED THIS
   //make sure we're not above the max speed
   xVelMax=pMaxSpeed*cos(ang);
   yVelMax=pMaxSpeed*sin(ang);
   
   if (xVel>0 && xVel>xVelMax)
     xVel=xVelMax;
   if (xVel<0 && xVel< -xVelMax)
     xVel=-xVelMax;
     
   if (yVel>0 && yVel>yVelMax)
     yVel=yVelMax;
   if (yVel<0 && yVel< -yVelMax)
     yVel=-yVelMax;
     
   println(abs(xVel)+abs(yVel));
   */
     
   //<<<<<<<<<<<<<<< We're gonna let the animation draw the Particle
   //draw();
 }
 

 //draws the particle on screen
 public void draw(color particleColor)
 {
    stroke(particleColor);

    point(mX, mY);
 }

 
public boolean isNear(int distance)
{
  if(abs(mX - mXGoal) < distance &&
     abs(mY - mYGoal) < distance)
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
   if (mX > width || mX < 0 || mY > height || mY < 0)
   {
     mXVel = 0;
     mYVel = 0;
     if (mY > height)
     {
       mYAccel *= -1;
       mY = height - 1;
     }
     else if (mY < 0)
     {
       mYAccel *= -1;
       mY = 1;
     }
     else if (mX > width)
     {
       mXAccel *= -1;
       mX = width - 1;
     }
     else if (mX < 0)
     {
       mXAccel *= -1;
       mX = 1;
     }
   }
 }
   
   
   /*
   if (x>width || x<0){
     ang+=PI;
     println("hitEdge");
   }
   if (y>height || y<0){
     ang+=PI;
     println("hitEdge");
   }
   */
  
}