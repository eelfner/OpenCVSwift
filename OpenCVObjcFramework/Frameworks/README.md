## Adding OpenCV

A copy of the __opencv2.framework__ will need to be added to this project to build. See notes and links below.

### Versions of OpenCV
I have tried several versions of OpenCV with different results. Here are my findings.
* [v3.1](http://sourceforge.net/projects/opencvlibrary/files/opencv-ios/3.1.0/opencv2.framework.zip/download): Works in all Simulators, but does not appear to work on devices because does not include object code for 64 bit arch.
* [v3.0](http://sourceforge.net/projects/opencvlibrary/files/opencv-ios/3.0.0/opencv2.framework.zip/download): Works in Simulators tested, but does not work on my device. Seems it has some absolute paths in the build. See [this](http://stackoverflow.com/q/26978806/4305146).
* [v2.4](https://sourceforge.net/projects/opencvlibrary/files/opencv-ios/2.4.11/opencv2.framework.zip/download): Had other issues related to header imports. Did not investigate further.

After including an OpenCV library referenced above, this code will probably __not__ run on a physical device! Perhaps someone has built a usable framework, or you can do it yourself. Of I might do it later...

### Switching versions of OpenCV
To use a different versioned framework, you need to download and replace `opencv2.framework`. I suggest 1) In project explorer, OpenCVObjectFramwork/Frameworks delete opencv2.framework, to trash. 2) Download from links above new version and drag to Frameworks group. 3) If going to v2.4, update import in stitching.cpp. 4) Clean and build.
