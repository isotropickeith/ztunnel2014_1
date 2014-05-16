public class AnimationResources
{
	XML mXml;
	XML[] mAnimations;

	//constructor
	AnimationResources()
	{
		mXml = loadXML("TunnelCfg.xml");
		
		mAnimations = mXml.getChildren("animation");
		if(mAnimations.length == 0)
		{
			println("No animations! - ERROR");
		}
	}

	public String[] getFiles(String animationName)
	{
		String[] fileNames = {};

		for(int i = 0; i < mAnimations.length; i++)
		{
			println("DEBUG: Animation " + i + ": " + mAnimations[i].getString("id"));
			if(mAnimations[i].getString("id").equals(animationName))
			{
				XML[] files = mAnimations[i].getChildren("imageFile");
				println("   #files = " + files.length);
				for(int j = 0; j < files.length; j++)
				{
					String fileName = files[j].getContent();
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

}