/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word

 */


float beginX = 50.0;  // Initial x-coordinate
float beginY = 50.0;  // Initial y-coordinate
float endX = 75;   // Final x-coordinate
float endY = 60;   // Final y-coordinate
float distX;          // X-axis distance to move
float distY;          // Y-axis distance to move
float exponent = 4;   // Determines the curve
float freshx = 0;        // Current x-coordinate
float freshy = 0;        // Current y-coordinate
float step = 0.01;    // Size of each step along the path
float pct = 0.0;      // Percentage traveled (0.0 to 1.0)
int fps = 30; 
 

public class OrbitAni implements Animation
{
  static final float sAccel = .05;      //acceleration rate of the particles
  static final float sMaxSpeed = 2;     //max speed the particles can move at
  static final int   sNearBoundry = 25;   // # pixels to goal that defines "near"
  static final int   sDefaultImageTime = 60;  // load new image interval in seconds

  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint
  TunnelSense        mSense;          // Sensors in the tunnel

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage   mWords;            // image containing the words
  int      mCurFileIndex = 0;     // index into mFileNames for the current image
  int      mImageExpirationFrame;
  int      mStateChangeExpirationFrame = 0;

  color mBgColor = color(0);
  color mTestColor = color(255);    //the color we will check for in the image. Currently black
  color mNearColor = color(255,0,0);
  color mFarColor = color(255,255,255);

  Particlevector[] mParticles = new Particlevector[0];
  boolean mFree = true;  //when this becomes false, the particles move toward their goals
  int mFreePeriod = 13;  // 13 sec. preriod for free/not free states
  int mNumUsers = 0;     // Assume 0 peeps in tunnel to start

  static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


  //constructor
  OrbitAni(AnimationResources resources,
           TunnelDisplay      display,
           TunnelSense        sense)
  {
    mResources = resources;
    mDisplay = display;
    mSense = sense;

    mFilenames = mResources.getFiles("OrbitAni");
    mDurations = mResources.getFileDurations("OrbitAni");
    if(mFilenames.length == 0)
    {
      println("No Resources for OrbitAni - FAIL");
      exit();
    }
    else
    {
      println("Resource files for OrbitAni :");
      for(int i = 0; i < mFilenames.length; i++)
      {
        println("    " + mFilenames[i] + " : " + mDurations[i] + " sec.");
      }
    }
  }

  public void start()
  {
    println("OrbitAni starting up.");

    mCurFileIndex = 0;
    mWords = loadImage(mFilenames[mCurFileIndex]);
    if(mDurations[mCurFileIndex] != -1)
    {
      mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
    }
    else
    {
      mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
    }

    stroke(255);

    //go through the image, find all black pixel and create a particle for them
    //start by drawing the background and the image to the screen
    background(mBgColor);
    mWords.loadPixels();  //lets us work with the pixels currently on screen
      
    //go through the entire array of pixels, creating a particle for each black pixel
    for (int x = 0; x < width; x++)
    {
        for (int y = 0; y < height; y++)
        {
            if (mWords.get(x, y) == mTestColor)
            {
              mParticles = (Particlevector[])append(mParticles, new Particlevector(x, y, sAccel));
            }
        }
    }
    println("# particles : " + mParticles.length);

    // Determine our starting state free or not and whether we can use TunnelSense
    mFree = true;
    if(mSense.isEnabled())
    {
      mNumUsers = mSense.getNumUsers();
      if(mNumUsers > 0)
      {
        mFree = false;
      }
    }
    mStateChangeExpirationFrame = frameCount + (mFreePeriod * ZTunnel.sFps);
  }

  public void update()
  {

    ghost();
    
    background(mBgColor);

    if(frameCount % (5 * ZTunnel.sFps) == 0)  // every 5 s.
    {
      println("OrbitAni.update() at frame :" + frameCount);
    }

    // See if it's time to set a new image
    if(frameCount >= mImageExpirationFrame)  // every 5 s.
    {
      print("OrbitAni setting new image at frame " + frameCount);
      mCurFileIndex = (mCurFileIndex + 1) % mFilenames.length;
      mWords = loadImage(mFilenames[mCurFileIndex]);
      println(": " + mFilenames[mCurFileIndex] + " for " + mDurations[mCurFileIndex] + " sec.");
      if(mDurations[mCurFileIndex] != -1)
      {
        mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
      }
      else
      {
        mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
      }
      stroke(255);

      //go through the image, find all black pixel and create a particle for them
      //start by drawing the background and the image to the screen
      background(mBgColor);
      mWords.loadPixels();  //lets us work with the pixels currently on screen

      mParticles = new Particlevector[0];  // Delete current particles.

      //go through the entire array of pixels, creating a particle for each black pixel
      for (int x = 0; x < width; x++)
      {
        for (int y = 0; y < height; y++)
        {
          if (mWords.get(x, y) == mTestColor)
          {
            mParticles = (Particlevector[])append(mParticles, new Particlevector(x, y, sAccel));
          }
        }
      }
      println("# particles : " + mParticles.length);
    }

    if(frameCount >= mStateChangeExpirationFrame)
    {
      if(mSense.isEnabled())
      {
        int newUserCount = mSense.getNumUsers();
        if(mNumUsers != newUserCount)
        {
          if(newUserCount == 0 || mNumUsers == 0)
          {
            mFree = !mFree;
            mStateChangeExpirationFrame = frameCount + (mFreePeriod * ZTunnel.sFps);
            println("Free state change - # users = " + newUserCount);
          }
          mNumUsers = newUserCount;
        }
      }
      else   // No tunnel sense, timer only
      {
        mFree = !mFree;
        mStateChangeExpirationFrame = frameCount + (mFreePeriod * ZTunnel.sFps);
      }
    }

    for (int i = 0; i < mParticles.length; i++){
      if (mParticles[i].getY() < 0)
      {
        //println("TOO FUCKNG HIGH");
      }
      // Update particle position
      mParticles[i].update(mFree);

      // Draw the particles
      color particleColor = mFarColor;

      if(!mFree && mParticles[i].isNear(sNearBoundry))
      {
        particleColor = mNearColor;
      }
      mParticles[i].draw(particleColor);
    }
    // Send the screen image to the Tunnel for display
    mDisplay.sendImage();
  }


   private void ghost()
   {
   // fill(0, 2);
    //rect(0, 0, width, height);
    pct += step;
    if (pct < 1.0)
    {
      freshx = beginX + (pct * distX);
      freshy = beginY + (pow(pct, exponent) * distY);
    }
    //fill(255);
    //ellipse(x, y, 20, 20);
    
    if(frameCount % (3 * fps) == 0)
    {
      pct = 0.0;
      beginX = freshx;
      beginY = freshy;
      endX = random(0, width);
      endY = random(0, height);
      distX = endX - beginX;
      distY = endY - beginY;
    }
    println("locationx : " + freshx);
    println("locationy : " + freshy);
  }
      

  public void stop()
  {
    // do nothing
  }


  public String getName()
  {
    return "OrbitAni";
  }


  //returns the locaiton in pixels[] of the point (x,y)
  int GetPixel(int x, int y)
  {
      return(x + y * width);
  }

}
