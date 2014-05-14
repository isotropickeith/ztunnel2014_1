public class ZTunnel
{
	public static final int sFps = 30;  // 30 fps for this tunnel

	public static final int sLedsPerStrip = 157;
	public static final int numStripsPerSystem = 128;

	Animation sAni1;

	//ctor
	ZTunnel()
	{
		frameRate(sFps);
		size(sLedsPerStrip, numStripsPerSystem);
  		noCursor();

		sAni1 = new ParticleLettersAni();
		sAni1.start();
	}

	public void update()
	{
		sAni1.update();
	}
}