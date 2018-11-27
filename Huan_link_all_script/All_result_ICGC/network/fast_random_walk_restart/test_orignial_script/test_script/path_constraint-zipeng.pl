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
	-o --output f1,f2		# f1-sif format, f2-txt format
";}

###############################################

my $reg_file; my $target_file; my $pathway_file; my $output;
my $length=5; my $intra=1; my $norepeat=0;
GetOptions(
	"regulator=s" => \$reg_file,
	"target=s" => \$target_file,
	"sif=s" => \$pathway_file,
	"length=s" => \$length,
	"output=s" => \$output,
);

# --- Global variant ---
my @regulators=`cat $reg_file`;
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

for my $l (1..$length){ 
	
	$start_array=$l-1; 	
	my @start_array=split (/\n/,$level{$start_array});
	# ---  Get proteins in each level  -----
	foreach my $start (@start_array){
		my $start_tmp = (split (/\t/,$start))[-1];
		next if ($start_tmp eq '');
		next if (!defined $ppi{$start_tmp});
		my @ppi=split (/\n/,$ppi{$start_tmp});
		foreach my $ppi (@ppi){
			$level{$l} .= "$start\t$ppi\n";		
		}
	}
}

#print "$level{$length}";
my @all_path=split (/\n/,$level{$length});
my @tf_path_element=();
my @tf_path=();
for my $path (@all_path) {
	foreach my $tf (@regulators){
		chomp $tf;
		my @element = split (/\t/,$path) ;		

		# -----------------------------
		# Delete lines like:
		#	MTHFR	NAA38	MTHFR	GABPA	REG3A	GABPA
		my $label=0;
		for (my $k=0;$k<=$#element-2;$k++){ 
			$label=1 if ($element[$k] eq $element[$k+2]);
		}
		
		if ($path=~/\b$tf\b/ && $label==0){			
			# --------------------------------
			# Find tf from end to start, to make sure
			# TF is the end point of each path. e.g:
			#		MTHFR	GABPA(tf)
			#		MTHFR	GABPA(tf)	NAA38	REG3A(tf)
			
			my $tf_path=''; my $marker=0;
			for (my $i=$#element; $i>=0; $i--){
				if ($element[$i] eq $tf){
					$marker=1;
					for (my $j=0; $j<=$i; $j++){	
						$tf_path .= "$element[$j]"."\t";
													
						# --------------------------------
						# Collect all the involved proteins
						my $tmp = grep {$_ eq $element[$j]} @tf_path_element;
						push (@tf_path_element,$element[$j]) if ($tmp ==0);
					}
				}
				last if ($marker==1);
			}
			$tf_path =~ s/\t$//;
			my $tmp = grep {$_ eq $tf_path} @tf_path;
			push (@tf_path,$tf_path) if ($tmp ==0);	
		}
	}
}

my $sif_file=(split (/\,/,$output))[0];
my $txt_file=(split (/\,/,$output))[1];

open (TXT,'>',$txt_file) or die "can not create $txt_file: $!\n";
for (@tf_path){
	print TXT "$_\n";
}
close TXT;

# -----------------------------------------
# Search ppi in rwr.out file and 
# output the weight.
open (SIF,'>',$sif_file) or die "can not create $sif_file: $!\n";
for (my $a=0;$a<=$#tf_path_element-1;$a++){
	for (my $b=$a+1;$b<=$#tf_path_element;$b++){
			# --- Get weight ---
			my $tmp2=`grep -P "$tf_path_element[$a]\t$tf_path_element[$b]\t" $pathway_file | cut -f3`;	chomp $tmp2;
			my $tmp3=`grep -P "$tf_path_element[$b]\t$tf_path_element[$a]\t" $pathway_file | cut -f3`;	chomp $tmp3;
			if ($tmp2 ne '' ) {	
				print SIF "$tf_path_element[$a]\t$tmp2\t$tf_path_element[$b]\n";
			}
			if ($tmp3 ne '')  {	
				print SIF "$tf_path_element[$b]\t$tmp3\t$tf_path_element[$a]\n";
			}	
		#print "$tf_path_element[$a]\tpp\t$tf_path_element[$b]\n";
	}
}
close SIF;
