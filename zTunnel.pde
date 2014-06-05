public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int sNumStripsPerSystem = 128;

	AnimationResources 	mAnimationResources;
	AnimationScheduler 	mScheduler;
	TunnelDisplay 	 		mTunnelDisplay;
	TunnelSense         mTunnelSense;

	//ctor
	ZTunnel(PApplet context)
	{
		frameRate(sFps);
		size(sLedsPerStrip, sNumStripsPerSystem);
  	noCursor();

  	mTunnelDisplay = new TunnelDisplay();
  	mTunnelSense = new TunnelSense(context, this);
  	mAnimationResources = new AnimationResources(mTunnelDisplay, mTunnelSense);
  	mScheduler = new AnimationScheduler(mAnimationResources);

		mScheduler.start();
	}

	public void update()
	{
		mTunnelSense.update();
		mScheduler.update();
	}
}