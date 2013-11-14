---
title: Jekyll Markdown Code Parsing Problems
author: Andrew Ippoliti
date: 2013-11-10 18:26:17
category: jekyll markdown problem fix syntax highlight
tag: jekyll markdown problem fix syntax highlight
layout: post
---

If you put certain code in your Jekyll posts for syntax highlighting you may
get unexpected results. This explains a very simple work around.

I found that when I wanted to syntax highlight javascript, the page would be
rendered from the beginning up to my javascript code. The javascript code would 
be highlighted properly but any text after it would not be parsed as markdown.

I found that the work around is to wrap the highlighted section in a `div` tag.
Note in the example below I had to add a space between the `%` and the `{` `}`
to prevent the highlighter from removing them (in your code you should not have
that space.

<pre>&lt;div&gt;
  { % highlight js % }
  for( var i=0; i<10; i+=1 ){
    alert('This will really annoy you!');
  }
  alert('I was right, right?');
  { % endhighlight % }
&lt;/div&gt;</pre>

Of course why waste 2 lines? You may prefer the compact notation:

<pre>&lt;div&gt;{ % highlight js % }
  for( var i=0; i<10; i+=1 ){
    alert('This will really annoy you!');
  }
  alert('I was right, right?');
{ % endhighlight % }&lt;/div&gt;</pre>

If you don't want the markdown parser to touch something, wrap it in a `div`:

<pre>&lt;div&gt;
call_this_function("In markdown this would be italicized") as shown below:
&lt;/div&gt;</pre>

call_this_function("In markdown this would be italicized") as shown below:

or not...


