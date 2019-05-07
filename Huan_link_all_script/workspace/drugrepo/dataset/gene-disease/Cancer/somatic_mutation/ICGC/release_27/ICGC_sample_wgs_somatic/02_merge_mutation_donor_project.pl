#将mutation_donor_project merge在一起。将./output/01_all_sample_mutation.txt 和./output/manifest.collaboratory.1556157173216.tsv merge 到一起，
#得./output/02_merge_mutation_donor_project.txt.gz

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/manifest.collaboratory.1556157173216.tsv";
my $f2 = "./output/01_unique_all_sample_mutation.txt";
my $fo1 = "./output/02_merge_mutation_donor_project.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, "| gzip >$fo1" or die $!;
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "chr\tpos\tref\talt\tfile_id\tdonor_id\tproject\n";

while(<$I1>)
{
    chomp;
    unless (/^repo_code/){
        my @f = split/\t/;
        my $file_id = $f[1];
        my $donor_id = $f[-3];
        my $project = $f[-2];
        my $v= "$donor_id\t$project";
        $hash1{$file_id}=$v;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^chr/){
        my @f =split/\t/;
        my $file_id = $f[-1];
        if (exists $hash1{$file_id}){
            my $v= $hash1{$file_id};
            my $output = "$_\t$v";
            print $O1 "$output\n";
        }
    }
}


