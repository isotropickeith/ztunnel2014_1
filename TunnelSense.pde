import SimpleOpenNI.*;

public class TunnelSense
{
	PApplet mContext;
	ZTunnel mTunnel;
	int mNumUsers;
	SimpleOpenNI mKinect;
	boolean mEnabled;

	TunnelSense(PApplet context, ZTunnel tunnel)
	{
		mContext = context;
		mTunnel = tunnel;
		mNumUsers = 0;
		mKinect = new SimpleOpenNI(mContext);
	  if(mKinect.isInit() == false)
	  {
	    println("Can't init SimpleOpenNI, maybe the Kinect is not connected!"); 
	    //exit();
	    mEnabled = false;
	    return;  
	  }
	  else
	  {
	    mEnabled = true;
	    println("Kinect initialized.");
	  }
	  // disable mirror
	  mKinect.setMirror(false);

	  // enable depthMap generation 
	  mKinect.enableDepth();

	  // enable skeleton generation for all joints
	  mKinect.enableUser();

	  println("...Exiting TunnelSAense:ctor...");
	}


	public void update()
	{
		if(mEnabled)
		{
	  	mKinect.update();

		  int[] userList = mKinect.getUsers();
		  if(mNumUsers != userList.length)
		  {
		    mNumUsers = userList.length;
		    println("Users = " + mNumUsers);
		  }
		}
	}


	public int getNumUsers()
	{
		return mNumUsers;
	}

	public boolean isEnabled()
	{
		return mEnabled;
	}

	public PApplet getContext()
	{
		return mContext;
	}

}