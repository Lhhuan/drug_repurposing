#!/bin/bash
#  $line = less ./paintor/input_loci_list |wc -l 
#  echo "$line\n"
# echo "wc -l ./paintor/input_loci_list"
less ./paintor/input_loci_list |wc -l >$line
echo "$line\n"