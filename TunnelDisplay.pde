import hypermedia.net.*;

public class TunnelDisplay
{
	public static final int sBytesPerLed = 3;
	public static final int sBytesPerStrip = ZTunnel.sLedsPerStrip * sBytesPerLed;

	public static final int sNumStripsPerPacket = 16;
	private static final int sBufSize = sBytesPerStrip * sNumStripsPerPacket + 4 + 4;  // Strip data (471*16) + 8 byte UDP header)+ 4 bytes type + 4 bytes mSeq.
	private byte[] mBuf = new byte[sBufSize];

	private final String[]sIpaddr = {"192.168.1.177",    // stripctrl0 remote IP address
									 								 "192.168.1.178",    // stripctrl1
									 								 "192.168.1.179",    // stripctrl2
									 								 "192.168.1.180",    // stripctrl3
									 								 "192.168.1.181",    // stripctrl4
									 								 "192.168.1.182",    // stripctrl5
									 								 "192.168.1.183",    // stripctrl6
									 								 "192.168.1.184"};   // stripctrl7
	private static final int sDestPort = 6000;     // the destination port
	private static final int sSrcPort  = 6000;     // the source port
	private long mSeq;                      // tx packet mSequence number
	private UDP mUdp;  // define the UDP object

	TunnelDisplay()
	{
		mSeq = 1;                      // mSeq # starts at 1

   	for(int i= 0; i < sBufSize; i++) // set pattern in mBuf
   	{ 
     	mBuf[i] = (byte)0xFF;
   	}

   	mUdp = new UDP(this, sSrcPort);  // create a new datagram connection on port 6000
  	//udp. log( true );            // <-- print out the connection activity
  	print("UDP Buffer Size: ");
  	println(UDP.BUFFER_SIZE);

  	mUdp.listen(true);           // and wait for incoming message
	}

	public void sendImage(PImage image)
	{
		image.loadPixels();

		int ipidx = 0;     // index into array of IP addresses for strip controllers

	  for(int lineidx = 0; lineidx < ZTunnel.sNumStripsPerSystem; lineidx += sNumStripsPerPacket)
	  {
	    int pixelIdx = ZTunnel.sLedsPerStrip * lineidx;
	  
	    for(int i= 8; i < sBytesPerStrip * sNumStripsPerPacket + 8 - 1; i += 3) {
	      color curPixel = image.pixels[pixelIdx];
	      mBuf[i] = (byte) blue(curPixel);    // Blue
	      mBuf[i+1] = (byte) green(curPixel);  // Green
	      mBuf[i+2] = (byte) red(curPixel);  // Red
	    
	      pixelIdx++;
	    }  // set pattern in mBuf
	     // Put a type 0 in the first long to signify this is a Strip Data packet
	    mBuf[0] = 0;  
	    mBuf[1] = 0;
	    mBuf[2] = 0;
	    mBuf[3] = 0;
	  
	    // put a mSequence # in the next 4 bytes of mBuf (little endien)
	    mBuf[4] = (byte)(mSeq & 0xFF);
	    mBuf[5] = (byte)((mSeq & 0xFF00) >> 8);
	    mBuf[6] = (byte)((mSeq & 0xFF0000) >> 16);
	    mBuf[7] = (byte)((mSeq & 0xFF000000) >> 24);
	    mUdp.send(mBuf, sIpaddr[ipidx++], sDestPort);    // the message to send
	  }
  	mSeq++;  

	}

}