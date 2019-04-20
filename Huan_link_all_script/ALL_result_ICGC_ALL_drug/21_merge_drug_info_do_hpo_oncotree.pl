#把./output/refined_huan_target_drug_indication_final_symbol.txt和./output/all_id_indication_do_hpo_oncotree.txt merge 在一起，得./output/21_all_drug_infos.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/refined_huan_target_drug_indication_final_symbol.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/all_id_indication_do_hpo_oncotree.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/21_all_drug_infos.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my $title = "Drug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";  
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";
print $O1 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $indicatuion_id =$f[-2];
         push @{$hash1{$indicatuion_id}},$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Indication_ID/){
         my $indicatuion_id =$f[0];
         my $v= join("\t",@f[2..9]);
         $hash2{$indicatuion_id} = $v;
     }
}

foreach my $id (sort keys %hash1){
    #print $O3 "$ensg_id\n";
    if (exists $hash2{$id}){
        my @drugs = @{$hash1{$id}};
        my $indicatuion= $hash2{$id};
       foreach my $drug(@drugs){
           print $O1 "$drug\t$indicatuion\n";
       }
    }
    else{
        print STDERR "$id\n";
    }
}