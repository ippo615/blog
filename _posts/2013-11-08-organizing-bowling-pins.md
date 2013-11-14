---
title: Organizing Bowling Pins
author: Andrew Ippoliti
date: 2013-11-08 17:22:25
category: bowling pins algorithm problem
tag: bowling pins algorithm problem
layout: post
---

I don't always go bowling but when I do I try to arrange the pins in a very
specific way.

Bowling pins are arranged into a triangle. There are 4 rows of pins, the back
row has 4 pins, the next row has 3, then 2 and the front has 1 pin. Every
bowling pin in the set of 10 is labeled with an integer (0-9).

I like to arrange the pins so that the sum (modulo 10) of the labels of 2
adjacent pins is the number of the pin between/in front of them. How many ways 
can I arrange my pins without having a nervous breakdown?

First I need to find the valid rows of 4 in the back. Then work my way forward
by adding the numbers and checking if they follow the prescription above.

To generate a list of valid pins for the back row generate all combinations of
them and make sure that no element repeats:

<div>{% highlight javascript %}
var a,b,d,c;
var nums = [0,1,2,3,4,5,6,7,8,9];
var l = nums.length;
var remainder = 0;
var back4_initials = [];
for( a=0; a<l; a+=1 ){
  for( b=0; b<l; b+=1 ){
    if( a === b ){ continue; }
    for( c=0; c<l; c+=1 ){
      if( a === c || b === c ){ continue; }
      for( d=0; d<l; d+=1 ){
        if( a === d || b === d || c === d ){ continue; }
        back4_initials.push([a,b,c,d]);
      }
    }
  }
}
{% endhighlight %}</div>

I've got an array of possible values for the back row. Now I need to remove
rows in which the sum of 2 adjacent element modulo 10 is another element:

<div>{% highlight javascript %}
var l = back4_initials.length;
var back4_filts = [];
var back4;
var remainder = 0;
for( i=0; i<l; i+=1 ){
  back4 = back4_initials[i];
  remainder = (back4[0]+back4[1])%10;
  if( is_in(back4,remainder) ){ continue; }
  remainder = (back4[1]+back4[2])%10;
  if( is_in(back4,remainder) ){ continue; }
  remainder = (back4[2]+back4[3])%10;
  if( is_in(back4,remainder) ){ continue; }
  back4_filts.push(back4);
}
{% endhighlight %}</div>

What does the `is_in` function do? It returns `1` if the specified element is
in the array, `0` otherwise. Here's the code:

<div>{% highlight javascript %}
function is_in(arr,val){
	var i = arr.length;
	while( i-- ){
		if( arr[i] === val ){
			return 1;
		}
	}
	return 0;
}
{% endhighlight %}</div>


The final step is to try computing the remaining pins and reporting any
successes:


<div>{% highlight js %}
var l = back4_filts.length;
var back4, back3, back2, back1;
var remainder = 0;
var results = [];
for( i=0; i<l; i+=1 ){
  back4 = back4_filts[i];
  back3 = [(back4[0]+back4[1])%10,(back4[1]+back4[2])%10,(back4[2]+back4[3])%10];
  back2 = [(back3[0]+back3[1])%10,(back3[1]+back3[2])%10];
  back1 = [(back2[0]+back2[1])%10];
  if( is_all_unique(back4,back3,back2,back1) ){
    results.push([back4,back3,back2,back1]);
  }
}
{% endhighlight %}</div>

I snuck in another function, `is_all_unique`. It returns `0` if an element is
shared between the arrays, `1` otherwise, as shown below:

<div>{% highlight js %}
function is_all_unique(b4,b3,b2,b1){
	if( is_in(b1,b4[0]) ){ return 0; }
	if( is_in(b1,b4[1]) ){ return 0; }
	if( is_in(b1,b4[2]) ){ return 0; }
	if( is_in(b1,b4[3]) ){ return 0; }
	if( is_in(b1,b3[0]) ){ return 0; }
	if( is_in(b1,b3[1]) ){ return 0; }
	if( is_in(b1,b3[2]) ){ return 0; }
	if( is_in(b1,b2[0]) ){ return 0; }
	if( is_in(b1,b2[1]) ){ return 0; }
	
	if( is_in(b2,b3[0]) ){ return 0; }
	if( is_in(b2,b3[1]) ){ return 0; }
	if( is_in(b2,b3[2]) ){ return 0; }
	if( is_in(b2,b4[0]) ){ return 0; }
	if( is_in(b2,b4[1]) ){ return 0; }
	if( is_in(b2,b4[2]) ){ return 0; }
	if( is_in(b2,b4[3]) ){ return 0; }
	
	if( is_in(b3,b4[0]) ){ return 0; }
	if( is_in(b3,b4[1]) ){ return 0; }
	if( is_in(b3,b4[2]) ){ return 0; }
	if( is_in(b3,b4[3]) ){ return 0; }
	
	// Check for self conflicts (happens in 2 ie 7-7)
	if( b2[0] === b2[1] ){ return 0; }
	
	return 1;
}
{% endhighlight %}</div>

What are the actual results? All 8 are shown below (and they were just
computed, view the source if you don't believe me (view the source anyway, it
has some interesting notes on my technique vs brute force)):

<div class="row">
<div class="span2"><pre><code id="sol-0"></code></pre></div>
<div class="span2"><pre><code id="sol-1"></code></pre></div>
<div class="span2"><pre><code id="sol-2"></code></pre></div>
<div class="span2"><pre><code id="sol-3"></code></pre></div>
<div class="span2"><pre><code id="sol-4"></code></pre></div>
<div class="span2"><pre><code id="sol-5"></code></pre></div>
<div class="span2"><pre><code id="sol-6"></code></pre></div>
<div class="span2"><pre><code id="sol-7"></code></pre></div>
</div>

<script type='text/javascript'>
// Returns 1 if val is an element in arr
function is_in(arr,val){
	var i = arr.length;
	while( i-- ){
		if( arr[i] === val ){
			return 1;
		}
	}
	return 0;
}

// Returns 1 if b4,b3,b2,b1 have no elements which are equal
// b4 is a 4 element array, b3 has 3 elements, b2 has 2 elements, b1 has 1
function is_all_unique(b4,b3,b2,b1){
	if( is_in(b1,b4[0]) ){ return 0; }
	if( is_in(b1,b4[1]) ){ return 0; }
	if( is_in(b1,b4[2]) ){ return 0; }
	if( is_in(b1,b4[3]) ){ return 0; }
	if( is_in(b1,b3[0]) ){ return 0; }
	if( is_in(b1,b3[1]) ){ return 0; }
	if( is_in(b1,b3[2]) ){ return 0; }
	if( is_in(b1,b2[0]) ){ return 0; }
	if( is_in(b1,b2[1]) ){ return 0; }
	
	if( is_in(b2,b3[0]) ){ return 0; }
	if( is_in(b2,b3[1]) ){ return 0; }
	if( is_in(b2,b3[2]) ){ return 0; }
	if( is_in(b2,b4[0]) ){ return 0; }
	if( is_in(b2,b4[1]) ){ return 0; }
	if( is_in(b2,b4[2]) ){ return 0; }
	if( is_in(b2,b4[3]) ){ return 0; }
	
	if( is_in(b3,b4[0]) ){ return 0; }
	if( is_in(b3,b4[1]) ){ return 0; }
	if( is_in(b3,b4[2]) ){ return 0; }
	if( is_in(b3,b4[3]) ){ return 0; }
	
	// Check for self conflicts (happens in 2 ie 7-7)
	if( b2[0] === b2[1] ){ return 0; }
	
	return 1;
}

function draw_pins(rows){
	var b4 = rows[0], b3 = rows[1], b2 = rows[2], b1 = rows[3];
	var out = "";
	out += b4[0] +' '+ b4[1] +' '+ b4[2] +' '+ b4[3] +'\n';
	out += ' '+  b3[0] +' '+ b3[1] +' '+ b3[2] +'\n';
	out += '  '+       b2[0] +' '+ b2[1] +'\n';
	out += '   '+            b1[0] +'\n';
	return out;
}

onload = function(){

	// First find all sets of 4 numbers where the sum of 2 adjacent number is not 
	// a number in the set. And each element is unique. 
	var a,b,d,c;
	var nums = [0,1,2,3,4,5,6,7,8,9];
	var l = nums.length;
	var remainder = 0;
	var back4_initials = [];
	for( a=0; a<l; a+=1 ){
		for( b=0; b<l; b+=1 ){
			if( a === b ){ continue; }
			for( c=0; c<l; c+=1 ){
				if( a === c || b === c ){ continue; }
				for( d=0; d<l; d+=1 ){
					if( a === d || b === d || c === d ){ continue; }
					back4_initials.push([a,b,c,d]);
				}
			}
		}
	}

	// Remove any in which the sum of adjacent numbers produces another in the group
	var l = back4_initials.length;
	var back4_filts = [];
	var back4;
	var remainder = 0;
	for( i=0; i<l; i+=1 ){
		back4 = back4_initials[i];
		remainder = (back4[0]+back4[1])%10;
		if( is_in(back4,remainder) ){ continue; }
		remainder = (back4[1]+back4[2])%10;
		if( is_in(back4,remainder) ){ continue; }
		remainder = (back4[2]+back4[3])%10;
		if( is_in(back4,remainder) ){ continue; }
		back4_filts.push(back4);
	}

	// Try leaving these in order and computing the remaining pins
	var l = back4_filts.length;
	var back4, back3, back2, back1;
	var remainder = 0;
	var results = [];
	for( i=0; i<l; i+=1 ){
		back4 = back4_filts[i];
		back3 = [(back4[0]+back4[1])%10,(back4[1]+back4[2])%10,(back4[2]+back4[3])%10];
		back2 = [(back3[0]+back3[1])%10,(back3[1]+back3[2])%10];
		back1 = [(back2[0]+back2[1])%10];
		if( is_all_unique(back4,back3,back2,back1) ){
			results.push([back4,back3,back2,back1]);
		}
	}

	// Draw 'em
	var l = results.length;
	for( i=0; i<l; i+=1 ){
		document.getElementById('sol-'+i).innerHTML = draw_pins(results[i]);
	}

	// Brute force:
	// 10^10 = 10 000 000 000

	// My way:
	// Back 4: 10^4 = 10 000 -> produces 3024 results to check
	// Filtering:   =  3 024 -> produces 1168 results to check
	// Final Round: =  1 168 -> produces 24   results to check
	// Total        = 14 192
	// VS     10 000 000 000 -> Savings 99.999858 %

}
</script>
