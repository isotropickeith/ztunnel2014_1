public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int sNumStripsPerSystem = 128;

	Animation mAni1;
	AnimationResources mAnimationResources;

	//ctor
	ZTunnel()
	{
		frameRate(sFps);
		size(sLedsPerStrip, sNumStripsPerSystem);
  		noCursor();

  		mAnimationResources = new AnimationResources();

		mAni1 = new ParticleLettersAni(mAnimationResources);
		mAni1.start();
	}

	public void update()
	{
		mAni1.update();
	}
}