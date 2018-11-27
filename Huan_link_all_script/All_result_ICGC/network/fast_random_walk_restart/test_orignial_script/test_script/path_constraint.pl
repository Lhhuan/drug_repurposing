#! /usr/bin/perl -w
use strict;
use Getopt::Long;
use Data::Dumper;

###############################################
#  To cut pathway to <5 length

if (!defined $ARGV[0]){die"
=====  USAGE  =====
script
	-r --regulator file		# list of regulators
	-t --target file		# list of targets
	-s --sif file			# rwr output file
	-l --length number		# define path length, 5(default)
	-o --output f		# f1-sif format
	-n --ntop           # top n paths to select (default: 10)
";}

###############################################

my $reg_file; my $target_file; my $pathway_file; my $output;
my $length=5; my $intra=1; my $norepeat=0; my $ntop = 10;
GetOptions(
	"regulator=s" => \$reg_file,
	"target=s" => \$target_file,
	"sif=s" => \$pathway_file,
	"length=s" => \$length,
	"output=s" => \$output,
	"ntop=s" => \$ntop
);

sub getScore(@$%) {
	my ($stack, $p, $ppi) = @_;
	my $ret = 1;
	for (my $i=0; $i<$#$stack; $i++) {
		$ret *= $ppi->{$stack->[$i]}{$stack->[$i+1]};
	}
	return $ret * $ppi->{$p}{$stack->[$#$stack]};
}

# --- Global variant ---
# my @regulators=<$reg_file>;
# my @targets = <$target_file>;

my %regulators = ();
my %targets    = ();
open(RF, $reg_file) or die "Cannot open file $!";
while (my $line =<RF>) {
	$line =~s/^\s+|\s+$//;
	next if (!$line);
	$regulators{$line} = 1;
}
close(RF);

open(RF, $target_file) or die "Cannot open file $!";
while (my $line =<RF>) {
	$line =~s/^\s+|\s+$//;
	next if (!$line);
	$targets{$line} = 1;
}
close(RF);

my %ppi = (); my $edgenum = 0;
open(RF, $pathway_file) or die "Cannot open file $!";
while (my $line =<RF>) {
	$line =~s/^\s+|\s+$//;
	next if (!$line);
	my @items = split /\t/, $line;
	$ppi{$items[0]}{$items[2]} = $items[1];
	$ppi{$items[2]}{$items[0]} = $items[1];
	$edgenum ++;
}
close(RF);

### Depth-first search ###
my @stacks        = ();
my %pathvisited   = ();
my %pathfound     = ();

foreach my $target (keys %targets) {
	push @stacks, [$target];
}

foreach my $stack (@stacks) {
	my @paths = @{$stack};
	while (@paths) {
		my $p1 = $paths[-1]; 
		my $p2 = "";
		foreach my $p (keys %{$ppi{$p1}}) {
			if (exists $regulators{$p}) {
				$pathfound{join("/", @paths) . "/$p"} = getScore(\@paths, $p, \%ppi);
			} elsif (grep {$_ eq $p} @paths
				  or @paths>=$length
				  or exists $pathvisited{join("/", @paths) . "/$p"}) {
				next;
			} else {
				$p2 = $p;
				$pathvisited{join("/", @paths) . "/$p"} = 1;
				push @paths, $p;
				last;
			}	
		}
		pop @paths if ($p2 eq "");
	}
	
}

open(O, ">$output.sif");
open(N, ">$output.nodes");
open(F, ">$output.tf");
open(T, ">$output.target");
my (%sif, %nodes, %tf, %target);
my $x = 0;
foreach my $p (sort { $pathfound{$b} <=> $pathfound{$a} }  keys %pathfound) {
	last if ($x++ >= $ntop);
	
	my @proteins = split(/\//, $p);
	for (my $i=0; $i<$#proteins; $i++) {
		if (exists $regulators{$proteins[$i]} ) {
			$tf{$proteins[$i]} = 1;
		} elsif (exists $targets{$proteins[$i]}) {
			$target{$proteins[$i]} = 1;
		} else {
			$nodes{$proteins[$i]} = 1;
		}
		
		$sif{$proteins[$i] . "\t" . $proteins[$i+1]} = $ppi{$proteins[$i]}{$proteins[$i+1]} if (
			!exists $sif{$proteins[$i] . "\t" . $proteins[$i+1]} and !exists $sif{$proteins[$i+1] . "\t" . $proteins[$i]}
		);
	}
	if (exists $regulators{$proteins[$#proteins]} ) {
		$tf{$proteins[$#proteins]} = 1;
	} elsif (exists $targets{$proteins[$#proteins]}) {
		$target{$proteins[$#proteins]} = 1;
	} else {
		$nodes{$proteins[$#proteins]} = 1;
	}
}

foreach (keys %sif) {
	my @ps = split /\t/, $_;
	print O $ps[0] ."\t". $sif{$_} ."\t". $ps[1] . "\n";
}

print N $_."\n" foreach (keys %nodes);
print F $_."\n" foreach (keys %tf);
print T $_."\n" foreach (keys %target);
print "INFO   : Final drug targets in pathway: " . scalar(keys %target) . ".\n";
print "INFO   : Final regulators in pathway: " . scalar(keys %tf) . ".\n";
print "INFO   : Final other nodes (drugs and DEGs not included) in pathway: " . scalar(keys %nodes) . ".\n";


#my @nodekeys = keys %nodes;
#for (my $i=0; $i<$#nodekeys; $i++) {
#	for (my $j=$i+1; $j<=$#nodekeys; $j++) {
#		if (exists $ppi{$nodekeys[$i]}{$nodekeys[$j]}) {
#			print O $nodekeys[$i] . "\t" . $ppi{$nodekeys[$i]}{$nodekeys[$j]} . "\t" . $nodekeys[$j]. "\n";
#		}
#	}
#}
close(O);
close(N);
close(F);
close(T);

