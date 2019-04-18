#把./output/11_huan_target_drug_indication_final_symbol_refine.txt中的drug分为inhibitor和agonist，得./output/huan_target_drug_indication_final_symbol_drug-class.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/11_huan_target_drug_indication_final_symbol_refine.txt";
my $fo1 ="./output/huan_target_drug_indication_final_symbol_drug-class.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";  
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type";
select $O1;
print "$title\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $drug=$f[3];
    unless(/^Drug_chembl_id/){
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
}
