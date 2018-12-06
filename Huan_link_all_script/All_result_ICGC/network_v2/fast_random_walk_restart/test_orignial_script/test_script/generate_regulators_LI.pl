#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use DBI;
use File::Basename;


# MYSQL CONFIG VARIABLES
my $database = "tfrnv2";
my $user = "jing";
my $pw = "wanglab_jing";

my $dbh = DBI->connect("DBI:mysql:$database;host=147.8.193.37", "$user", "$pw"
	           ) || die "Could not connect to database: $DBI::errstr";
	           
my $promoter_range = "-8000~+2000"; #only -8000~+2000;-2000~+500;-500~+100
my $motif_source = "jasparvertebrates"; #only jasparvertebrates;UniPROBE;UCSC
my $significance = "10E-4"; #only 10E-4;10E-5
my $conservation = "0.05"; #only 0.05;0.01;0.005;0.001

my $input_gene_list = "/home/mulin/Workspace/gene_list";
my $output_regulators = "/home/mulin/Workspace/regulators";

my $result = GetOptions(
	"p=s" => \$promoter_range,
	"m=s" => \$motif_source,
	"s=s" => \$significance,
	"c=s" => \$conservation,
	"i=s" => \$input_gene_list,
	"o=s" => \$output_regulators
);	        

my %stringconvert;  
$stringconvert{"-500~+100"} = "500_100";
$stringconvert{"-2000~+500"} = "2000_500";
$stringconvert{"-8000~+2000"} = "8000_2000";
$stringconvert{"10E-4"} = "9d21";
$stringconvert{"10E-5"} = "11d51";
$stringconvert{"0.05"} = "500";
$stringconvert{"0.01"} = "100";
$stringconvert{"0.005"} = "50";
$stringconvert{"0.001"} = "10";	  
	        
my %genelist =();
open(IN,$input_gene_list);	 
open(OUT,">".$output_regulators);	
while(<IN>){
	chomp;
	$_ =~ s/^\s*//g;
	$_ =~ s/\s*$//g;
	$genelist{$_} = 1;
} 

my %factorlist =();
my %network_profile = ();
my $query_table = "hg19_".$stringconvert{$promoter_range}."_".$motif_source."_".$stringconvert{$significance}."_cusni_mm".$stringconvert{$conservation};
foreach my $onegene (keys %genelist){
	print "query gene: ".$onegene."\n";
	my $target = $dbh->selectall_arrayref("SELECT * FROM ${query_table} WHERE target = \"${onegene}\";");
	if ( scalar @$target > 0 ) {
		foreach my $arrayref (@$target){
			#print "factor: ".$onegene."\n";
			my $factor_gene = @$arrayref[3];
			next if($factor_gene =~ /,|;|:/);
			if(!defined($genelist{$factor_gene})){
				if(!defined($factorlist{$onegene."_".$factor_gene})){
					$factorlist{$onegene."_".$factor_gene} = $onegene."\t".abs(@$arrayref[7])."\t".$factor_gene."\t".@$arrayref[6]."\t".@$arrayref[4]."\t".@$arrayref[5]."\t".@$arrayref[1];
				}else{
					my $c_info = $factorlist{$onegene."_".$factor_gene};
					my $c_sig = (split("\t",$c_info))[1];
					if($c_sig < abs(@$arrayref[7])){
						$factorlist{$onegene."_".$factor_gene} = $onegene."\t".abs(@$arrayref[7])."\t".$factor_gene."\t".@$arrayref[6]."\t".@$arrayref[4]."\t".@$arrayref[5]."\t".@$arrayref[1];
					}
				}
			}
		}
	}else{
		next;
	}
}

foreach my $one_pair (sort keys %factorlist){
	print OUT $factorlist{$one_pair}."\n";
}
