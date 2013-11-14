---
title: rm Mistakes
author: Andrew Ippoliti
date: 2013-11-04 22:28:56
category: linux shell rm mistake
tag: linux shell rm mistake
layout: post
---

The `rm` command is very useful but if you're not careful you can do a lot of 
damage with it.

I needed a temporary directory to hold some output. So I made one called
`temp`. After making some output I wanted to delete the files in the directory
but not the directory itself. I planned to run:

	rm -rf temp/*

But I was a bit overzealous with the space bar and typed:

	rm -rf temp/ *

Which deleted everything in my current directory. Yay. Why did that happen?
`rm` takes a list of files as input and deletes them. I specified the `temp/` 
directory and `*` everything in the current directory. The `-r` option allows 
the deletion of directories and the `-f` option forces files to be deleted (ie
it does not ask for confirmation).

What should you learn from this?

1. Never use absolute paths in your `rm` commands (you may type
`rm -rf / oh_no` and delete your entire file system)
2. Double check your `rm` commands BEFORE hitting enter.
3. Don't use `-rf` ... unless you follow rule 2 above.
4. Don't use wild cards ... unless you follow rule 2 above.

Happy `rm`ing.

