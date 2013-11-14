---
title: Bouncy Buttons in HTML+CSS
author: Andrew Ippoliti
date: 2013-11-02 22:20:40
category: html css button
tag: html css button
layout: post
---

Most buttons on web-pages have a very subtle change when you click them. I want
a button that behaves like a real button when I press it (ie it goes up and 
down).

Here is how you can achieve that effect using `box-shadow` and `margin` in css:

{% highlight css %}
.btn {
	vertical-align: middle;
	-moz-box-shadow: 0px 3px 0px #AAA;
	-webkit-box-shadow: 0px 3px 0px #AAA;
	box-shadow: 0px 3px 0px #AAA;
}
.btn:active {
	margin-top: 3px;
	margin-bottom: -3px;
	-moz-box-shadow: 0px 0px 0px #AAA;
	-webkit-box-shadow: 0px 0px 0px #AAA;
	box-shadow: 0px 0px 0px #AAA;
}

/* This is not important to the effect but I like it */
.btn {
	font-size: 1.2em;
	border-radius: 4px;
	background-color: #FFFFFF;
	border: 1px solid #CCC;
}
{% endhighlight %}

<style type='text/css'>
.btn {
	vertical-align: middle;
	-moz-box-shadow: 0px 3px 0px #AAA;
	-webkit-box-shadow: 0px 3px 0px #AAA;
	box-shadow: 0px 3px 0px #AAA;
}
.btn:active {
	margin-top: 3px;
	margin-bottom: -3px;
	-moz-box-shadow: 0px 0px 0px #AAA;
	-webkit-box-shadow: 0px 0px 0px #AAA;
	box-shadow: 0px 0px 0px #AAA;
}
.btn {
	font-size: 1.2em;
	border-radius: 4px;
	background-color: #FFFFFF;
	border: 1px solid #CCC;
}
.btn-success { background-color: #88FF88; }
.btn-primary { background-color: #88AAFF; }
.btn-warning { background-color: #FFFF88; }
.btn-critical { background-color: #FF8888; }
</style>

You can apply the `btn` class to anything that you want to look like a button.
Of course, here are some <button class='btn'>buttons</button> for you to
<button class='btn btn-primary'>play</button> with:

<button class='btn btn-success'>Success!</button>
<button class='btn btn-warning'>Uh-oh, look out!</button>
<button class='btn btn-critical'>DON'T PANIC</button>

