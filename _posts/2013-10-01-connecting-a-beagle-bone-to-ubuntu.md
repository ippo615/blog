---
title: Connecting a Beagle Bone to Ubuntu
date: 2013-10-01 23:31:37
category: ubuntu beaglebong
tag: ubuntu beaglebong
layout: post
author: Andrew Ippoliti
---

If you have a spare ethernet port you can connect a beaglebone directly to
your computer via an ethernet cable. Here's how to do it on Ubuntu.

Install dnsmasq on your computer. This was already installed in 13.04:

    sudo apt-get install dnsmasq-base

Make sure your regular internet connection is configured and working (ie you
are connected to the internet over wifi).

For your other connection (ie your 'wired' ethernet connection that you will
connect to the beaglebone), select "Shared to other computers" in the
IPv4 Settings tab.

Connect the BeagleBone and your computer with an ethernet cable.

You need address of the BeagleBone to connect to it. To find it, we'll search
through the system log for 'dns' and look for the beaglebone:

    grep 'dns' /var/log/syslog

You should see several lines of output. In this example my beaglebone was
given the IP address: `10.42.0.73` The one that has the address looks like:

    {DATE/NAME} dnsmasq-dhcp[2905]: DHCPACK(eth0) 10.42.0.73 90:59:af:51:12:89 beaglebone

You can connect to your beagle bone through ssh (or some other means):

	ssh user@10.42.0.73

For some nice pictures of Ubuntu's internet connection sharing check out:
https://jeremy.visser.name/2009/03/simple-internet-connection-sharing-with-networkmanager/


