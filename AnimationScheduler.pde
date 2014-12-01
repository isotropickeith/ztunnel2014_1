public class AnimationScheduler
{
	AnimationResources mResources;
	int mCurAnimationIndex;
	int mAnimationExpires;

	ArrayList<Animation> mAnimations;
	Animation mCurAnimation;

	AnimationScheduler(AnimationResources resources)
	{
		mResources = resources;
		mCurAnimationIndex = 0;
		mAnimationExpires = -1;

		mAnimations = mResources.getAnimations();

	}

	public void start()
	{
		mCurAnimation = mAnimations.get(mCurAnimationIndex);
		String animationName = mCurAnimation.getName();
		int aniDuration = mResources.getAnimationDuration(animationName);
		mAnimationExpires = frameCount + (aniDuration * ZTunnel.sFps);
		mCurAnimation.start();
		println("AniSched: " + animationName + " expires " + mAnimationExpires);
	}

	public void update()
	{
		if(frameCount >= mAnimationExpires)
		{
			mCurAnimation.stop();
			mCurAnimationIndex = (mCurAnimationIndex + 1) % mAnimations.size();
			start();
		}
		else
		{
			mCurAnimation.update();
		}
	}
}