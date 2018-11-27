#!/usr/bin/perl
###################################
#Author :Jiang Li
#Email  :riverlee2008@gmail.com
#MSN    :riverlee2008@live.cn
#Address:Harbin Medical University
#TEl    :+86-13936514493
###################################
use strict;
use warnings;

open(II,"do_term.txt") or die $!;<II>;
my %doid2id;
while(<II>){
	s/\r|\n//g;
	next unless($_);
	my($id,$doid,$term) = split "\t";
	$doid2id{$doid}=$id;
}

open(OUT,">do_parents.txt") or die $!;
print OUT join "\t",("_id","_parent_id","relationship_type");
print OUT "\n";
open(IN,"child2parent.txt") or die $!;<IN>;
while(<IN>){
	s/\r|\n//g;
	next unless($_);
	my($c,$p) = split "\t";
	print OUT join  "\t",($doid2id{$c},$doid2id{$p},"is_a");
	print OUT "\n";
}

