#! /usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;

###############################################
if (!defined $ARGV[0]){die "
===== Usage =====
script.pl 
	-d --drug id			# in-house ID
	-t --target file		# Drug target list
	-g --genelist file		# Differently expressed gene list
	-i --id id_type			# 'sm'(gene symbol), 'id' (entrez gene id), 'up'(UniProt ID)
	-o --output folder		# Define output folder
[Optional]
	[-a --arbitrary component]	# User-defined component, separated by \",\"
	[-u --usrtf tf,]			# User-defined regulators, separated by \",\"
	[-m --matrix number]		# Matrix arguments in random walk: 0.9(default)
	[-l --length number]		# Define pathway length: 5(default)
	[-h --h_t_loop 0/1]		# Loop or not in head_tail.pl? 1 (Yes,defualt); 0 (No)
	[-n --nodes_max number],	# Max nodes in the final pathway, 3000(default)
	[-r --rank number],		# Get the TOPXXX DEG. 
	[-p --promoter region],		# Promoter range: -8000~+2000 (default); -2000~+500; -500~+100
	[-w --webdb DB_name],		# Database: UniPROBE(default);jasparvertebrates; UCSC
	[-s --sig value],		# P-value: 10E-4(default); 10E-5; 10E-6; 10E-7; 10E-8
	[-c --con value],		# Conservation value: 0.05(default); 0.01; 0.005; 0.001
	[-x --xpath number],    # top x paths to choose
";}

###############################################
sub filelen ($) {
	my $ret = 0;
	open(F, shift);
	$ret++ while (<F>);
	close F;
	return $ret;
}

my $id_type = 'id';
my $output_folder = "/var/www/drugresponse/workspace/test";
my $deg_list = "$output_folder/deg.list";
my $strict_mode;
my $drug;
my $target_list = "$output_folder/target.list"; 
my $promoter_range = "-8000~+2000"; 
my $database = "UniPROBE";  
my $significance = "10E-4"; #only 10E-4;10E-5
my $conservation = "0.05"; #only 0.05;0.01;0.005;0.001
my $rank='';  my $arbitrary=''; my $usrtf='';
my $matrix=0.9; my $length=5; my $loop=1; my $maxnodes=3000;
my $xpath = 10;
my $scriptdir = dirname(__FILE__);
GetOptions(
	"rank=i" => \$rank,
	"matrix=f" => \$matrix,
	"drug=s" => \$drug,
	"target=s" => \$target_list,
	"genelist=s" => \$deg_list,
	"promoter=s" => \$promoter_range,
	"webdb=s" => \$database,
	"sig=s" => \$significance,
	"con=s" => \$conservation,
	"length=i" => \$length,
	"h_t_loop=i" => \$loop,
	"output=s" => \$output_folder,
	"id=s" => \$id_type,
	"nodes_max=i" => \$maxnodes,
	"arbitrary=s" => \$arbitrary,
	"usrtf=s" => \$usrtf,
	"xpath=i" => \$xpath,
	#"quickstrict" => \$strict_mode,
);

die "Please create a folder to store the results!\n" if (!defined $output_folder);
$output_folder =~ s/\/$// if ($output_folder =~/\/$/); 
if (!-e $output_folder) {
	mkdir "$output_folder" or die "can not create $output_folder\n";
}

open (LOG,'>',"$output_folder/LOG") or die "can not create $output_folder/LOG: $!\n";

# --- Generate Regulator  ---
print STDERR "+ Generating regulators ...\n";
my $cmd = "  perl $scriptdir/generate_regulators-test.pl -i $deg_list -r $output_folder/regulators.list -o $output_folder/TF.value.tab -p $promoter_range -m $database -s 10E-5 -c $conservation " . ($usrtf ? "-a $usrtf" : "");
print STDERR $cmd . "\n";
`$cmd`;

my $tf_num = filelen("$output_folder/regulators.list");
if ($tf_num<=0) {
	print LOG "ERROR: No regulators found under the condition, please try looser p-values or longer promoter range.\n";
	close LOG;
	exit;
}
print LOG "INFO : Got $tf_num regulators by PWM scan.\n";

# ---  random walk  ---
print STDERR "+ Random walking ...\n";
print STDERR "  php $scriptdir/rwr-test.php -iY -s$id_type -m$maxnodes -a$arbitrary -e$target_list -r$output_folder/regulators.list -o$output_folder/rwr.out\n";
`php $scriptdir/rwr-test.php -iY -s$id_type -m$maxnodes -a$arbitrary -e$target_list -r$output_folder/regulators.list -o$output_folder/rwr.out`;
#`awk -F\"\\t\" \'\{print \$1\"\\t\"\$3\"\\t\"\$2\}\' $output_folder/rwr.out  > $output_folder/pathway_rwr.sif`;


# --- Refine path length  ---
print STDERR "+ Refining pathways ...\n";
print STDERR "  perl $scriptdir/path_constraint.pl -n $xpath -r $output_folder/regulators.list -t $target_list -s $output_folder/rwr.out -l $length -o $output_folder/pathway\n";
`perl $scriptdir/path_constraint.pl -n $xpath -r $output_folder/regulators.list -t $target_list -s $output_folder/rwr.out -l $length -o $output_folder/pathway`;
my $edge_final = filelen("$output_folder/pathway.sif");
if ($edge_final<=0) {
	print LOG "ERROR: No links found by the algorithm, please try looser options.\n";
	close LOG;
	exit;
}



#`awk -F\"\\t\" \'\{print \$1\"\\n\"\$3\}\' $output_folder/pathway_len.sif | sort -u > $output_folder/pathway_len.nodes`;
#`cat $output_folder/pathway_len.nodes | while read element;do
#	grep \"\\b\$element\\b\" $output_folder/regulators.list
#done > $output_folder/pathway.TF`; 
#`cat $output_folder/pathway_len.nodes | while read element;do
#	grep \"\\b\$element\\b\" $target_list
#done > $output_folder/pathway.target`; 

# --- Add TF-DNA and Drug-Target ---
#`perl $scriptdir/head_tail.pl -l $loop -f $output_folder/pathway_len.sif -r $output_folder/pathway.TF -t $output_folder/pathway.target -d $drug -s $output_folder/TF.value.tab -p $significance > $output_folder/pathway.sif`;
#`awk -F\"\\t\" \'\{print \$1\"\\n\"\$3\}\' $output_folder/pathway.sif | sort -u > $output_folder/pathway.nodes`;


# ---  LOG file  ---
#my $edges = `wc -l $output_folder/pathway_rwr.sif | cut -d' ' -f1`; chomp $edges;
#my $id_type_log = 'Gene Symbol' if ($id_type eq 'sm');$id_type_log = 'Entrez Gene ID' if ($id_type eq 'id');$id_type_log = 'UniProt ID' if ($id_type eq 'up');
#if ($rank eq '') {$rank='N/A'; } 
#my $tf_final=`wc -l $output_folder/pathway.TF | cut -d' ' -f1`; chomp $tf_final;
#my $target_final=`wc -l $output_folder/pathway.target | cut -d' ' -f1`; chomp $target_final;
##my $t_path=`wc -l $output_folder/pathway.sif | cut -d' ' -f1`; chomp $t_path;
##my $tf_dna = $t_path - $target_final - $edge_final;
#my $target_num=`wc -l $target_list | cut -d' ' -f1`; chomp $target_num;
##my $node_num=`wc -l $output_folder/pathway.nodes | cut -d' ' -f1`; chomp $node_num;
#my $len_node_num=`wc -l $output_folder/pathway_len.nodes | cut -d' ' -f1`; chomp $len_node_num;


#print LOG 
#"ARGS\tVALUES
#Path_Length\t$length
#Targets\t$target_final($target_num)
#Regulators\t$tf_final($tf_num)
#Path_Edges\t$edge_final($edges)
#Max_Nodes\t$maxnodes
#Top_Rank\t$rank
#P-value\t$significance
#Conservation\t$conservation
#Promoter_Range\t$promoter_range
#Database\t$database
#ID_Type\t$id_type_log
#";


# assemble  network
print STDERR "+ Assembling network\n";
print STDERR "  php $scriptdir/assemble-network.php -d $output_folder\n";
`php $scriptdir/assemble-network.php -d $output_folder`;
close LOG;



