#!/bin/bash

# Source directory to update (applyee files):
toUpdate="/C/Users/jmich_000/Desktop/CodingProjects/mc1134.github.io"

# File type to update:
fileType=".html"

# Files to use to update other files (applyer files):
common=("header" "footer")

# Filter word when finding files
notUpdate="common"

# Usage:
usage=(
"Usage: "'"./apply.sh [directory] [filetype] [replacement]"'
"[directory] is the master directory in which to search all files of [filetype]"
"[filetype] is the type of file to look for. Most common type is html file: type \"html\""
"[replacement] is a file containing a list of files from which to copy their contents over to the discovered files in [directory]")
# note: this program does not yet have functionality indicated by the above
# TODO
ERR_IN_ARGS=false

echo ""

if $ERR_IN_ARGS
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
"               Application program for website                  "
"----------------------------------------------------------------"
"This program finds files of a specific file type in a source    "
"directory and updates them with files of a specific format. The "
"files used to update must contain:                              "
" •A begin string present in all files to update                 "
" •The content to replace                                        "
" •An end string present in all files to update                  "
"If the applyee files do not have both the begin and end string, "
"the update process will fail for that file, an error message    "
"will be output to stderr, and the program will continue until   "
"all files have been processed. Otherwise, the program will      "
"search for the begin and end strings in all applyee files, then "
"replace the [begin][stuff][end] content with                    "
"[begin][replace][end] content as specified in the applyer files."
"----------------------------------------------------------------")



# Intro blurb
clear
for str in "${description[@]}"
do
  echo -e "$str"
done

# Printing information and user confirmation
echo -e "Home directory: $toUpdate"
echo -e "File type to update: $fileType"
echo -e "Applyer files: $common"
echo -e "Filter word when locating applyee files: $notUpdate\n"

read -n 1 -s -p "Update files? Type 'y' if yes, else any other key to cancel" input
echo -e "\n"
if [ $input != "y" ]
then
	echo -e "Exiting..."
	exit
fi

# Getting all applyee files
echo "Now applying changes to the following files:"
applyee=$(find $toUpdate -name "*$fileType" | grep -v "$notUpdate") # variable with actual file addresses to use
shortApplyee=$(echo "$applyee" | sed 's|'$toUpdate'|~|') # variable of shortened file addresses
echo -e "$shortApplyee\n"

# Replacement step
# pseudocode:
# for each applyee file A
# for each applyer file B with begin/end string C..C'
# replace instance of C..C' in A with B
# Error cases:
# (1) If no read/write privileges for A or B, skip file A or B
# (2) If C, C', or both are missing, abort edit and write
# (3) If no space (rare), end program
while read -a file
do
	shortFile=$(echo "$file" | sed 's|'$toUpdate'|~|')
	for begend in "${common[@]}"
	do
		applyer="$toUpdate/$notUpdate/$begend$fileType"
		shortApplyer="~/$notUpdate/$begend$fileType"
		# extract C as firstline and C' as lastline
		firstline=$(head -n1 "$applyer")
		lastline=$(tail -n1 "$applyer")
		# handle error 1 (no rw privileges)
		firstthing=""; lastthing=""; lineOfFirst=""; lineOfLast=""; er=""
		if [ "$(stat -c %A "$file" | sed 's|.\(..\).\+|\1|')" = "rw" ]
		then
			# search for C and C' in files
			firstthing=$(grep -n """$firstline""" "$file")
			lastthing=$(grep -n """$lastline""" "$file")
			# extract line numbers
			lineOfFirst=$(echo "$firstthing" | sed 's|\([0-9]\+\):.*|\1|')
			lineOfLast=$(echo "$lastthing" | sed 's|\([0-9]\+\):.*|\1|')
		else
			er="1"
		fi
		# handle error 2 (line numbers missing)
		if [ -z "$lineOfFirst" ] || [ -z "$lineOfLast" ]; then
			er="$er 2"
		fi
		# handle error 3 (no space)
			#TODO
		# print summary
		if [ -z "$er" ]; then
			echo ">>SUCCESS FOR FILE <$shortFile> APPLYING <$shortApplyer>"
			# overwrite lines $lineOfFirst-$lineOfLast for $file with $applyer
			#TODO
		else echo ">>FAILURE FOR FILE <$shortFile> APPLYING <$shortApplyer>; ERROR FLAG(S) $er"
		fi
		echo -e ">>>>firstnum: $lineOfFirst; lastnum: $lineOfLast\n"
	done
done <<< "$applyee"
