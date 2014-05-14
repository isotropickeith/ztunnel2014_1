import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ztunnel2014_1 extends PApplet {

ZTunnel gTunnel;

public void setup()
{
  gTunnel = new ZTunnel();

}

public void draw()
{
  gTunnel.update();

}


public void mousePressed()
{
  // Invoke method of EventDispatcher
}
public void mouseReleased()
{
  // Invoke method of EventDispatcher
}

public interface Animation
{
	public abstract void start();
	public abstract void update();
}
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

  public float getX()
  {
    return mX;
  }
 
  public float getY()
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
       mXVel *= 0.8f;
       mYVel *= 0.8f;
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
 public void draw(int particleColor)
 {
    stroke(particleColor);

    point(mX, mY);
 }


  
 public void checkEdge()
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
public class ParticleLettersAni implements Animation
{
	static final float sAccel = .05f;  		//acceleration rate of the particles
	static final float sMaxSpeed = 2;  		//max speed the particles can move at
	static final int   sNearBoundry = 25;   // # pixels to goal that defines "near"

	PImage mWords;  					//holds the image container the words
	int mBgColor = color(0);
	int mTestColor = color(255);  	//the color we will check for in the image. Currently black
	int mNearColor = color(255,0,0);
	int mFarColor = color(255,255,255);

	Particle[] mParticles = new Particle[0];
	boolean mFree = true;  //when this becomes false, the particles move toward their goals
	int mFreePeriod = 13;  // 13 sec. preriod for free/not free states

	static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


	public void start()
	{
		println("ParticleLettersAni starting up.");
		mWords = loadImage("text2.png");
		stroke(255);

		//go through the image, find all black pixel and create a particle for them
		//start by drawing the background and the image to the screen
		background(mBgColor);
		image(mWords, 0, 0);  //draw the image to screen
		loadPixels();  //lets us work with the pixels currently on screen
		  
		//go through the entire array of pixels, creating a particle for each black pixel
		for (int x = 0; x < width; x++)
		{
		    for (int y = 0; y < height; y++)
		    {
		      	if (pixels[GetPixel(x, y)] == mTestColor)
		      	{
		        	mParticles = (Particle[])append(mParticles, new Particle(x, y, sAccel));
		      	}
		    }
		}
		println("# particles : " + mParticles.length);
	}

	public void update()
	{
	  if(frameCount % (5 * ZTunnel.sFps) == 0)  // every 5 s.
	  {
		println("ParticleLettersAni.update() at frame :" + frameCount);
	  }

	  background(mBgColor);
	  
	  if(frameCount % (mFreePeriod * ZTunnel.sFps) == 0)
	  {
	    mFree = !mFree;  // toggle free state every freePeriod seconds
	  }
	  
	  for (int i = 0; i < mParticles.length; i++){
	    if (mParticles[i].getY() < 0)
	    {
	      //println("TOO FUCKNG HIGH");
	    }
	    // Update particle position
	    mParticles[i].update(mFree);

	    // Draw the particles
	    int particleColor = mFarColor;

	    if(!mFree && mParticles[i].isNear(sNearBoundry))
	    {
	    	particleColor = mNearColor;
	    }
	    mParticles[i].draw(particleColor);
	  }
	}

	//returns the locaiton in pixels[] of the point (x,y)
	public int GetPixel(int x, int y)
	{
  		return(x + y * width);
	}
 

}
public class TunnelDisplay
{
	
}
public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int numStripsPerSystem = 128;

	Animation sAni1;

	//ctor
	ZTunnel()
	{
		frameRate(sFps);
		size(sLedsPerStrip, numStripsPerSystem);
  		noCursor();

		sAni1 = new ParticleLettersAni();
		sAni1.start();
	}

	public void update()
	{
		sAni1.update();
	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ztunnel2014_1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
