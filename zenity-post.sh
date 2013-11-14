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

