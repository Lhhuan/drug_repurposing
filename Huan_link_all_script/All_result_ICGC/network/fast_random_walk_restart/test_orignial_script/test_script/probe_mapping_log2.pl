#! /usr/bin/perl -w
use strict;
use Getopt::Long;

###############################################
if (!defined $ARGV[0]){die "
===== Usage =====
script 
	-m --matrix  matrix_file	# probe value1 value2 .. valueN
	-p --platform  GPL_annot_file	# GPLXXX Annotation SOFT Table file(not family file)
	-c --control  number,		# column number of control groups, seperated by ","
	-t --treatment  number,		# column number of treatment groups, seperated by ","	
	-a --annot number,		# column number of annotation (e.g gene_symbol, ACC, GO etc), seperated by ","
	> mapping_result

=====  !!!! NOTE !!!!  =====
1) This script can ONLY process ONE perturbation against control each time.
2) Matrix File: MUST have the title line (see a sample below)
	ID_REF	treat1	treat2	control1	control2
	1007_at	 5.834	5.593	5.60	5.600
		...
3) GPL Annot File: MUST have the title line (see a sample below)
	ID	GB_ACC	SPOT_ID	.. Gene Title	Gene Symbol	ENTREZ_GENE_ID .. Biological Process	Cellular Component	Molecular Function
	1007_s_at	U48705	.. discoidin domain receptor family, member 1	DDR1	780	 .. 0006468 // protein amino acid phosphorylation // ..



=====  OUTPUT EXAMPLE  =====
(in STD OUTPUT)
	Gene_Symbol	Log2_Fold_Change	
	PTPN21	-1.09

";}
###############################################

my $matrix; my $annot; my $control; my $pert;  my $tmp; my $platform;
GetOptions(
	"matrix=s" => \$matrix,
	"annot=s" => \$annot,
	"control=s" => \$control,
	"treatment=s" => \$pert,
	"platform=s" => \$platform,
);

#-------  Column number  -----------
my @control = split (/,/,$control);
my @pert = split (/,/,$pert);
my @annot = split (/,/,$annot);


#--------  Construct Probe-Gene relation  -----------
my %probe_gene;
open (GPLFILE, $platform) or die "cannot open file $platform\n";
<GPLFILE>;
my @gplfile = <GPLFILE>;
for my $gplfile (@gplfile){
		my $key=(split(/\t/,$gplfile))[0]; 		# print "$key\n";last;
		my $annotation;
		for my $a (@annot){
			$tmp=(split (/\t/,$gplfile))[$a-1]; 
			if (defined $tmp){
				$tmp=~s/\"//g if ($tmp=~/\"/);
			}else { $tmp = '';}
			$annotation.=$tmp."\t";
		}
		$annotation=~s/\t$//;
		$probe_gene{$key}=$annotation;
		#print "$key\t$probe_gene{$key}\n";
}
close GPLFILE;


#--------  Matrix File  ----------

open (MATRIXFILE, $matrix) or die "cannot open file $matrix\n";
<MATRIXFILE>;
my @matrixfile=<MATRIXFILE>;
close MATRIXFILE; 
my $fold; my $fold2;
#my $debug;
#if ( defined $debug ){
print "Annotation\tLog2_Fold_Change\n";
for my $line (@matrixfile) {
	chomp $line;
	my $marker=0;	my $trtm=0;  my $ctrl=0; 
		
	##  START - Cal fold change
	for my $p (@pert){
		$tmp=(split (/\s+/,$line))[$p-1]; 		
		if (defined $tmp && $tmp ne ''){
			$tmp=~s/\"//g if ($tmp=~/\"/);
			$marker++;
		} else { 
			$tmp = 0;
		}
		$trtm+=$tmp;
	}
	$trtm=$trtm/$marker;
	
	$marker=0;
	for my $c (@control){
		$tmp=(split (/\s+/,$line))[$c-1]; 
		if (defined $tmp && $tmp ne ''){
			$tmp=~s/\"//g if ($tmp=~/\"/);
			$marker++;
		} else { 
			$tmp = 0;
		}
		$ctrl+=$tmp;
	}
	$ctrl=$ctrl/$marker;
	
	$fold=log($trtm/$ctrl)/log(2);
	##  END - Cal fold change 

	my $probe=(split (/\s+/,$line))[0];
	$probe=~s/\"//g if ($probe=~/\"/);
	print "$probe_gene{$probe}\t$fold\n"; #if (abs($fold2)>=1.5);  #last;
}
#}
