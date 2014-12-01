//import codeanticode.gsvideo.*;

public class MovieAni implements Animation
{
	static final int   sDefaultImageTime = 60;  // load new image interval in seconds

	String              mName;
	AnimationResources  mResources;		// AnimationResources object
	TunnelDisplay		mDisplay;		// The display bject on which to paint
	TunnelSense			mSense;          // Sensors in the tunnel

	String[] mFilenames;				// Array of Filenames for images to display
	int[]    mDurations;				// Array of durations for images to display
	Movie    mCurMovie;					// Current Movie playing
	int      mCurFileIndex = 0;			// index into mFileNames for the current image
	int      mImageExpirationFrame;
	int      mStateChangeExpirationFrame = 0;
	boolean  mOccupied = false;     // determines which movie to play
	int 	 mMinStatePeriod = 13;  // 13 sec. preriod for free/not free states
	int      mNumUsers = 0;         // Assume 0 peeps in tunnel to start

	static final int sFreePeriod = 13;  // 13 sec. preriod for free/not free states

	//constructor
	MovieAni(String             name,
		     AnimationResources resources,
			 TunnelDisplay      display,
			 TunnelSense        sense)
	{
		mName = name;
		mResources = resources;
		mDisplay = display;
		mSense = sense;

		mFilenames = mResources.getFiles(mName);
		mDurations = mResources.getFileDurations(mName);
		if(mFilenames.length == 0)
		{
			println("No Resources for " + mName + " - FAIL");
			exit();
		}
		else
		{
		  	println("Resource files for " + mName + " :");
			for(int i = 0; i < mFilenames.length; i++)
			{
				println("    " + mFilenames[i] + " : " + mDurations[i] + " sec.");
			}
		}
		if((mFilenames.length % 2) != 0)  // Make sure there are even # of files
		{
			println("Odd number of files for " + mName + " - FAIL");
			exit();
		}
	}

	public void start()
	{
		println(mName + " starting up.");

		// Determine our starting state occupied or not and whether we can use TunnelSense
		mOccupied = false;
		if(mSense.isEnabled())
		{
			mNumUsers = mSense.getNumUsers();
			if(mNumUsers > 0)
			{
				mOccupied = true;
			}
		}

		mStateChangeExpirationFrame = frameCount + (mMinStatePeriod * ZTunnel.sFps);

		mCurFileIndex = 0;

		if(mOccupied)
		{
			mCurFileIndex++;	// We use odd indicies for occupied movies
		}

		mCurMovie = new Movie(mSense.getContext(), mFilenames[mCurFileIndex]); //451x380

		if(mDurations[mCurFileIndex] != -1)
		{
			mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
		}
		else
		{
			mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
		}

		mCurMovie.loop();
	}

	public void update()
	{
  		image(mCurMovie, 0, 0, ZTunnel.sLedsPerStrip, ZTunnel.sNumStripsPerSystem);

    	// Send the screen image to the Tunnel for display
    	///////TEST/////mDisplay.sendImage();

	  	if(frameCount % (5 * ZTunnel.sFps) == 0)  // every 5 s.
	  	{
			println(mName + ".update() at frame :" + frameCount);
	  	}

	  	// See if it's time to set a new movie
	  	//if(frameCount >= mImageExpirationFrame)
	  	//{
			// Stop current movie
		//	mCurMovie.noLoop();
		//	mCurMovie.stop();
			// Set up new movie
		//	print("MovieAni setting new movie at frame " + frameCount);
		//	mCurFileIndex = (mCurFileIndex + 2) % mFilenames.length;  // 2 cuz they come in pairs
		//	println(": " + mFilenames[mCurFileIndex] + " for " + mDurations[mCurFileIndex] + " sec.");
		//	mCurMovie = new Movie(mSense.getContext(), mFilenames[mCurFileIndex]); //451x380

		//	if(mDurations[mCurFileIndex] != -1)
		//	{
		//		mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
		//	}
		//	else
		//	{
		//		mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
		//	}

		//	mCurMovie.loop();
		//}

		if(frameCount >= mStateChangeExpirationFrame)
		{
			if(mSense.isEnabled())
			{
				int newUserCount = mSense.getNumUsers();
				if(mNumUsers != newUserCount)
				{
					if(newUserCount == 0 || mNumUsers == 0)
					{
						mOccupied = !mOccupied;
						mStateChangeExpirationFrame = frameCount + (mMinStatePeriod * ZTunnel.sFps);
						println("Occupied state change - # users = " + newUserCount);
						if(mOccupied)
						{
							mCurFileIndex++;
						}
						else
						{
							mCurFileIndex--;
						}
						// Stop current movie
						mCurMovie.noLoop();
						mCurMovie.stop();
						// Set up new movie
						print(mName + " setting new movie at frame " + frameCount);
						println(": " + mFilenames[mCurFileIndex] + " for " + mDurations[mCurFileIndex] + " sec.");
						mCurMovie = new Movie(mSense.getContext(), mFilenames[mCurFileIndex]); //451x380
						if(mDurations[mCurFileIndex] != -1)
						{
							mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
						}
						else
						{
							mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
						}

						mCurMovie.loop();

					}
					mNumUsers = newUserCount;
				}
			}
			else   // No tunnel sense, timer only
			{
				mOccupied = !mOccupied;
				//mStateChangeExpirationFrame = frameCount + (mMinStatePeriod * ZTunnel.sFps);
				println("Occupied state change - timer ");
				if(mOccupied)
				{
					mCurFileIndex++;
				}
				else
				{
					mCurFileIndex--;
				}
				// Stop current movie
				mCurMovie.noLoop();
				mCurMovie.stop();
				// Set up new movie
				print(mName + " setting new movie at frame " + frameCount);
				print(": mCurFileIndex = " + mCurFileIndex);
				println(" : " + mFilenames[mCurFileIndex] + " for " + mDurations[mCurFileIndex] + " sec.");
				mCurMovie = new Movie(mSense.getContext(), mFilenames[mCurFileIndex]); //451x380
				if(mDurations[mCurFileIndex] != -1)
				{
					mImageExpirationFrame = frameCount + (mDurations[mCurFileIndex] * ZTunnel.sFps);
				}
				else
				{
					mImageExpirationFrame = frameCount + (sDefaultImageTime * ZTunnel.sFps);
				}

				mCurMovie.loop();
				mStateChangeExpirationFrame = frameCount + (mMinStatePeriod * ZTunnel.sFps);
			}
		}
	}

	public void stop()
	{
		// Stop current movie
		mCurMovie.noLoop();
		mCurMovie.stop();
	}


	public String getName()
	{
		return mName;
	}

}
