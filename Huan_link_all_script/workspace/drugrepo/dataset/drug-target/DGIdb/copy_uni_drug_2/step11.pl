#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./step10_drug_unmatch_indication.txt"; #将step1-interactions_v3-uni-drug_database.txt中的drug-name或chembl,不加数据库名字去重输出。
my $fo = "./step11-uni-unmatchdrug.txt";
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print "drug_chembl_id|drug_claim_name\n";
my %hash1;
while(<$I>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
        my @f = split/\t/;
        unless(exists $hash1{$f[0]}){
        print "$f[0]\n";
        $hash1{$f[0]} = 1;
        }
   }
}
close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";