---
title: Installing OpenCV in Ubuntu 13.04
author: Andrew Ippoliti
date: 2013-11-01 22:50:28
category: opencv ubuntu install
tag: opencv ubuntu install
layout: post
---

OpenCV is used for doing all sorts of things with computer vision. It can be
installed in Ubuntu, this explains how.

I wanted a script that I could copy and paste to install OpenCV; however, none
of them worked. Here are the shell commands I ran to install it. It will
download and build the latest sources for you:

{% highlight bash %}
# Install dependencies
sudo apt-get install build-essential
sudo apt-get install cmake
sudo apt-get install git
sudo apt-get install libgtk2.0-dev
sudo apt-get install pkg-config
sudo apt-get install python-dev
sudo apt-get install python-numpy
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install libjpeg-dev libpng-dev libtiff-dev libjasper-dev

# Create a working area and get the source
mkdir -p ~/opencv
cd ~/opencv
git clone https://github.com/Itseez/opencv.git

# Build the downloaded sources
mkdir release
cd release/
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
{% endhighlight %}

You should now have an `opencv` directory in your home directory. You can make
sure it worked by running the samples in the `opencv/samples` directory.

If you run into some trouble, the [OpenCV installation guide](http://docs.opencv.org/doc/tutorials/introduction/linux_install/linux_install.html)
is a great reference.

