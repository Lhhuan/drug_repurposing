#! /usr/bin/perl -w
use strict;
use Getopt::Long;

###############################################
if (!defined $ARGV[0]){die "
===== Usage =====
script.pl 
	-o --old file		# regulators.list
	-u --usr file		# use defined TF list
	> output
";}
###############################################
my $output_folder = "/home/zpliu/drug_network/CMAP/test0beta";
my $usrtf = $ARGV[0];
if ($usrtf ne '') {
	my @usrtf = split (/\,/,$usrtf);
	foreach (@usrtf){
		my $a = uc($_);
		my $tmp = `grep -P \"\\b$_\\b\" $output_folder/regulators.list`; print "$tmp\t$a\n";
		`echo $_ >> $output_folder/regulators.list` if ($tmp eq '');
	}
}
