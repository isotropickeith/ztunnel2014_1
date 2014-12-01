import SimpleOpenNI.*;
//import codeanticode.gsvideo.*;
import processing.video.*;

//import SimpleOpenNI.*;

ZTunnel gTunnel;

void setup()
{
  gTunnel = new ZTunnel(this);

}

void draw()
{
  gTunnel.update();

}


void mousePressed()
{
  // Invoke method of EventDispatcher
}
void mouseReleased()
{
  // Invoke method of EventDispatcher
}

// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  //println("\tstart tracking skeleton");
  
  //context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

// Called every time a new frame is available to read
void movieEvent(Movie m)
{
  m.read();
}

