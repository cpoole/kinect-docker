#include <libfreenect2/libfreenect2.hpp>
#include <libfreenect2/frame_listener_impl.h>
#include <libfreenect2/registration.h>
#include <libfreenect2/packet_pipeline.h>
#include <libfreenect2/logger.h>

libfreenect2::Freenect2 freenect2;
libfreenect2::Freenect2Device *dev = 0;
libfreenect2::PacketPipeline *pipeline = 0;
libfreenect2::setGlobalLogger(libfreenect2::createConsoleLogger(libfreenect2::Logger::Debug));

void main(){
	if(freenect2.enumerateDevices() == 0){
		std::cout << "no device connected!" << std::endl;
		return -1;
	}
	if (serial == ""){
		serial = freenect2.getDefaultDeviceSerialNumber();
	}

	dev = freenect2.openDevice(serial, pipeline);
	
        bool enable_depth = true;
        bool enable_rgb = false;
	
	int types = 0;
	if (enable_rgb){
	  types |= libfreenect2::Frame::Color;
	}
	if (enable_depth){
	  types |= libfreenect2::Frame::Ir | libfreenect2::Frame::Depth;
	}
	libfreenect2::SyncMultiFrameListener listener(types);
	libfreenect2::FrameMap frames;
	dev->setColorFrameListener(&listener);
	dev->setIrAndDepthFrameListener(&listener);
	
	if (!dev->startStreams(enable_rgb, enable_depth)){
		return -1;
	}

	std::cout << "device serial: " << dev->getSerialNumber() << std::endl;
	std::cout << "device firmware: " << dev->getFirmwareVersion() << std::endl;

	while(!protonect_shutdown && (framemax == (size_t)-1 || framecount < framemax)){
		if (!listener.waitForNewFrame(frames, 10*1000)) { //10 seconds
		  std::cout << "timeout!" << std::endl;
		  return -1;
		}
		libfreenect2::Frame *rgb = frames[libfreenect2::Frame::Color];
		libfreenect2::Frame *ir = frames[libfreenect2::Frame::Ir];
		libfreenect2::Frame *depth = frames[libfreenect2::Frame::Depth];
		listener.release(frames);
	        dev->stop();
	        dev->close();
	}
}
