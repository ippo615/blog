---
title: Custom Parameters in Jekyll Posts
author: Andrew Ippoliti
date: 2013-11-06 19:46:37
category: jekyll blog yaml
tag: jekyll blog yaml
layout: post
---

You can add custom variables to your jekyll posts as long as they appear first
in your file. For example:

	---
	title: Oh Snap!
	author: Andrew Ippoliti
	custom: 0
	custom1: Hello
	custom2: Look at this
	contributor: Someone
	cost: free
	---

	This is the actual post text. Blah blah blah blah blah...

I decided to re-write my [new post script]({{site.baseurl}}/generating-jekyll-posts)
to accomodate any custom parameter you want. The code is below:

{% highlight bash %}
#!/bin/bash

# Defaults
date=$(date '+%Y-%m-%d')
time=$(date '+%Y-%m-%d %H:%M:%S')
format="md"
editor="gedit"

# The first argument is the title
title="$1"

# Create the simple file
filename="_posts/$date-$(echo $title | sed 's/[ _+()!@#$%^&*.]/-/g' | sed 's/-+/-/g' | tr [:upper:] [:lower:]).$format"
echo '---' > "$filename"
echo "title: $title" >> "$filename"
echo "date: $time" >> "$filename"

# Parse the remaining arguments
for i in "${@:1}"; do
case $i in

	# I still let the user specify an editor
	-e=*|--editor=*)
	editor=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	# Handles any custom arguments
	--*=*)
	echo $(echo $i | sed -e 's/^--//' -e 's/=/: /') >> "$filename"
	;;

esac
done

# Close the front matter
echo '---' >> "$filename"
echo '' >> "$filename"

# Open the file in the specified editor
$editor "$filename"
{% endhighlight %}

To use it, save the above code as `new-post` in your blog's directory. Then
make it executable by running:

	chmod +x 'new-post'

Here are some examples:

	./new-post "Hello world" --author="Me" --tags="c code simple"
	./new-post "You cannot have cookies for dinner" --why="because I said so"
	./new-post "Set the editor" --editor="nano" --huh="editor refers to the text-editing program"


