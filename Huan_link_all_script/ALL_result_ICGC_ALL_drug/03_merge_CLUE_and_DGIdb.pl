#将./output/DGIdb_all_target_drug_indication_trans.txt和./output/CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里，并在最后加一列source,得./output/huan_target_drug_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/DGIdb_all_target_drug_indication_trans.txt";
my $f2 ="./output/CLUE_REPURPOSING_indication_target_trans.txt";
my $fo1 ="./output/huan_target_drug_indication.txt"; #将DGIdb_all_target_drug_indication_trans.txt和CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source";
#my $title = "chembl_id\tdrug_name\tmoa\tgene_symbol\tdisease_area\tindication\tphase\tensg_id";
select $O1;
print "$title\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
     unless(/^Drug_chembl_id/){
         print $O1 "$_\tDGIdb\n";
         
     }
}


while(<$I2>) #CLUE_REPURPOSING_indication_target_trans.txt文件对Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name进行专门的格式整理。
{
    chomp;
    my @f= split /\t/;
     unless(/^chembl_id/){
         my $chembl_id = $f[0];
         my $drug_name = $f[1];
         my $moa = $f[2];
         my $gene_symbol = $f[3];
         my $disease_area = $f[4];
         my $indication = $f[5];
         my $phase = $f[6];
         my $ensg = $f[7];
         if ($chembl_id =~/^CHEMBL/){ #有chembl_id就把chembl_id输出到Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name，
             my $k = "$chembl_id\t$chembl_id\t$gene_symbol\tNA\tNA\tNA\t$moa\tNA\t$drug_name\t$drug_name\t$chembl_id\t$phase\tNA\t$disease_area\t$indication\tNA\t$phase\tNA\t$indication\t$ensg\tCLUE_REPURPOSING";
             print $O1 "$k\n";
         }
         else{#没有chembl_id就把drug_name输出到Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name，
             my $k = "$drug_name\t$drug_name\t$gene_symbol\tNA\tNA\tNA\t$moa\tNA\t$drug_name\t$drug_name\t$chembl_id\t$phase\tNA\t$disease_area\t$indication\tNA\t$phase\tNA\t$indication\t$ensg\tCLUE_REPURPOSING";
             print $O1 "$k\n";
         }
     }
}
