---
title: The Pancake Sort
author: Andrew Ippoliti
date: 2013-11-09 16:58:33
category: useless algorithms pancake sort
tag: useless algorithms pancake sort
layout: post
---

Some of us need our pancakes to be stacked from largest (bottom) to smallest 
(top). If you only have a spatula and a small area this can be quiet a
challenge. It also makes one horrible sorting algorithm.

The only thing you can do is flip your pancakes from an arbitrary location in
the stack. As the following code illustrates:

<div>{% highlight js %}
function pancake_flip(pancakes,flip_index){
  var n_pancakes = pancakes.length;
  var left = flip_index;
  var right = n_pancakes - 1;
  var swap;
  for( ; left < right; left+=1, right-=1 ){
    swap = pancakes[left];
    pancakes[left] = pancakes[right];
    pancakes[right] = swap;
  }
  return pancakes;
}
{% endhighlight %}</div>

Building ontop of my pancake stack flipping skills I can sort the entire stack.
First I find the largest pancake and flip it to the top. Next I flip the entire
stack so the biggest is on the bottom. Then I ignore the big pancake on the
bottom (ie pretend it's no longer in the stack) and repeat: I find the largest
pancake and flip it to the top. Next I flip the entire stack (but not that
bottom one) so that this one is above that bottom one we are ignoring. Now
I ignore the bottom 2 and repeat in a similar manner until everything is
sorted. Simple right?

Without further ado, I present the pancake sort:

<div>{% highlight js %}
function pancake_sort(pancakes){

  // the number of pancakes
  var n_pancakes = pancakes.length;
  
  var j = n_pancakes;
  while( j-- ){
  
    // First find the largest pancake
    var max = pancakes[n_pancakes-j-1];
    var i_max = n_pancakes-j-1;
    var i = n_pancakes-j-1;
    for( i=n_pancakes-j-1; i<n_pancakes; i+=1 ){
      if( pancakes[i] > max ){
        max = pancakes[i];
        i_max = i;
      }
    }
    
    // Bring the pancake to the top by flipping
    pancake_flip( pancakes, i_max );
    
    // Now put it on the bottom by flipping the entire stack
    pancake_flip( pancakes, n_pancakes-j-1 );

  }
  
  // The stack is upside down now so flip it: \/ -> /\
  pancake_flip( pancakes, 0 );
  return pancakes;
}
{% endhighlight %}</div>

What? You want to see it in action? Fine:

<p><button class="btn btn-primary btn-block" id="btn_random">New Pancakes</button></p>
<textarea rows="10" id="in_pancakes" style="width: 98%" >Some text...</textarea>
<p><button class="btn btn-primary btn-block" id="btn_sort">Sort</button></p>
<pre><code id="out_sorted">Mmmm... pancakes</code></pre>

<script type="text/javascript">
function pancake_flip(pancakes,flip_index){
	var n_pancakes = pancakes.length;
	var left = flip_index;
	var right = n_pancakes - 1;
	var swap;
	for( ; left < right; left+=1, right-=1 ){
		swap = pancakes[left];
		pancakes[left] = pancakes[right];
		pancakes[right] = swap;
	}
	return pancakes;
}
/*
console.info( pancake_flip([0,1,2,3,4,5,6],0) );
console.info( pancake_flip([0,1,2,3,4,5],1) );
console.info( pancake_flip([0,1,2,3,4,5],2) );
console.info( pancake_flip([0,1,2,3,4,5],3) );
*/
function pancake_sort(pancakes){

	// the number of pancakes
	var n_pancakes = pancakes.length;
	
	var j = n_pancakes;
	while( j-- ){
	
		// First find the largest pancake
		var max = pancakes[n_pancakes-j-1];
		var i_max = n_pancakes-j-1;
		var i = n_pancakes-j-1;
		for( i=n_pancakes-j-1; i<n_pancakes; i+=1 ){
			if( pancakes[i] > max ){
				max = pancakes[i];
				i_max = i;
			}
		}
		
		// Bring the pancake to the top by flipping
		pancake_flip( pancakes, i_max );
		
		// Now put it on the bottom by flipping the entire stack
		pancake_flip( pancakes, n_pancakes-j-1 );

	}
	
	// The stack is upside down now so flip it: \/ -> /\
	pancake_flip( pancakes, 0 );
	return pancakes;
}
//console.info( pancake_flip( [0,1,2], 2) );
//console.info( pancake_sort([0,1,2,3,4,5]) );
//console.info( pancake_sort([0,6,2,3,4,5]) );
//console.info( pancake_sort([9,6,2,3,4,5]) );

document.getElementById('btn_random').onclick = function(){
	// Get a random number of pancakes between 5 and 15
	var n_pancakes = Math.floor(5 + 10*Math.random());
	
	// Create that many random numbers, each number is a pancake
	var i, pancakes = [];
	for( i=0; i<n_pancakes; i+=1 ){
		pancakes.push( Math.floor(1 + 20*Math.random()) );
	}
	
	// Draw the pancakes
	document.getElementById('in_pancakes').value = pancakes.join('\n');
}

document.getElementById('btn_sort').onclick = function(){
	// Get the pancakes
	var txt_pancakes = document.getElementById('in_pancakes').value.split('\n');
	// Make sure they are all numbers
	var i, tmp, n_pancakes = txt_pancakes.length;
	var pancakes = [];
	var out = '';
	for( i=0; i<n_pancakes; i+=1 ){
		tmp = parseInt(txt_pancakes[i]);
		if( isNaN(tmp) ){
			out += 'Wait...\n';
			out += '"'+txt_pancakes[i]+'" is not a number (line '+i+')\n';
			out += 'Fix your input and try again!';
			document.getElementById('out_sorted').innerHTML = out;
			return;
		}
		pancakes[i] = tmp;
	}
	
	// Sort and output
	pancakes = pancake_sort(pancakes);
	document.getElementById('out_sorted').innerHTML = pancakes.join('\n');
}
</script>

