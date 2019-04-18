#用./output/unique_Drug_claim_primary_name_Drug_chembl_id.txt 中Drug_claim_primary_name从./output/huan_target_drug_indication_final_symbol_drug-class.txt提取其他的信息
#得./output/refined_huan_target_drug_indication_final_symbol.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/unique_Drug_claim_primary_name_Drug_chembl_id.txt";
my $f2 ="./output/huan_target_drug_indication_final_symbol_drug-class.txt";
my $fo1 ="./output/refined_huan_target_drug_indication_final_symbol.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";  
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type";
print $O1 "$title\n";
my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $Drug_chembl_id = $f[2];
        my $v = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_chembl_id";
        push @{$hash1{$Drug_claim_primary_name}},$v; #有的Drug_claim_primary_name有多个chembl
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Gene_symbol = $f[1];
        my $Entrez_id = $f[2];
        my $Interaction_types = $f[3];
        my $Drug_claim_primary_name = $f[4];
        my $Max_phase = $f[6];
        my $First_approval = $f[7];
        my $Indication_class = $f[8];
        my $Drug_indication = $f[9];
        my $Drug_indication_source = $f[10];
        my $Clinical_phase = $f[11];
        my $Link_Refs = $f[12];
        my $Drug_indication_Indication_class = $f[13];
        my $ENSG_ID = $f[14];
        my $Final_source = $f[15];
        my $Indication_ID = $f[16];
        my $Drug_type = $f[17];
        if (exists $hash1{$Drug_claim_primary_name}){
            my @vs =  @{$hash1{$Drug_claim_primary_name}};
            foreach my $v (@vs){
                my @f1 = split/\t/,$v;
                my $Drug_chembl_id_Drug_claim_primary_name = $f1[0]; #
                $Drug_chembl_id_Drug_claim_primary_name = uc($Drug_chembl_id_Drug_claim_primary_name);#为了避免同一种Drug_chembl_id_Drug_claim_primary_name 有两个名字A-B和AB而造成的重复，此处对Drug_chembl_id_Drug_claim_primary_name进行处理。
                $Drug_chembl_id_Drug_claim_primary_name =~s/{//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/}//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/"//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/\(//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/\)//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/\s+//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/-//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/_//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/\]//g;
                $Drug_chembl_id_Drug_claim_primary_name =~s/\[//g;
                my $Drug_chembl_id = $f1[1];
                my $out = "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id\t$Interaction_types\t$Drug_claim_primary_name\t$Drug_chembl_id";
                my $out2 = join("\t",@f[6..17]);
                my $output = "$out\t$out2";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}


