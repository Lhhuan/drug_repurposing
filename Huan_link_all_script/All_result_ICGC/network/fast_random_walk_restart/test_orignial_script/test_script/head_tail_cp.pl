#! /usr/bin/perl -w
use strict;
use Getopt::Long;

###############################################
# Add drug and TF-DNA into the path
if (!defined $ARGV[0]){die "
===== Usage =====
script
	-r --regulator file	# TF list file
	-t --target file	# Target list file
	-d --drug name		# Drug name
	-s --search file	# TF.calue.tab file
	-p --pvalue		# P-value: 10E-4(default); 10E-5; 10E-6; 10E-7; 10E-8
	-f --file file		# pathway_len.sif file 
	> output_file
Optional:
	[-l --loop 0/1]		# Loop or not? 1 (Yes,defualt); 0 (No)
";}
###############################################

my $tf_file; my $drug;  my $search_file; my $target_file; my $file;
my $max=30; my $pvalue='10E-4'; my $loop =1;
GetOptions(
	"regulator=s" => \$tf_file,
	"target=s" => \$target_file,
	"drug=s" => \$drug,
	"search=s" => \$search_file,
	"pvalue=s" => \$pvalue,
	"file=s" => \$file,
	"loop=s" => \$loop,
);

$pvalue = 4 if ($pvalue eq '10E-4'); $pvalue = 5 if ($pvalue eq '10E-5'); $pvalue = 6 if ($pvalue eq '10E-6');
$pvalue = 7 if ($pvalue eq '10E-7'); $pvalue = 8 if ($pvalue eq '10E-8');

# --- Drug-Target Relation ---
my @targets=`cat $target_file`;
my $drug_target='';
foreach my $target (@targets){
	chop $target;
	$drug_target.="$drug\tmp\t$target\n";
}

# --- TF-DEGs relation ---
my @tf_total=`cat $search_file`;
my %tf_deg=(); my %tf_deg_pvalue=();
foreach (@tf_total){
	my $tmp_pvalue = (split (/\t/))[1];
	my $tmp_deg = (split (/\t/))[0];
	my $tmp_tf = (split (/\t/))[2];
	if ($tmp_pvalue >= $pvalue){
		$tf_deg{$tmp_tf} .= $tmp_deg.",";
		$tf_deg_pvalue{$tmp_tf."_".$tmp_deg} = $tmp_pvalue;
	}
}

my @tfs=`cat $tf_file`; 
my $tf_dna=(); my @tf_dna=();
my @file1=`cat $file`; 
foreach my $tf (@tfs){
	chop $tf;
	#print "--- $tf $pvalue ---\n$tf_deg{$tf}\n";
	my @deg = split (/\,/,$tf_deg{$tf});
	foreach my $deg (@deg){
		my $tmp = $tf."_".$deg;
		my $tmp2=0;
		if ($loop == 0){
		# -- If TF target gene appear in upsteam, then delete it.(Keep it in upstream)
			$tmp2 = grep {$_ =~ /\b$deg\b/} @file1;
		}
		#die "$deg\n" if ($tmp2 !=0);
		$tf_dna .= "$tf\t$tf_deg_pvalue{$tmp}\t$deg\n" if ($tmp2 == 0); 
	}
}


# --- Integrate all elements in sif ---
my $file1=`cat $file`;
print "$file1";
print "$drug_target";
print "$tf_dna";
