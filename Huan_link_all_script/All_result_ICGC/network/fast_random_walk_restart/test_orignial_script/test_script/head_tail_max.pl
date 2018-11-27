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
	-m --max number		# Max DNA number (Default 30)
	-s --search file	# TF.calue.tab file
	-p --pvalue		# P-value: 10E-4(default); 10E-5; 10E-6; 10E-7; 10E-8
	-f --file file		# pathway_len.sif file 
";}
###############################################

my $tf_file; my $drug;  my $search_file; my $target_file; my $file;
my $max=30; my $pvalue='10E-4';
GetOptions(
	"regulator=s" => \$tf_file,
	"target=s" => \$target_file,
	"drug=s" => \$drug,
	"max=s" => \$max,
	"search=s" => \$search_file,
	"pvalue=s" => \$pvalue,
	"file=s" => \$file,
);

$pvalue = 4 if ($pvalue eq '10E-4'); $pvalue = 5 if ($pvalue eq '10E-5'); $pvalue = 6 if ($pvalue eq '10E-6');
$pvalue = 7 if ($pvalue eq '10E-7'); $pvalue = 8 if ($pvalue eq '10E-8');

# --- Drug-Target Relation ---
my @targets=`cat $target_file`;
my $drug_target='';
foreach my $target (@targets){
	chomp $target;
	$drug_target.="$drug\tmp\t$target\n";
}

# --- TF-DEGs relation ---
my @tf_total=`cat $search_file`;
my @tfs=`cat $tf_file`;
my $tf_dna=();
my $tally=0;
for (my $a=0; $a<=$#tf_total; $a++){
	my $tmp_pvalue = (split (/\t/, $tf_total[$a]))[1];
	my $tmp_deg = (split (/\t/, $tf_total[$a]))[0];
	my $tmp_tf = (split (/\t/, $tf_total[$a]))[2];
	
	foreach my $tf (@tfs){ 
		chomp $tf; #print "$tf $tmp_tf\n";
		if ($tf eq $tmp_tf && $tmp_pvalue >= $pvalue){
			$tally++;
			$tf_dna .= $tmp_tf."\t".$tmp_pvalue."\t".$tmp_deg."\n";
		}
	}
	
	last if ($tally > $max);
}


# --- Integrate all elements in sif ---
my $file1=`cat $file`;
print "$file1";
print "$drug_target";
print "$tf_dna";
