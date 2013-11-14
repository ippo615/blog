---
title: Sending Gmail in Python
author: Andrew Ippoliti
date: 2013-11-11 20:56:47
category: email gmail python smtp
tag: email gmail python smtp
layout: post
---

Python has a built in smtp client. You can use it to send emails from your 
Gmail account with just a few lines of code.

{% highlight python %}
import smtplib

# You need to supply your user name and password to login
login = 'userName@gmail.com'
password = 'yourPassword'

# I'm sending myself a message but you can send to/from other addresses
from_address = login
to_address = login

# This is the real important stuff
server = smtplib.SMTP('smtp.gmail.com:587')
server.starttls()
server.login(login,password)
server.sendmail(from_address, to_address, 'Hello world!')
server.quit()

{% endhighlight %}

I would imagine that you can use any smtp server (not just gmail) but I've
only tried it with my gmail account.

That code requires the [smtplib](http://docs.python.org/2/library/smtplib.html)
which comes with python. My example is very minimal, you'll also want to check
out the [email examples](http://docs.python.org/2/library/email-examples.html)
for better ways to construct your messages.

