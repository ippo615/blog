---
title: Resize and Preserve Aspect Ratio Algorithm
author: Andrew Ippoliti
date: 2013-11-13 16:48:44
category: image processing resize scale aspect ratio algorithm javascript
tag: image processing resize scale aspect ratio algorithm javascript
layout: post
---

I find myself needing to resize things while preserving the original aspect
ratio quite frequently but I always forget my algorithm and then waste a lot of
time fixing my *new* buggy implementation. This post should remedy that.

First the original width and height of the thing-to-be-scaled  will be called
`xSize` and `ySize`, respectively. The amount of space we want it maximally
fill will be called `xGoal` and `yGoal`. Our task is to find `scale` so that 
`xSize*scale <= xGoal` and `ySize*scale <= yGoal`. In javascript that looks
like:

<div>{% highlight js %}
function findScale(xSize,ySize,xGoal,yGoal){
	// We'll either to match `xSize` to `xGoal` or `ySize` to `yGoal` so
	// compute a scale for each.
	var xScale = xGoal / xSize;
	var yScale = yGoal / ySize;

	// If xScale makes it too tall we'll have to use yScale
	// and if yScale makes it too wide we'll have to use xScale
	if( xScale * ySize > yGoal ){
		return yScale;
	}else{
		return xScale;
	}
}
{% endhighlight %}</div>

No code is complete without <del>unit tests</del> examples:

<div>{% highlight js %}
console.info( findScale(32,32,64,64) === 2 );
console.info( findScale(32,10,64,64) === 2 );
console.info( findScale(10,32,64,64) === 2 );

console.info( findScale(10,10,128,100) === 10 );
console.info( findScale(10,10,100,128) === 10 );

console.info( findScale(100,100,10,6) === 0.06 );
console.info( findScale(100,100,77,100) === 0.77 );
{% endhighlight %}</div>

That was much simpler that my original implementations. I wonder what was 
wrong with me when I wrote them...

