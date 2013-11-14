---
title: Graphical Prompts in Shell Scripts
author: Andrew Ippoliti
date: 2013-11-07 21:12:51
category: bash shell linux gui zenity
tag: bash shell linux gui zenity
layout: post
---

It is easy to create a graphical prompt for your shell scripts using a program
called `zenity` (assuming you have graphical user interface).

`zenity` is installed in many popular linux distributions by default. You can 
run it from the command line with the `--help` option to see some of it's
features.

Here is my [new jekyll post script]({{ site.baseurl }}{% post_url 2013-11-05-generating-jekyll-posts %})
rewritten to use graphical prompts:

{% highlight bash %}
#!/bin/bash

layout="post"
editor="gedit"

author=$(zenity --entry --text="Enter the author's name:")
title=$(zenity --entry --text="Enter the post title:")
date=$(zenity --calendar --text='Select the published date' --date-format='%Y-%m-%d')
tag=$(zenity --entry --text="Enter the tags/categories for this post:")
format=$(zenity --list --text='Pick the format' \
  --print-column='2' --column='name' --column='extension' \
  'Markdown' 'md' 'Textile' 'textile')

# Create the file with the appropriate data
filename="_posts/$date-$(echo $title | sed 's/[ _+()!@#$%^&*.]/-/g' | sed 's/-+/-/g' | tr [:upper:] [:lower:]).$format"
echo '---' > "$filename"
echo "author: $author" >> "$filename"
echo "title: $title" >> "$filename"
echo "date: $date" >> "$filename"
echo "category: $tag" >> "$filename"
echo "tag: $tag" >> "$filename"
echo "layout: $layout" >> "$filename"
echo '---' >> "$filename"
echo '' >> "$filename"

# Open the file in the specified editor
$editor "$filename"
{% endhighlight %}

Most of the zenity dialogs are self explanitory; however, I think the `--list` 
dialog is a bit confusing. First you need to specify names for all of the
columns of data you will list using `--column` switches. In my example there 
are 2 columns of data `name` and `extension`. You can have the script return 
the data from any of the selected columns using `--print-column`. `1` is the
first column, `2` is the second, etc... Finally you specify all of the data
that will be shown in the rows. Since you've specified `2` columns already, it
will divide your data automatically across the number of columns and add the
appropriate number of rows.

The `--help` options are okay but the best way to learn is to try it!

