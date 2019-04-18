#用./output/all_id_indication_do_hpo_oncotree.txt为./output/huan_target_drug_indication.txt添加indication id，得./output/07_huan_target_drug_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/huan_target_drug_indication.txt";
my $f2 ="./output/all_id_indication_do_hpo_oncotree.txt";
my $fo1 ="./output/07_huan_target_drug_indication.txt"; #将DGIdb_all_target_drug_indication_trans.txt和CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里。
my $fo2 ="./output/07_error.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
print $O1 "$title\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f = split/\t/;
     unless(/^Drug_chembl_id/){
         my $Drug_indication = $f[18];#是Drug_indication|Indication_class
         $Drug_indication =~s/"//g;
         $Drug_indication =~s/^\s+//;
         $Drug_indication=lc($Drug_indication);#转换成小写
         $Drug_indication =~ s/\(//g;
         $Drug_indication =~ s/\)*//g;
         my $v = join ("\t",@f[0..20]);
         push @{$hash1{$Drug_indication}},$v;
         
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $indication_id = $f[0];
         my $indication = $f[1];
         $indication =~ s/"//g;
         $indication =~s/^\s+//;
         $indication = lc($indication);
         $indication =~ s/\(//g;
         $indication =~ s/\)//g;
         $hash2{$indication} = $indication_id;
     }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            print $O1 "$v\t$s\n";
        }
    }
    else {
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            print $O1 "$v\tNA\n";
        }
        print $O2 "$ID\n";
    }
}
