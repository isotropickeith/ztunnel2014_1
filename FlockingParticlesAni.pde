/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word
 */

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word
 */



public class FlockingParticlesAni implements Animation
{
  static final float sAccel = .05;      //acceleration rate of the particles
  static final float sMaxSpeed = 2;     //max speed the particles can move at
  static final int   sNearBoundry = 25;   // # pixels to goal that defines "near"
  static final int   sDefaultImageTime = 60;  // load new image interval in seconds
  
  
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage   mWords;            // image containing the words
  int      mCurFileIndex = 0;     // index into mFileNames for the current image
  int      mImageExpirationFrame;

  color mBgColor = color(0);
  color mTestColor = color(255);    //the color we will check for in the image. Currently black
  color mNearColor = color(255,0,0);
  color mFarColor = color(255,255,255);

  //Bird[] mBirds = new Bird[0];
  Flock mFlock;
  boolean mFree = true;  //when this becomes false, the particles move toward their goals
  int mFreePeriod = 13;  // 13 sec. preriod for free/not free states

  static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


  //constructor
  FlockingParticlesAni(AnimationResources resources,
           TunnelDisplay display)
  {
    mResources = resources;
    mDisplay = display;

    mFilenames = mResources.getFiles("FlockingParticlesAni");
    mDurations = mResources.getFileDurations("FlockingParticlesAni");
    if(mFilenames.length == 0)
    {
      println("No Resources for FlockingParticlesAni - FAIL");
      exit();
    }
    else
    {
      println("Resource files for FlockingParticlesAni :");
      for(int i = 0; i < mFilenames.length; i++)
      {
        println("    " + mFilenames[i] + " : " + mDurations[i] + " sec.");
      }
    }
  }

  public void start()
  {
    mFlock = new Flock();
    if(mFlock == null)
    {
      println("FlockingParticlesAni failed to create a Flock - FAIL");
      exit();
    }
    println("FlockingParticlesAni starting up.");

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
             //if (mWords[GetPixel(x,y)] == mTestColor)
            {
              Bird p = new Bird(x, y, sAccel);
              mFlock.addBird(p);
              //mBirds = (Bird[])append(mBirds, new Bird(x, y, sAccel));
            }
        }
    }
    println("# birds : " + mFlock.getFlock().size());
    //println("# birds : " + m.length);
    //println("# particles : " + flock.getFlock().size());
  }

  public void update()
  {
    background(mBgColor);

    if(frameCount % (5 * ZTunnel.sFps) == 0)  // every 5 s.
    {
      println("FlockingParticlesAni.update() at frame :" + frameCount);
    }

    // See if it's time to set a new image
    if(frameCount >= mImageExpirationFrame)  // every 5 s.
    {
      print("FlockingParticlesAni setting new image at frame " + frameCount);
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
      
      //mBirds = new Bird[0];  // Delete current particles.

      //go through the entire array of pixels, creating a particle for each black pixel
      for (int x = 0; x < width; x++)
      {
        for (int y = 0; y < height; y++)
        {
          if (mWords.get(x, y) == mTestColor)
          {
            Bird p = new Bird(x, y, sAccel);
            //mBirds = (Bird[])append(mBirds, new Bird(x, y, sAccel));
            mFlock.addBird(p);
          }
        }
      }
      println("# birds : " + mFlock.getFlock().size());
    }

     mFlock.run(mFree);

    if(frameCount % (mFreePeriod * ZTunnel.sFps) == 0)
    {
      mFree = !mFree;  // toggle free state every freePeriod seconds
    }

    //for (int i = 0; i < mBirds.length; i++)
    //{
      //if (mBirds[i].getY() < 0)
      //{
        //println("TOO FUCKNG HIGH");
      //}
      // Update particle position
      //mBirds[i].update(mFree);

      // Draw the particles
      //color birdColor = mFarColor;

      //if(!mFree && mBirds[i].isNear(sNearBoundry))
      //{
        //birdColor = mNearColor;
      //}
      //mBirds[i].draw(birdColor);
    //}
    mDisplay.sendImage();
  }

  public void stop()
  {
    // do nothing
  }


  public String getName()
  {
    return "FlockingParticlesAni";
  }


  //returns the locaiton in pixels[] of the point (x,y)
  int GetPixel(int x, int y)
  {
      return(x + y * width);
  }

}

