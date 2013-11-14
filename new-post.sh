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

	-a=*|--author=*)
	author=$(echo $i | sed 's/[-a-zA-Z0-9]*=//')
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
echo "author: $author" >> "$filename"
echo "date: $time" >> "$filename"
echo "category: $category" >> "$filename"
echo "tag: $tag" >> "$filename"
echo "layout: $layout" >> "$filename"
echo '---' >> "$filename"
echo '' >> "$filename"

# Open the file in the specified editor
$editor "$filename"

