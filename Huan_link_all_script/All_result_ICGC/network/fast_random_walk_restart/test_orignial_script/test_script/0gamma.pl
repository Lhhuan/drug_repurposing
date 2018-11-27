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
	[-T --Tfnum number],    # select Tfnum regulators (for rwr);
	[-D --DEGnum number],   # number of deg to dispay 
";}

###############################################
sub filelen ($) {
	my $ret = 0;
	open(F, shift);
	$ret++ while (<F>);
	close F;
	return $ret;
}

my $id_type; my $output_folder; my $deg_list; my $strict_mode; my $drug; my $target_list; 
my $promoter_range = "-8000~+2000"; 
my $database = "UniPROBE";  
my $significance = "10E-4"; #only 10E-4;10E-5
my $conservation = "0.05"; #only 0.05;0.01;0.005;0.001
my $rank='';  my $arbitrary=''; my $usrtf='';
my $matrix=0.9; my $length=5; my $loop=1; my $maxnodes=1000; my $Tfnum = 20;
my $xpath = 10; my $DEGnum = 4;
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
	"Tfnum=i" => \$Tfnum,
	"arbitrary=s" => \$arbitrary,
	"usrtf=s" => \$usrtf,
	"xpath=i" => \$xpath,
	"DEGnum=i" => \$DEGnum
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
my $cmd = "  perl $scriptdir/generate_regulators.pl -i $deg_list -r $output_folder/regulators.list -o $output_folder/TF.value.tab -p $promoter_range -m $database -s 10E-5 -c $conservation " . ($usrtf ? "-a $usrtf" : "");
print STDERR $cmd . "\n";
`$cmd`;

my $tf_num = filelen("$output_folder/regulators.list");
if ($tf_num<=0) {
	print LOG "ERROR  : No regulators found under the condition, please try looser p-values or longer promoter range.\n";
	close LOG;
	exit;
}
print LOG "INFO   : Got $tf_num regulators by PWM scan.\n";

# ---  random walk  ---
print STDERR "+ Random walking ...\n";
print STDERR "  php $scriptdir/rwr.php -iY -f$Tfnum -q$scriptdir/invQ1-$matrix.tab -u$scriptdir/U-$matrix.tab -v$scriptdir/V-$matrix.tab -l$scriptdir/lamda-$matrix.tab -s$id_type -m$maxnodes -a$arbitrary -e$target_list -r$output_folder/regulators.list -o$output_folder/rwr.out\n";
my $rwr_log = `php $scriptdir/rwr.php -iY -f$Tfnum -q$scriptdir/invQ1-$matrix.tab -u$scriptdir/U-$matrix.tab -v$scriptdir/V-$matrix.tab -l$scriptdir/lamda-$matrix.tab -s$id_type -m$maxnodes -a$arbitrary -e$target_list -r$output_folder/regulators.list -o$output_folder/rwr.out`;
print LOG $rwr_log;
exit if $rwr_log =~ /ERROR:/;

# --- Refine path length  ---
print STDERR "+ Refining pathways ...\n";
print STDERR "  perl $scriptdir/path_constraint.pl -n $xpath -r $output_folder/regulators.list -t $target_list -s $output_folder/rwr.out -l $length -o $output_folder/pathway\n";
my $pc_log = `perl $scriptdir/path_constraint.pl -n $xpath -r $output_folder/regulators.list -t $target_list -s $output_folder/rwr.out -l $length -o $output_folder/pathway`;
print LOG $pc_log;
my $edge_final = filelen("$output_folder/pathway.sif");
if ($edge_final<=0) {
	print LOG "ERROR  : No edges found by the algorithm, please try looser options.\n";
	close LOG;
	exit;
} else {
	print LOG "INFO   : Final edges (drugs and DEGs not included) found in pathway: $edge_final.\n";
}

# assemble  network
print STDERR "+ Assembling network\n";
print STDERR "  php $scriptdir/assemble-network.php -d$output_folder -n$DEGnum\n";
`php $scriptdir/assemble-network.php -d$output_folder -n$DEGnum`;
close LOG;

`cp $scriptdir/README.txt $output_folder/README.txt`;

