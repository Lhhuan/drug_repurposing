##将huan_target_drug_indication_final.txt没有gene symbol，但是有ensg_id的基因所在列分离开，
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_final.txt";
my $fo1 ="./huan_target_drug_indication_symbol.txt";#有symbol的文件
my $fo2 ="./huan_target_drug_indication_no_symbol.txt"; #没有symbol的文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
select $O1;
print "$title\n";
select $O2;
print "$title\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $gene_symbol = $f[2];
         my $ensg_id = $f[19];
         if($gene_symbol=~/unknown|NULL/){
             if($ensg_id=~/ENSG*/){
                 print $O2 "$_\n";
             }
             else{
                 print $O1 "$_\n";
             }

         }
         else{
             print $O1 "$_\n";
         }
     }
}

