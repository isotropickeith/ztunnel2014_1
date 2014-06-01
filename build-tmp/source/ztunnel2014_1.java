import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import hypermedia.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
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
	public abstract String getName();
	public abstract void stop();
}
public class AnimationResources
{
	TunnelDisplay mDisplay;
	XML mXml;
	XML[] mAnimationElements;
	ArrayList<Animation> mAnimations;

	//constructor
	AnimationResources(TunnelDisplay display)
	{
		mDisplay = display;

		mXml = loadXML("TunnelCfg.xml");
		
		mAnimationElements = mXml.getChildren("animation");

		mAnimations = new ArrayList<Animation>();

		if(mAnimationElements.length == 0)
		{
			println("No animations! - ERROR");
			exit();
		}
		for(int i = 0; i < mAnimationElements.length; i++)
		{
			String aniName = mAnimationElements[i].getString("id");
			Animation newAnimation = null;
			println("DEBUG: Animation " + i + ": " + aniName);
			if(aniName.equals("ParticleLettersAni"))
			{
				newAnimation = new ParticleLettersAni(this, mDisplay);
			}
			else if(aniName.equals("OrbitAni"))
			{
				newAnimation = new OrbitAni(this, mDisplay);
			}
			else if(aniName.equals("FlockingParticlesAni"))
			{
				newAnimation = new FlockingParticlesAni(this, mDisplay);
			}
			else
			{
				println("AnimationResources::ctor Do not recognize animation " + aniName
					       + " ERROR...");
				exit();
			}
			if(newAnimation != null)
			{
				mAnimations.add(newAnimation);
			}
		}
	}

	public ArrayList getAnimations()
	{
		return mAnimations;
	}

	public String[] getFiles(String animationName)
	{
		String[] fileNames = {};

		for(int i = 0; i < mAnimationElements.length; i++)
		{
			println("DEBUG: Animation " + i + ": " + mAnimationElements[i].getString("id"));
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				XML[] files = mAnimationElements[i].getChildren("imageFile");
				println("   #files = " + files.length);
				for(int j = 0; j < files.length; j++)
				{
					String fileName = files[j].getString("name");
					if(fileName != null)
					{
						fileNames = append(fileNames, fileName);
					}
					else
					{
						println("null filename in AnimationResources.getFiles()");
					}
				}
			}
		}
		return fileNames;
	}

	public int getAnimationDuration(String animationName)
	{
		for(int i = 0; i < mAnimationElements.length; i++)
		{
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				int duration = mAnimationElements[i].getInt("duration", -1);
				println("Animation " + animationName + " duration = " + duration);
				return duration;
			}
		}
		println("getAnimationDuration() can't find Animation " + animationName);
		return -1;
	}

	public int[] getFileDurations(String animationName)
	{
		int[] durations = {};

		for(int i = 0; i < mAnimationElements.length; i++)
		{
			println("DEBUG: Animation " + i + ": " + mAnimationElements[i].getString("id"));
			if(mAnimationElements[i].getString("id").equals(animationName))
			{
				XML[] files = mAnimationElements[i].getChildren("imageFile");
				println("   #files = " + files.length);
				for(int j = 0; j < files.length; j++)
				{
					int duration = files[j].getInt("duration", -1);
					durations = append(durations, duration);
					if(duration == -1)
					{
						println("null duration in AnimationResources.getFileDurations()");
					}
				}
			}
		}
		return durations;
	}

}
public class AnimationScheduler
{
	AnimationResources mResources;
	int mCurAnimationIndex;
	int mAnimationExpires;

	ArrayList<Animation> mAnimations;
	Animation mCurAnimation;

	AnimationScheduler(AnimationResources resources)
	{
		mResources = resources;
		mCurAnimationIndex = 0;
		mAnimationExpires = -1;

		mAnimations = mResources.getAnimations();

	}

	public void start()
	{
		mCurAnimation = mAnimations.get(mCurAnimationIndex);
		String animationName = mCurAnimation.getName();
		int aniDuration = mResources.getAnimationDuration(animationName);
		mAnimationExpires = frameCount + (aniDuration * ZTunnel.sFps);
	}

	public void update()
	{
		if(frameCount >= mAnimationExpires)
		{
			mCurAnimation.stop();
			mCurAnimationIndex = (mCurAnimationIndex + 1) % mAnimations.size();
			start();
		}
		else
		{
			mCurAnimation.update();
		}
	}
}
public class Bird{
  float x, y;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector Goal;
  float r;
  float angle;
  float maxforce;    // Maximum steering force
  float maxspeed;  
  float se = 0.8f;
  float al = 1.0f;
  float co = 0.92f;
  
  Bird(float x, float y){
    acceleration =new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    location = new PVector((random(width)),(random(height)));
 
    r = 0.1f;
    maxspeed = 1.1f;
    maxforce = 0.03f;
    
    //Goal = new PVector((random(width)),(random(height)));
   Goal = new PVector(x, y);

  }
  
  
  
  public void run(ArrayList <Bird> birds){
      flock(birds);
      Update();
      borders();
      render();
    }
    
  public  void applyForce(PVector force) {
      acceleration.add(force);
    }
    
    
 public   void flock(ArrayList<Bird> birds) {
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
    
    
    
    
    
 public   PVector seek(PVector target) {
      PVector desired = PVector.sub(target, location);
      desired.normalize();
      desired.mult(maxspeed);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      return steer;
    }
    
 public   void render(){
      point(location.x, location.y);
    }
      
      public void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
  
  public PVector separate (ArrayList<Bird> birds) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    for (Bird other : birds) {
      float d = PVector.dist(location, other.location);
      
      if ((d> 0) && (d < desiredseparation)) {
        
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    
    if (count > 0) {
      steer.div((float)count);
    }
    
    if (steer.mag() > 0) {
      
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  public PVector align (ArrayList<Bird> birds) {
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
        
        if (count > 0) {
        sum.div((float)count);
        
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        return steer;
      }
      else {
        return new PVector(0, 0);
      }
    }
    
    public PVector cohesion (ArrayList<Bird> birds) {
      float neighbordist = 50;
      PVector sum = new PVector (0, 0);
      int count= 0;
      for (Bird other : birds) {
        float d = PVector.dist(location, other.location);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.location);
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        return seek(sum);
      }
      else {
        return new PVector(0, 0);
      }
    }
  
  
  
  
  
  
 public void Update(){
    location.add(velocity);
    velocity.add(acceleration);

    if (!isFree){
     angle = atan2(Goal.y-location.y, Goal.x-location.x);
     acceleration.x=pAccel*cos(angle);
     acceleration.y=pAccel*sin(angle);
     se = 0.8f;
     al = 1.0f;
     co = 0.92f;
     
     se = 0;
     al = 0;
     co = 0;
     CheckEdge();
    
    if (abs(location.x - Goal.x) <velocity.x*3 || abs(location.y-Goal.y) <velocity.y*3){
      velocity.x*=0.8f;
      velocity.y*=0.8f;
    }
  }
  else{
   // CheckEdge();
      se = 0.8f;
     al = 1.0f;
     co = 0.92f;
    //run(birds);    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);

    acceleration.mult(0);
    
  }
  
  Draw();
  }
 public void Draw(){
  if(isFree)
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

private void CheckEdge(){
  
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
      
  
class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the boids

  Flock() {
    particles = new ArrayList<Particle>(); // Initialize the ArrayList
  }
  
  public ArrayList<Particle> getFlock()
  {
    return particles;
  }

  public void run() {
    for (Particle b : particles) {
      b.run(particles);  // Passing the entire list of boids to each boid individually
    }
  }

  public void addParticle(Particle b) {
    particles.add(b);
     
  }

}
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
Flock flock;

public class FlockingParticlesAni implements Animation
{
  static final float sAccel = .05f;      //acceleration rate of the particles
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

  int mBgColor = color(0);
  int mTestColor = color(255);    //the color we will check for in the image. Currently black
  int mNearColor = color(255,0,0);
  int mFarColor = color(255,255,255);

  Particlevector[] mBirds = new Particlevector[0];
  boolean mFree = true;  //when this becomes false, the particles move toward their goals
  int mFreePeriod = 13;  // 13 sec. preriod for free/not free states

  static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states

//flock = new Flock();

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

    
flock = new Flock();
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
            {
              mBirds = (Bird[])append(mBirds, new Bird(x, y, sAccel));
            }
        }
    }
    println("# birds : " + mBirds.length);
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
      
      mBirds = new Bird[0];  // Delete current particles.

      //go through the entire array of pixels, creating a particle for each black pixel
      for (int x = 0; x < width; x++)
      {
        for (int y = 0; y < height; y++)
        {
          if (mWords.get(x, y) == mTestColor)
          Bird p = new Bird(x, y);
          {
            //mBirds = (Bird[])append(mBirds, new Bird(x, y, sAccel));
            flock.addParticle(p);
          }
        }
      }
      println("# birds : " + mBirds.length);
    }

     flock.run();

    if(frameCount % (mFreePeriod * ZTunnel.sFps) == 0)
    {
      mFree = !mFree;  // toggle free state every freePeriod seconds
    }

    /*for (int i = 0; i < mBirds.length; i++){
      if (mBirds[i].getY() < 0)
      {
        //println("TOO FUCKNG HIGH");
      }
      // Update particle position
      mBirds[i].update(mFree);

      // Draw the particles
      color birdColor = mFarColor;

      if(!mFree && mBirds[i].isNear(sNearBoundry))
      {
        birdColor = mNearColor;
      }
      mBirds[i].draw(particleColor);
    }*/
    // <<<<<<<<<<<<< create a PImage from display >>>>>>>>>>>>
    // mDisplay.sendImage(image);
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
  public int GetPixel(int x, int y)
  {
      return(x + y * width);
  }

}

/*

 Flock flock;
 
//Particle[] particles=new Particle[0];
boolean free=true;  //when this becomes false, the particles move toward their goals
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector Goal;
  //int x;
  //int y;
int freePeriod = 20;  // 13 sec. preriod for free/not free states
int fps = 30;         // framerate
float pAccel=.05;

//PVector pAccel = PVector.sub(Goal, location);

//float pAccel=.05;  //acceleration rate of the particles
float pMaxSpeed=2;  //max speed the particles can move at

color bgColor=color(0);

PImage words;  //holds the image container the words
color testColor=color(255);  //the color we will check for in the image. Currently black

color nearColor = color(255,0,0);
color farColor = color(255,255,255);

void setup()
{
  frameRate(fps);
   Goal = new PVector((random(width)),(random(height)));
  //location = new PVector(x, y);
 // pAccel.normalize();
//pAccel.mult(.05);

  words=loadImage("dog.png");
  size(157,128);
  noCursor();
  stroke(255);
  
  flock = new Flock();

  
  //go through the image, find all black pixel and create a particle for them
  //start by drawing the background and the image to the screen
  background(bgColor);
  image(words,0,0);  //draw the image to screen
  loadPixels();  //lets us work with the pixels currently on screen
  
  //go through the entire array of pixels, creating a particle for each black pixel
  for (int x=0; x<width; x++){
    for (int y=0; y<height; y++){
      if (pixels[GetPixel(x,y)] == testColor){
        Particle p = new Particle(x, y);
        //particles=(Particle[])append(particles, p);
        flock.addParticle(p);
      }
    }
  }
  println("# particles : " + flock.getFlock().size());
}

void draw(){
  background(bgColor);
 flock.run();
  if(frameCount % (freePeriod * fps) == 0)
  {
    free = !free;  // toggle free state every freePeriod seconds
  }
  
  //for (int i=0; i<particles.length; i++){
  //  if (particles[i].location.y<0){
  //   
   // }
   // particles[i].Update(flock.getFlock());
  //}
  //saveFrame("pic/edu-####.png");
}


void mousePressed(){
  free=false;
}
void mouseReleased(){
  free=true;
}

//returns the locaiton in pixels[] of the point (x,y)
int GetPixel(int x, int y) {
  return(x+y*width);
}
 
 */
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word
 */
public class OrbitAni implements Animation
{
  static final float sAccel = .05f;      //acceleration rate of the particles
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

  int mBgColor = color(0);
  int mTestColor = color(255);    //the color we will check for in the image. Currently black
  int mNearColor = color(255,0,0);
  int mFarColor = color(255,255,255);

  Particlevector[] mParticles = new Particlevector[0];
  boolean mFree = true;  //when this becomes false, the particles move toward their goals
  int mFreePeriod = 13;  // 13 sec. preriod for free/not free states

  static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


  //constructor
  OrbitAni(AnimationResources resources,
           TunnelDisplay display)
  {
    mResources = resources;
    mDisplay = display;

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
  }

  public void update()
  {
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
    // <<<<<<<<<<<<< create a PImage from display >>>>>>>>>>>>
    // mDisplay.sendImage(image);
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
  public int GetPixel(int x, int y)
  {
      return(x + y * width);
  }

}

/*<<<<<<<<<<<<<<< OLd >>>>>>>>>>>>> 
public class ParticleVectorLettersHackFollowMouse implements Animation
{
  AnimationResources mResources;      // AnimationResources object
  TunnelDisplay      mDisplay;        // The display bject on which to paint

  String[] mFilenames;        // Array of Filenames for images to display
  int[]    mDurations;        // Array of durations for images to display
  PImage   mWords;            // image containing the words
  int      mCurFileIndex = 0;     // index into mFileNames for the current image
  int      mImageExpirationFrame;

  Particlevector[] mParticles;
  boolean mFree;  //when this becomes false, the particles move toward their goals
  PVector mLocation;
  PVector mVelocity;
  PVector mAcceleration;
  PVector mGoal;
  //int x;
  //int y;


  int freePeriod = 20;  // 13 sec. preriod for free/not free states
  float pAccel=.05;

  //PVector pAccel = PVector.sub(Goal, location);

  //float pAccel=.05;  //acceleration rate of the particles
  float pMaxSpeed=2;  //max speed the particles can move at

  color bgColor=color(0);

  PImage words;  //holds the image container the words
  color testColor=color(255);  //the color we will check for in the image. Currently black

  color nearColor = color(255,0,0);
  color farColor = color(255,255,255);

  ParticleVectorLettersHackFollowMouse(AnimationResources resources,
                                       TunnelDisplay display)
  {
    mResources = resources;
    mDisplay = display;

    mParticles = new Particlevector[0];
    mFree = true;
  }

  public void start()
  {
     mGoal = new PVector((random(width)), (random(height)));
    //location = new PVector(x, y);
   // pAccel.normalize();
  //pAccel.mult(.05);

    words=loadImage("text2.png");
    size(157,128);
    noCursor();
    stroke(255);
    
    //go through the image, find all black pixel and create a particle for them
    //start by drawing the background and the image to the screen
    background(bgColor);
    image(words,0,0);  //draw the image to screen
    loadPixels();  //lets us work with the pixels currently on screen
    
    //go through the entire array of pixels, creating a particle for each black pixel
    for (int x=0; x<width; x++){
      for (int y=0; y<height; y++){
        if (pixels[GetPixel(x,y)] == testColor){
          particles=(Particlevector[])append(particles, new Particlevector(x, y));
        }
      }
    }
    println("# particles : " + particles.length);
  }

  public void Update(){
    background(bgColor);
    
    if(frameCount % (freePeriod * fps) == 0)
    {
      free = !free;  // toggle free state every freePeriod seconds
    }
    
    for (int i=0; i<particles.length; i++){
      if (particles[i].location.y<0){
       
      }
      particles[i].Update();
    }
    //saveFrame("pic/edu-####.png");
  }


  //void mousePressed(){
    //free=true;
  //}
  //void mouseReleased(){
    //free=false;
  //}

  //returns the locaiton in pixels[] of the point (x,y)
  int GetPixel(int x, int y) {
    return(x+y*width);
  }
 
} */
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
public class ParticleLettersAni implements Animation
{
	static final float sAccel = .05f;  		//acceleration rate of the particles
	static final float sMaxSpeed = 2;  		//max speed the particles can move at
	static final int   sNearBoundry = 25;   // # pixels to goal that defines "near"
	static final int   sDefaultImageTime = 60;  // load new image interval in seconds

	AnimationResources mResources;			// AnimationResources object
	TunnelDisplay			 mDisplay;				// The display bject on which to paint

	String[] mFilenames;				// Array of Filenames for images to display
	int[]    mDurations;				// Array of durations for images to display
	PImage   mWords;  					// image containing the words
	int      mCurFileIndex = 0;			// index into mFileNames for the current image
	int      mImageExpirationFrame;

	int mBgColor = color(0);
	int mTestColor = color(255);  	//the color we will check for in the image. Currently black
	int mNearColor = color(255,0,0);
	int mFarColor = color(255,255,255);

	Particle[] mParticles = new Particle[0];
	boolean mFree = true;  //when this becomes false, the particles move toward their goals
	int mFreePeriod = 13;  // 13 sec. preriod for free/not free states

	static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states


	//constructor
	ParticleLettersAni(AnimationResources resources,
										 TunnelDisplay display)
	{
		mResources = resources;
		mDisplay = display;

		mFilenames = mResources.getFiles("ParticleLettersAni");
		mDurations = mResources.getFileDurations("ParticleLettersAni");
		if(mFilenames.length == 0)
		{
			println("No Resources for ParticleLettersAni - FAIL");
			exit();
		}
		else
		{
		  println("Resource files for ParticleLettersAni :");
			for(int i = 0; i < mFilenames.length; i++)
			{
				println("    " + mFilenames[i] + " : " + mDurations[i] + " sec.");
			}
		}
	}

	public void start()
	{
		println("ParticleLettersAni starting up.");

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
		        	mParticles = (Particle[])append(mParticles, new Particle(x, y, sAccel));
		      	}
		    }
		}
		println("# particles : " + mParticles.length);
	}

	public void update()
	{
		background(mBgColor);

	  if(frameCount % (5 * ZTunnel.sFps) == 0)  // every 5 s.
	  {
			println("ParticleLettersAni.update() at frame :" + frameCount);
	  }

	  // See if it's time to set a new image
	  if(frameCount >= mImageExpirationFrame)  // every 5 s.
	  {
			print("ParticleLettersAni setting new image at frame " + frameCount);
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

			mParticles = new Particle[0];  // Delete current particles.

			//go through the entire array of pixels, creating a particle for each black pixel
			for (int x = 0; x < width; x++)
			{
		    for (int y = 0; y < height; y++)
		    {
	      	if (mWords.get(x, y) == mTestColor)
	      	{
	        	mParticles = (Particle[])append(mParticles, new Particle(x, y, sAccel));
	      	}
		    }
			}
			println("# particles : " + mParticles.length);
		}

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
	  // <<<<<<<<<<<<< create a PImage from display >>>>>>>>>>>>
	  // mDisplay.sendImage(image);
	}

	public void stop()
	{
		// do nothing
	}


	public String getName()
	{
		return "ParticleLettersAni";
	}


	//returns the locaiton in pixels[] of the point (x,y)
	public int GetPixel(int x, int y)
	{
  		return(x + y * width);
	}

}
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
    mR = 0.1f;
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
 

  
  public void update(boolean  isFree)
  {
    mLocation.add(mVelocity);
    mVelocity.add(mAcceleration);

    if (!isFree)
    {
      mAngle = atan2(mGoal.y - mLocation.y, mGoal.x - mLocation.x);
      mAcceleration.x = mAccel * cos(mAngle);
      mAcceleration.y = mAccel * sin(mAngle);
    
      if (abs(mLocation.x - mGoal.x) < mVelocity.x * 3 ||
          abs(mLocation.y - mGoal.y) < mVelocity.y * 3)
      {
        mVelocity.x *= 0.8f;
        mVelocity.y *= 0.8f;
      }
    }
    else
    {
      checkEdge();
       // Our algorithm for calculating acceleration:
      PVector mouse = new PVector((width/2), (height/2));
      PVector dir = PVector.sub(mouse, mLocation);  // Find vector pointing towards mouse
      dir.normalize();      // Normalize
      dir.mult(0.2f);        // Scale 
      mAcceleration = dir;  // Set to acceleration

      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      mVelocity.add(mAcceleration);
      mVelocity.limit(mTopspeed);
      mLocation.add(mVelocity);
    }
  }

   //draws the particle on screen
   public void draw(int particleColor)
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


}
      
      
  


public class TunnelDisplay
{
	public static final int sBytesPerLed = 3;
	public static final int sBytesPerStrip = ZTunnel.sLedsPerStrip * sBytesPerLed;

	public static final int sNumStripsPerPacket = 16;
	private static final int sBufSize = sBytesPerStrip * sNumStripsPerPacket + 4 + 4;  // Strip data (471*16) + 8 byte UDP header)+ 4 bytes type + 4 bytes mSeq.
	private byte[] mBuf = new byte[sBufSize];

	private final String[]sIpaddr = {"192.168.1.177",    // stripctrl0 remote IP address
									 								 "192.168.1.178",    // stripctrl1
									 								 "192.168.1.179",    // stripctrl2
									 								 "192.168.1.180",    // stripctrl3
									 								 "192.168.1.181",    // stripctrl4
									 								 "192.168.1.182",    // stripctrl5
									 								 "192.168.1.183",    // stripctrl6
									 								 "192.168.1.184"};   // stripctrl7
	private static final int sDestPort = 6000;     // the destination port
	private static final int sSrcPort  = 6000;     // the source port
	private long mSeq;                      // tx packet mSequence number
	private UDP mUdp;  // define the UDP object

	TunnelDisplay()
	{
		mSeq = 1;                      // mSeq # starts at 1

   	for(int i= 0; i < sBufSize; i++) // set pattern in mBuf
   	{ 
     	mBuf[i] = (byte)0xFF;
   	}

   	mUdp = new UDP(this, sSrcPort);  // create a new datagram connection on port 6000
  	//udp. log( true );            // <-- print out the connection activity
  	print("UDP Buffer Size: ");
  	println(UDP.BUFFER_SIZE);

  	mUdp.listen(true);           // and wait for incoming message
	}

	public void sendImage(PImage image)
	{
		image.loadPixels();

		int ipidx = 0;     // index into array of IP addresses for strip controllers

	  for(int lineidx = 0; lineidx < ZTunnel.sNumStripsPerSystem; lineidx += sNumStripsPerPacket)
	  {
	    int pixelIdx = ZTunnel.sLedsPerStrip * lineidx;
	  
	    for(int i= 8; i < sBytesPerStrip * sNumStripsPerPacket + 8 - 1; i += 3) {
	      int curPixel = image.pixels[pixelIdx];
	      mBuf[i] = (byte) blue(curPixel);    // Blue
	      mBuf[i+1] = (byte) green(curPixel);  // Green
	      mBuf[i+2] = (byte) red(curPixel);  // Red
	    
	      pixelIdx++;
	    }  // set pattern in mBuf
	     // Put a type 0 in the first long to signify this is a Strip Data packet
	    mBuf[0] = 0;  
	    mBuf[1] = 0;
	    mBuf[2] = 0;
	    mBuf[3] = 0;
	  
	    // put a mSequence # in the next 4 bytes of mBuf (little endien)
	    mBuf[4] = (byte)(mSeq & 0xFF);
	    mBuf[5] = (byte)((mSeq & 0xFF00) >> 8);
	    mBuf[6] = (byte)((mSeq & 0xFF0000) >> 16);
	    mBuf[7] = (byte)((mSeq & 0xFF000000) >> 24);
	    mUdp.send(mBuf, sIpaddr[ipidx++], sDestPort);    // the message to send
	  }
  	mSeq++;  

	}

}

public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int sNumStripsPerSystem = 128;

	AnimationResources 	mAnimationResources;
	AnimationScheduler 	mScheduler;
	TunnelDisplay 	 		mTunnelDisplay;

	//ctor
	ZTunnel()
	{
		frameRate(sFps);
		size(sLedsPerStrip, sNumStripsPerSystem);
  	noCursor();

  	mTunnelDisplay = new TunnelDisplay();
  	mAnimationResources = new AnimationResources(mTunnelDisplay);
  	mScheduler = new AnimationScheduler(mAnimationResources);

		mScheduler.start();
	}

	public void update()
	{
		mScheduler.update();
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
