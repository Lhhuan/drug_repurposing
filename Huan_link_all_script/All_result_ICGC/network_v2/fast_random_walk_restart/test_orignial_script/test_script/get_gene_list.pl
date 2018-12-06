#! /usr/bin/perl -w
use strict;
use Getopt::Long;

#################################################################################################
if (!defined $ARGV[0]){
die "
===== Usage =====
script.pl 
	-i probe_mapping_file 
	-o outputfile 
	[-f fold_change(default=1.5) OR -r TOP_num]

=====  Function  =====
Delete non-sense lines; remove redundancy;
Choose those changes more than designated fold change or changes of TOP num.

=====  output example  =====
Gene_Symbol	Max_Log2_Fold_Change
";}
#################################################################################################

my $fold_change=1.5; my $rank; my $probe_mapping_list; my $output_gene_list;
GetOptions(
	"f=f" => \$fold_change,
	"r=i" => \$rank,
	"i=s" => \$probe_mapping_list,
	"o=s" => \$output_gene_list,
);	

open (FILE, $probe_mapping_list) or die "can not open $probe_mapping_list: $!\n";
<FILE>;
my @initial=<FILE>;
close FILE;

my %gene_change; #my %same_gene_num;
my %abs_gene_change;

foreach my $line (@initial){
    chomp $line;
	my $gene=(split (/\t/,$line))[0];
	my $fold_value=(split ("\t",$line))[1];
	next if ($gene =~ /\//); # remove blank line or "SIGLEC10 /// SIGLEC12"-like line
	next if ($gene eq '');

	if (!defined $gene_change{$gene}){
		$gene_change{$gene}=$fold_value; #$same_gene_num{$gene}=1;
	}else{
		#$same_gene_num{$gene}++;
		if ($abs_gene_change{$gene} <= abs($fold_value)){
			$gene_change{$gene}=$fold_value;
		}else {next;}
	}
	
	$abs_gene_change{$gene}=abs($fold_value);
}

my $tally=0;
my $result='';
my @sorted_gene = sort {$abs_gene_change{$b} <=> $abs_gene_change{$a}} (keys %abs_gene_change);
my $threshold=log($fold_change)/log(2);
my $marker=0; if (!defined $rank) {$rank = $#sorted_gene ; $marker =1;}

open (OUT,">", $output_gene_list) or die ("can not create $output_gene_list: $!\n");
foreach (0..($rank-1)){
    if ($abs_gene_change{$sorted_gene[$_]} >= $threshold){
		$result.="$sorted_gene[$_]\t$gene_change{$sorted_gene[$_]}\n";#$same_gene_num{$sorted_gene[$_]}\n";
		$tally++;
	}    
}

print OUT "$result";
close OUT;



#if ($marker==0){
#	if ($tally < $rank) {
#		print STDERR "Attention (not a program error):\n";
#		print STDERR "\tOnly TOP$tally genes can be selected under fold change $fold_change.\n";
#		print STDERR "\tTo show full TOP$rank genes, please try a smaller fold change.\n";
#	}
#}

