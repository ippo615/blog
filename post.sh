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

