#将interactions_v3.tsv及drugbank中chembl_id或drug_claim_name中的drug筛出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi = "./statistic-drug_gene.txt";
my $fo  ="./statistic1-uni_drug_gene.txt";
my $fo1  ="./statistic1-uni_gene.txt";

open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "gene|entrez_id\t";
select $O;
print print"drug_chembl_id|drug_claim_name\tentrez_id|gene_claim_name\tinteraction_types\n";

my (%hash1,%hash2);
while(<$I>)
{
   chomp;
   unless(/^drug_chembl/){
       my @f = split/\t/;
       my $entrez_id = $f[1];
       unless(exists $hash1{$entrez_id}){
              print $O1 "$entrez_id\n";
              $hash1{$entrez_id} = 1;
       }
       unless(exists $hash2{$_}){
           print $O "$_\n";
           $hash2{$_} = 1;

       }
   }
}
