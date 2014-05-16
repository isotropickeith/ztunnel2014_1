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