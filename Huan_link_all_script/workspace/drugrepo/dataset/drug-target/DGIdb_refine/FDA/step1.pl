#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./interactions_v3.tsv";
my $fo = "./interactions_v3-FDA.txt";


open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"gene_name\tgene_claim_name\tentrez_id\tinteraction_claim_source\tinteraction_types\tdrug_claim_name\tdrug_claim_primary_name\tdrug_name\tdrug_chembl_id\n";
#将interactions_v3.tsv中的源于FDA的数据筛选出来。
while(<$I>)
{
   chomp;
   my @f = split/\t/;
   my $source = $f[3];
   if ($f[3] =~ /FDA/){
       print $_."\n"
   }
}

close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

