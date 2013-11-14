---
title: Generating Jekyll Posts
date: 2013-11-05 23:31:37
category: jekyll bash
tag: jekyll bash
layout: post
author: Andrew Ippoliti
---

Manually making files in your Jekyll blog's `_post` directory can be tedious.
I made a script which automatically creates the file with a specified title,
date, category, layout, etc... Here's the bash code:

{% highlight bash %}
#!/bin/bash

# Defaults
date=$(date '+%Y-%m-%d')
time=$(date '+%Y-%m-%d %H:%M:%S')
layout="post"
format="md"
editor="gedit"

# Parse the arguments:
for i in "$@"
do
case $i in
	-t=*|--title=*)
	title=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	-l=*|--layout=*)
	layout=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	-d=*|--date=*)
	date=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	-c=*|--category=*|--categories=*)
	category=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	--tag=*|--tags=*)
	tag=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	-e=*|--editor=*)
	editor=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
	;;

	*)
	echo "Unknown option: $i"
	;;

esac
done

# Create the file with the appropriate data
filename="_posts/$date-$(echo $title | sed 's/[ _+()!@#$%^&*.]/-/g' | sed 's/-+/-/g' | tr [:upper:] [:lower:]).$format"
echo '---' > "$filename"
echo "title: $title" >> "$filename"
echo "date: $time" >> "$filename"
echo "category: $category" >> "$filename"
echo "tag: $tag" >> "$filename"
echo "layout: $layout" >> "$filename"
echo '---' >> "$filename"
echo '' >> "$filename"

# Open the file in the specified editor
$editor "$filename"
{% endhighlight %}

The script takes a few arguments. The only mandatory one is `-t=` or `--title` 
which represents the title of your post.

To use it, save the above code as `new-post` in your blog's directory. Then
make it executable by running:

	chmod +x 'new-post'

Here are some examples:

	./new-post --title='Hello World' --layout=post --editor=gedit
	./new-post -t='The best idea ever' -c='idea brilliant' --editor=nano
	./new-post -e=vim -t='Some cool code' -c='code bash' -l=post --tag='bash'

More Happy Blogging!

