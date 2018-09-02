#!/bin/bash

# Source directory to update (applyee files):
toUpdate="/C/Users/jmich_000/Desktop/CodingProjects/mc1134.github.io"

# File type to update:
fileType="*.html"

# Files to use to update other files (applyer files):
common=("header" "footer")

# Usage:
usage=(
"Usage: "'"./apply.sh [directory] [filetype] [file1] [file2] ..."'
"[directory] is the master directory in which to search all files of [filetype]"
"[filetype] is the type of file to look for. Most common type is html file: type \"html\""
"[file#] are the files from which to copy their contents over to the discovered files in [directory]"
"This program requires at least 3 command line arguments after "'"./apply.sh"')
# note: this program does not yet have functionality indicated by the above
# TODO
ERROR_ARGS=false

echo ""

if $ERROR_ARGS
then
  for str in "${usage[@]}"
  do
    echo -e "$str"
  done
  exit
fi

# Description:
description=(
"----------------------------------------------------------------" # 64 hyphens
"               Application program for website"
"----------------------------------------------------------------"
"This program finds files of a specific file type in a source"
"directory and updates them with files of a specific format. The"
"files used to update must contain:"
" •A begin string present in all files to update"
" •The content to replace "
" •An end string present in all files to update"
"If the applyee files do not have both the begin and end string,"
"the update process will fail for that file, an error message"
"will be output to stderr, and the program will continue until"
"all files have been processed. Otherwise, the program will"
"search for the begin and end strings in all applyee files, then"
"replace the [begin][stuff][end] content with"
"[begin][replace][end] content as specified in the applyer files."
"----------------------------------------------------------------")

# Intro blurb
clear
for str in "${description[@]}"
do
  echo -e "$str"
done

# Getting all applyee files
echo "Now applying changes to the following files:"
applyee=$(find $toUpdate -name "*.html")
for item in "$toUpdate"/*.html
do
  echo "$item"
done
