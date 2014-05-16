public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int sNumStripsPerSystem = 128;

<<<<<<< HEAD
	//Animation sAni1;
Animation smouse
=======
	Animation mAni1;
	AnimationResources mAnimationResources;
>>>>>>> FETCH_HEAD

	//ctor
	ZTunnel()
	{
		frameRate(sFps);
		size(sLedsPerStrip, sNumStripsPerSystem);
  		noCursor();

<<<<<<< HEAD
		//sAni1 = new ParticleLettersAni();
		smouse = new Particlelettershackfollowmouse();
		//sAni1.start();
		smouse.start();
=======
  		mAnimationResources = new AnimationResources();

		mAni1 = new ParticleLettersAni(mAnimationResources);
		mAni1.start();
>>>>>>> FETCH_HEAD
	}

	public void update()
	{
<<<<<<< HEAD
		//sAni1.update();
		smouse.update();
=======
		mAni1.update();
>>>>>>> FETCH_HEAD
	}
}