#!/bin/bash

updater="/C/Users/jmich_000/Desktop/CodingProjects/mc1134.github.io/common/header.html"
file="/C/Users/jmich_000/Desktop/CodingProjects/mc1134.github.io/common/test.txt"
firstline="1"
lastline="13"
changeline="3"

cat "$file"
echo -e "\n"
sed -i """$changeline r $updater""" "$file"
cat "$file"
echo -e "\n"
sed """$(( $changeline+$firstline )),$(( $changeline+$lastline ))d""" "$file"
echo -e "\nDone."
