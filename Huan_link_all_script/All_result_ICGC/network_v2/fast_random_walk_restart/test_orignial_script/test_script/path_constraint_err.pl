#! /usr/bin/perl -w
use strict;
use Getopt::Long;

###############################################
#  To cut pathway to <5 length

if (!defined $ARGV[0]){die"
=====  USAGE  =====
script
	-r --regulator file		# list of regulators
	-t --target file		# list of targets
	-s --sif file			# rwr output file
	-l --length number		# define path length, 5(default)
Opitional:
	[-i --intra 0/1]			# detect intra cross talk? Yes(1, Default), No(0)
	> output_file
";}

###############################################

my $reg_file; my $target_file; my $pathway_file;
my $length=5; my $intra=1;
GetOptions(
	"regulator=s" => \$reg_file,
	"target=s" => \$target_file,
	"sif=s" => \$pathway_file,
	"length=s" => \$length,
	"intra=i" => \$intra,
);

my @regulators=`cat $reg_file`;
my @targets=`cat $target_file`;


my @start = @targets; my $result=''; my $tmp='';
my @new_end;
for my $start (@start){
	chomp $start; 
	my @end = `grep \"\\b$start\\b\" $pathway_file | cut -f1,2 | sed 's\/\\b$start\\b\/\/' | sed 's\/\\t\/\/'`;
	for my $end (@end) {
		chomp $end; #print "$start\t$end\n";
		my $weight1 = `grep -P "$start\t$end\t" $pathway_file | cut -f3`;	chomp $weight1; 
		my $weight2 = `grep -P "$end\t$start\t" $pathway_file | cut -f3`;   chomp $weight2;
		my $tmp0 = 0; 
		if ($weight1 ne '' ) {	
			$tmp0=1;
			$tmp = "$start\t$weight1\t$end:"; 
			push (@new_end,$end);
		}
		if ($weight2 ne '')  {	
			$tmp0=1;
			$tmp = "$start\t$weight2\t$end:";
			push (@new_end,$end); 
		}
	}
	next if ($result =~ /$tmp/);
	$result = $tmp;
	print "$result\n";
}


