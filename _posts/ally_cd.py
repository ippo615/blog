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

