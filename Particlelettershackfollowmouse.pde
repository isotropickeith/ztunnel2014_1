/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34101*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* Andy Wallace
 * Particle Letters
 * 2010
 *
 * Click to have the particles form the word
 */
 
Particlevector[] particles=new Particlevector[0];
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

void start()
{
  frameRate(fps);
   Goal = new PVector((random(width)),(random(height)));
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

void Update(){
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
 
 
