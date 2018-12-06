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

# --- Global variant ---
my @crosstalk=(); my @result=();my %count;

my $regulators = `cat $reg_file`;
my @regulators=split(/\n/,$regulators);
my $targets = `cat $target_file`; my @targets=split (/\n/,$targets);

# ----- Build an array for each protein in pathway  -----
my %ppi;
my @proteins=`cut -f1,2 $pathway_file | sed 's\/\\t\/\\n\/' | sort -u`;
foreach my $protein (@proteins){
	chomp $protein;
	$ppi{$protein}=`grep \"\\b$protein\\b\" $pathway_file | cut -f1,2 | sed 's\/\\b$protein\\b\/\/' | sed 's\/\\t\/\/'`;
	#print "$protein\n\n$ppi{$protein}" if ($protein eq 'TUBG1');
}


my %level;  $level{'0'}=$targets; # drug targets
my $start_array; 
my @captured=@targets;

for my $l (1..$length){ 

	$start_array=$l-1; 	
	my @start_array=split (/\n/,$level{$start_array});
	# ---  Get proteins in each level  -----
	foreach my $start (@start_array){
		next if ($start eq '');
		next if (!defined $ppi{$start});
		$level{$l}.=$ppi{$start}."\n"; #print "$start\n" if (!defined $ppi{$start});
	}
	#print "------  Level $l  ---------\n";	
	$level{$l}=&captured($level{$l});
	
	#print "$level{$l}";
	#print "@captured\n" if ($l==2) ; die if ($l==2);
	
	# -----------------------------------------------------
	# Find TF in each level and then trace back to target
	my @end_array=split (/\n/,$level{$l});
	foreach my $end (@end_array){
		my $tmp1=grep {$_ eq "$end"} @regulators;
		if ($tmp1 != 0){	
			&start_end($l,$end);
		} 
	}
}

#-----  Intra Cross Talk between Proteins  -----
if ($intra==1){
my @intra=();
my @crosstalk_nr = grep { ++$count{ $_ } < 2; } @crosstalk; 
#print  "------  Intra Cross Talk ------\n";
for my $target (@targets){ 
	for (my $i=0; $i<=$#crosstalk_nr-1; $i++){
		for (my $j=1; $j<=$#crosstalk_nr-$i; $j++){
			next if ($crosstalk_nr[$i] eq $target || $crosstalk_nr[$i+$j] eq $target );
			#print "$crosstalk_nr[$i]\t$crosstalk_nr[$i+$j]\n";
			# --- Get weight ---
			my $start=$crosstalk_nr[$i];
			my $end=$crosstalk_nr[$i+$j];
			my $tmp2=`grep -P "$start\t$end\t" $pathway_file | cut -f3`;	
			my $tmp3=`grep -P "$end\t$start\t" $pathway_file | cut -f3`;	
			if ($tmp2 ne '' ) {	
				chomp $tmp2;
				my $k = grep {$_ =~ /$start\t$tmp2\t$end/} @result;
				my $j = grep {$_ =~ /$end\t$tmp2\t$start/} @result;
				#print "tmp2;k=$k; j=$j; $start\t$tmp2\t$end\n";
				if ($k==0 && $j==0) {
					my $result = "$start\t$tmp2\t$end\n" ; 
					my $tmp = grep {$_ eq "$result"} @intra;
					print "$result" if ($tmp == 0);
					push (@intra,$result);
				}
			}
			if ($tmp3 ne '' ) {	
				chomp $tmp3; 
				my $k = grep {$_ =~ /$start\t$tmp3\t$end/} @result;
				my $j = grep {$_ =~ /$end\t$tmp3\t$start/} @result;
				#print "tmp3;k=$k; j=$j; $start\t$tmp3\t$end\n";
				if ($k==0 && $j==0) {
					my $result = "$start\t$tmp3\t$end\n" ; 
					my $tmp = grep {$_ eq "$result"} @intra;
					print "$result" if ($tmp == 0);
					push (@intra,$result);
				}
			}
		}
	}
}
}


#------------------------------------------
# Remove upstream proteins in each level
sub captured(){
	my ($level)=@_;
	my @new=split (/\n/,$level);
	for my $new (@new){
		my $tmp=grep {$_ eq "$new"} @captured;
		if ($tmp ==0) {			
			push (@captured, $new) ;
		}else {
			$level=~s/\b$new\b//;
		}
	}
	$level=~s/(\n+)/\n/g;
	$level=~s/^\n//;
	return $level;
	#push (@captured, @new);
}

#-------------------------------------
# Trace back when find the TF
sub start_end(){
	my ($l,$end_para)=@_; my @array;
	my @end2start=($end_para); #print "$l\t$end_para\t$#end2start\n";
	for (my $len=$l;$len>0; $len--){ #print "$l\t$len\t$#end2start\n";
		$start_array=$len-1; 	
		@array=();
		my @start_array=split (/\n/,$level{$start_array});
		foreach my $start (@start_array){ #print "$len\tstart is $start\n";
			next if ($start eq '');
			foreach my $end (@end2start){ 
				next if (!defined $ppi{$start});
				if ($ppi{$start}=~/\b$end\b/){	# get start protein
					# --- Get weight ---
					my $tmp2=`grep -P "$start\t$end\t" $pathway_file | cut -f3`;	
					my $tmp3=`grep -P "$end\t$start\t" $pathway_file | cut -f3`;
					my $tmp=0;
					if ($tmp2 ne '' ) {	
						chomp $tmp2; $tmp=1;
						my $result= "$start\t$tmp2\t$end\n";  
						my $tmp = grep {$_ eq "$result"} @result;
						print "$result" if ($tmp ==0);
						push (@crosstalk,$start);
						push (@crosstalk,$end);
						push (@result,$result) ;
					}
					if ($tmp3 ne '')  {	
						chomp $tmp3; $tmp=1;
						my $result= "$start\t$tmp3\t$end\n";  
						my $tmp = grep {$_ eq "$result"} @result;
						print "$result" if ($tmp ==0);
						push (@crosstalk,$start);
						push (@crosstalk,$end);
						push (@result,$result) ;
					}
					if ($tmp == 1)   {   push (@array,$start); }
				}
			}
		}@end2start=@array; 
	}
}

