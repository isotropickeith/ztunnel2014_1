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