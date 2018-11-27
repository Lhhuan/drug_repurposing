#把huan_target_drug_indication_final_symbol.txt中的drug分为inhibitor和agonist，即是inhibitor又是agonist的填both,得huan_target_drug_indication_final_symbol_drug-class.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_final_symbol.txt";
my $fo1 ="./huan_target_drug_indication_final_symbol_drug-class.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type";
select $O1;
print "$title\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $drug=$f[6];
    if($drug=~/suppressor|antagonist|inhibitor|blocker/){
         $drug =~s/\,/ , /g;
        if($drug=~/activator|sensitizer|stimulant/){
            print $O1 "$_\tBoth\n";
        }
        elsif($drug=~/\bagonist\b/){
            print $O1 "$_\tBoth\n";
        }
        else{
            print $O1 "$_\tI\n";
        }
    }
    elsif($drug=~/activator|agonist|stimulator|stimulant|potentiator|positive|enhancer|inducer/){
        if($drug=~/inhibitor|blocker|antagonist/){
            print $O1 "$_\tBoth\n";
        }
        else{
            print $O1 "$_\tA\n";
        }

    }
    else{
        print $O1 "$_\tUnknown\n";

    }
}
