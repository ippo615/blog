---
title: Automatic Ally CD Rate Checking
author: Andrew Ippoliti
date: 2013-11-12 11:01:58
category: bank cd rate python automatic investing 
tag: bank cd rate python automatic investing 
layout: post
---

Alley bank has a 'Raise Your Rate' CD which lets you increase the APR on your
CD if their rate goes up. Checking their rates everyday is tedious, here is 
how to automate it.

The following script is written in python. It parses Ally's rate RSS feed and
alerts you if the rate is higher than the one you specify.

{% highlight python %}
#!/usr/bin/python

import urllib, xml.dom.minidom, re

def getAllyRate(rateIndex):
	"""Returns the current rate (APR) of your ally Raise Your Rate CD."""

	# Download the rate information from the website and parse it into a DOM
	rssFeed = urllib.urlopen("http://www.ally.com/rss/rates.xml")
	rssData = xml.dom.minidom.parse(rssFeed)

	# The overall structure looks like:
	# <item>...</item>
	# <item>
	#   <title>Raise Your Rate</title>
	#   <link>http://www.ally.com/bank/raise-your-rate-cd/</link>
	#   <pubDate>Mon, 11 Nov 2013 07:31:08 CST</pubDate>
	#   <guid isPermaLink="false">http://www.ally.com/bank/raise-your-rate-cd/?20131111</guid>
	#   <description><![CDATA[
	#     <!-- lots of stuff including a table with the rates -->
	#   </description>
	# </item>
	# <item>...</item>

	# Find the title with 'Raise Your Rate'
	titles = rssData.getElementsByTagName('title')
	myTitle = None
	for title in titles:
		if title.firstChild.nodeValue == 'Raise Your Rate':
			myTitle = title
			break

	# Get the description node
	myDescription = myTitle.parentNode.getElementsByTagName('description')[0]

	# minidom does not support CDATA sections so we cannot parse it and use DOM
	# methods. I'll use a regular expression to find the APR information.
	# Currently the 2-yr rate is listed first (index=0), the 4-yr is index=1.
	tdRegex = re.compile('<td class="apr">([^<]*?)</td>')
	matches = tdRegex.findall( myDescription.firstChild.nodeValue )
	return float( matches[rateIndex].replace('%','') )

def zenityAlert(message):
	import subprocess
	command = ['zenity','--notification','--text=\'%s\''%message]
	subprocess.Popen(command).communicate()

def sendGmail(message):
	import smtplib
	login = 'yourName@gmail.com'
	password = 'yourPassword'
	server = smtplib.SMTP('smtp.gmail.com:587')
	server.starttls()
	server.login(login,password)
	server.sendmail(login, login, message)
	server.quit()

if __name__ == '__main__':
	oldRate = 1.04
	newRate = getAllyRate(0)
	rateNotify = zenityAlert # or sendGmail

	if newRate > oldRate:
		rateNotify('Your rate has increased from %s to %s'%(oldRate,newRate))

{% endhighlight %}

You need to configure the script so it matches your situation. First, change
the `oldRate` to whatever your opening rate was (note I'm checking APR not
APY).

Second, if you have a 2 year CD: leave `getAllyRate(0)` alone. If you have a 4
year CD: change it to `getAllyRate(1)`. If Ally changes the structure of their
RSS feed this may no longer work.

Third, you can change the way you are notified: either with a `zenity` popup or
with email. If you choose the email option be sure to set the correct `login`
and `password`.

Finally, I would use cron to run this daily. Download this script, call it
`check-cd.py` then run:

	chmod +x check-cd.py
	mv check-cd.py /etc/cron.daily/

That will make it executable and put it in your daily cron folder so it runs
everyday.

