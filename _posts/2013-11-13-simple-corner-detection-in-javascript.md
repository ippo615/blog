---
title: Simple Corner Detection in JavaScript
author: Andrew Ippoliti
date: 2013-11-13 22:53:46
category: image processing simple corner detection JavaScript
tag: image processing simple corner detection JavaScript
layout: post
---

I wanted to code a corner detection algorithm but the Wikipedia entry on
corner detection was too complicated for me. I decided to do it my own way.

You can read the
[Wikipedia entry on corner detection](https://en.wikipedia.org/wiki/Corner_detection)
if you want some additional information.

What is a corner? It is a point which is most unlike its neighbors. That means
there is a big difference between it and its neighbors. Since we're talking
about images that means color distance:

<div>{% highlight js %}
function colorDistance(r1,g1,b1,r2,g2,b2){
	var dr = r1 - r2;
	var dg = g1 - g2;
	var db = b1 - b2;
	return Math.sqrt( dr*dr + dg*dg + db*db );
}
{% endhighlight %}</div>

We need to compute the total distance between a central pixel at `(x,y)` and
the pixels that are within `n` pixels of `x` or `y`:

<div>{% highlight js %}
function sumDistance(imageData,x,y,n){
	var pixels = imageData.data,
	    imageSizeX = imageData.width,
	    imageSizeY = imageData.height;

	// position information
	var px, py, i, j, pos;
	
	// distance accumulator
	var dSum = 0;
	
	// colors
	var r1 = pixels[4*(imageSizeX*y+x) + 0];
	var g1 = pixels[4*(imageSizeX*y+x) + 1];
	var b1 = pixels[4*(imageSizeX*y+x) + 2];
	var r2, g2, b2;
	
	for( i=-n; i<=n; i+=1 ){
		for( j=-n; j<=n; j+=1 ){

			// Tile the image if we are at an end
			px = (x+i) % imageSizeX;
			px = (px>0)?px:-px;
			py = (y+j) % imageSizeY;
			py = (py>0)?py:-py;

			// Get the colors of this pixel
			pos = 4*(imageSizeX*py + px);
			r2 = pixels[pos+0];
			g2 = pixels[pos+1];
			b2 = pixels[pos+2];

			// Work with the pixel
			dSum += colorDistance(r1,g1,b1,r2,g2,b2);
		}
	}

	return dSum;
}
{% endhighlight %}</div>

But we don't just need to compute that for 1 pixel, we need to compute that
"distance" for every pixel in the image:

<div>{% highlight js %}
function computeDistanceData(imageData,n){
	var pixels = imageData.data,
	    imageSizeX = imageData.width,
	    imageSizeY = imageData.height;

	var x,y;
	var data = [];
	for( x=0; x<imageSizeX; x+=1 ){
		for( y=0; y<imageSizeY; y+=1 ){
			data.push( {
				x: x,
				y: y,
				d: sumDistance(imageData,x,y,n)
			} );
		}
	}

	return data;
}
{% endhighlight %}</div>

We now have the distance metric for every pixel in the image! Now we want to
sort that array by the distance metric value we computed. Luckily JavaScript
has a built-in sort function, I just need to specify how to compare stuff:

<div>{% highlight js %}
function byDecreasingD(a,b){
	return b.d - a.d;
}
{% endhighlight %}</div>

To tie everything together, I'll make a function which gets the image data from
a canvas, runs the algorithm and returns the maximum points:

<div>{% highlight js %}
function findCorners(canvas,apertureSize,numPoints){
	// Get the raw pixel data from the canvas
	var context = canvas.getContext('2d');
	var imageData = context.getImageData(0,0,canvas.width,canvas.height);

	// Compute and return the results
	var results = computeDistanceData(imageData,apertureSize);	
	return results.sort(byDecreasingD).slice(0,numPoints);	
}
{% endhighlight %}</div>

Check it out below (click for a new sample):

<div style="text-align:center;">
	<canvas id="canvasExample" width="320" height="320" ></canvas>
</div>

I think it works pretty well! If you want to visualize the steps check the
images below. The image on the left is the "original" image with the detected
corners highlighted. The image on the right is a plot of the result of the
`sumDistance` function for each pixel. Lighter pixels are more unlike their
neighbors while darker pixels are more similar to their neighbors. You can
click them for new examples.

<div style="text-align:center;">
	<canvas id="canvasExample2" width="240" height="240" ></canvas>
	<span style="width:32px;"> </span>
	<canvas id="canvasExample3" width="240" height="240" ></canvas>
</div>

How well does this code scale? It depends on the size of the image and the
size of the "aperture". For an aperture of size `n` there are `(2*n+1)^2`
distance computations per pixel. If the image is `w` by `h` then that's
`w*h*(2*n+1)^2` distance operations (for `n=1` that's `w*h*9` operations).
There is also the sorting of `w*h` elements... It *feels* spiffy in my
browser but I'd like something that only requires `w*h*1` operations :-P

<script type="text/javascript">
function colorDistance(r1,g1,b1,r2,g2,b2){
	var dr = r1 - r2;
	var dg = g1 - g2;
	var db = b1 - b2;
	return Math.sqrt( dr*dr + dg*dg + db*db );
}
function sumDistance(imageData,x,y,n){
	var pixels = imageData.data,
	    imageSizeX = imageData.width,
	    imageSizeY = imageData.height;

	// position information
	var px, py, i, j, pos;
	
	// distance accumulator
	var dSum = 0;
	
	// colors
	var r1 = pixels[4*(imageSizeX*y+x) + 0];
	var g1 = pixels[4*(imageSizeX*y+x) + 1];
	var b1 = pixels[4*(imageSizeX*y+x) + 2];
	var r2, g2, b2;
	
	for( i=-n; i<=n; i+=1 ){
		for( j=-n; j<=n; j+=1 ){

			// Tile the image if we are at an end
			px = (x+i) % imageSizeX;
			px = (px>0)?px:-px;
			py = (y+j) % imageSizeY;
			py = (py>0)?py:-py;

			// Get the colors of this pixel
			pos = 4*(imageSizeX*py + px);
			r2 = pixels[pos+0];
			g2 = pixels[pos+1];
			b2 = pixels[pos+2];

			// Work with the pixel
			dSum += colorDistance(r1,g1,b1,r2,g2,b2);

			// console.info(pos+'['+i+','+j+']: '+r2+','+g2+','+b2);
		}
	}

	return dSum;
}
function computeDistanceData(imageData,n){
	var pixels = imageData.data,
	    imageSizeX = imageData.width,
	    imageSizeY = imageData.height;

	var x,y;
	var data = [];
	for( x=0; x<imageSizeX; x+=1 ){
		for( y=0; y<imageSizeY; y+=1 ){
			data.push( {
				x: x,
				y: y,
				d: sumDistance(imageData,x,y,n)
			} );
		}
	}

	return data;
}
function byDecreasingD(a,b){
	return b.d - a.d;
}
function findCorners(canvas,apertureSize,numPoints){
	// Get the raw pixel data from the canvas
	var context = canvas.getContext('2d');
	var imageData = context.getImageData(0,0,canvas.width,canvas.height);

	// Compute and return the results
	var results = computeDistanceData(imageData,apertureSize);	
	return results.sort(byDecreasingD).slice(0,numPoints);	
}

function drawIntensity(canvas,apertureSize,results){
	var context = canvas.getContext('2d');
	var imageData = context.getImageData(0,0,canvas.width,canvas.height);

	// Draw the intensity values at each pixel
	var scale = Math.pow(apertureSize*2+1,2);
	var x,y,pos,val,i,l=results.length;
	for( i=0; i<l; i+=1 ){
		x = results[i].x;
		y = results[i].y;
		pos = 4*(canvas.width*y+x);
		val = results[i].d / (9);
		imageData.data[pos+0] = val;
		imageData.data[pos+1] = val;
		imageData.data[pos+2] = val;
	}
	context.putImageData(imageData,0,0);
}

function circleResults(canvas,results){
	var context = canvas.getContext('2d');

	var i,x,y,l=results.length;
	context.strokeStyle = "1px solid #000";
	for( i=0; i<l; i+=1 ){
		x = results[i].x;
		y = results[i].y;
		context.strokeRect(x-2,y-2,4,4);
		context.strokeRect(x-2,y-2,4,4);
		// console.info( results[i].d );
	}
}

function splatterCanvas(canvas){
/// Adds noise to `canvas`.
	var context = canvas.getContext('2d');
	var imageData = context.getImageData(0,0,canvas.width,canvas.height);
	var pixels = imageData.data,
	    imageSizeX = imageData.width,
	    imageSizeY = imageData.height,
	    nPixels = imageSizeX * imageSizeY;

	for( var i=0; i<nPixels*4; i+=4 ){
		pixels[i+0] += Math.random()*64;
		pixels[i+1] += Math.random()*64;
		pixels[i+2] += Math.random()*64;
		pixels[i+3] = 255;
	}

	context.putImageData(imageData,0,0);
}

function randomRectangles(canvas,nRectangles){
/// Draws `nRectangles` rectangles randomly placed and colored on `canvas`.
	var r,g,b,x,y,w,h,i;
	var context = canvas.getContext('2d');
	for( i=0; i<nRectangles; i+=1 ){
		r = Math.round(Math.random()*255);
		g = Math.round(Math.random()*255);
		b = Math.round(Math.random()*255);
		context.fillStyle = 'rgb('+r+','+g+','+b+')';
		x = Math.floor(Math.random()*canvas.width);
		w = Math.floor(Math.random()*canvas.width);
		y = Math.floor(Math.random()*canvas.height);
		h = Math.floor(Math.random()*canvas.height);
		context.fillRect(x,y,w,h);
	}
}

document.getElementById("canvasExample").onclick = function(){
	var canvas = document.getElementById("canvasExample");
	canvas.width = canvas.width;
	canvas.getContext('2d').fillStyle='white';
	canvas.getContext('2d').fillRect(0,0,canvas.width,canvas.height);
	randomRectangles(canvas,100);
	//splatterCanvas(canvas);
	//canvas.getContext('2d').fillStyle='red';
	//canvas.getContext('2d').fillRect(32,32,64,64);

	/*
	console.info(sumDistance(
		canvas.getContext('2d').getImageData(0,0,canvas.width,canvas.height),
		0,0,1
	));
	console.info(sumDistance(
		canvas.getContext('2d').getImageData(0,0,canvas.width,canvas.height),
		32,32,1
	));
	*/
	var corners = findCorners(canvas,1,100);
	circleResults(canvas,corners);

};
document.getElementById("canvasExample").onclick();

function showSteps(){
	var canvas1 = document.getElementById("canvasExample2");
	var canvas2 = document.getElementById("canvasExample3");

	// Clear the canvases 
	canvas1.width = canvas1.width;
	canvas1.getContext('2d').fillStyle='white';
	canvas1.getContext('2d').fillRect(0,0,canvas1.width,canvas1.height);
	canvas2.width = canvas2.width;
	canvas2.getContext('2d').fillStyle='white';
	canvas2.getContext('2d').fillRect(0,0,canvas2.width,canvas2.height);

	// Put some random rectangles on canvas 1
	randomRectangles(canvas1,100);

	// run the algorithm and find corner values for every pixel
	var apertureSize = 2;
	var corners = findCorners(canvas1,1,canvas1.width*canvas1.height);

	// Draw the intensity plot on canvas2
	drawIntensity(canvas2,apertureSize,corners);

	// Circle the first 100 corners on canvas1
	var results = corners.slice(0,100);	
	circleResults(canvas1,results);
}
document.getElementById("canvasExample2").onclick = showSteps;
document.getElementById("canvasExample3").onclick = showSteps;
showSteps();
</script>
