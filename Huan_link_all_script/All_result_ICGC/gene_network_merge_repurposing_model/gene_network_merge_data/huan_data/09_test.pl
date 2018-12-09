#!/usr/bin/perl
my @array = (Launched, 4,unknown,Preclinical,0);
my @sorted_files = sort {$b cmp $a} @array;
print "\n",@sorted_files;