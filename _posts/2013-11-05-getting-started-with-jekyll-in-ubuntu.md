---
layout: post
title:  "Getting Started with Jekyll in Ubuntu"
date:   2013-11-05 22:00:00
categories: jekyll ubuntu
author: Andrew Ippoliti
---

Jekyll can convert markdown files into a static website. I'll show you how to
get setup with Jekyll in Ubuntu 13.04

## Installing

First we need to install ruby and ruby gems and the ruby development library:

	sudo apt-get install ruby rubygems ruby1.9.1-dev

And then use gem to install jekyll:

	sudo gem install jekyll
	
Add ruby gems to your system path (otherwise your system can't find `jekyll`):

	export PATH=/var/lib/gems/1.8/bin:$PATH

## Hello World

Now we need to create a blog:

	jekyll new myBlog
	
And then make a post:

	cd myBlog/_posts
	gedit $(date +%Y-%m-%d)-title

When you are done editting your post you can save it and then serve the page:

	cd ..
	jeckyll serve

Happy blogging!

