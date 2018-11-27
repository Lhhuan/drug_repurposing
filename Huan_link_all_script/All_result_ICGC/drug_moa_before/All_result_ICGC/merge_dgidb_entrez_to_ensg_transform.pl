#将DGIdb_all_target_drug_indication_refine.txt文件中加入ensg_id 一列。并且把Drug_stage这列丢掉。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./DGIdb_all_target_drug_indication_refine.txt";
my $f2 ="./DGIdb_Entrez_id-ENSG_ID.txt";
my $fo1 ="./DGIdb_all_target_drug_indication_trans.txt"; #将DGIdb_all_target_drug_indication_refine.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID";
#my $title = "Indication_ID\tIndication\tDOID\tDO_term\tHPO_ID\tHPO_term\n";
select $O1;
print "$title\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $Entrez_id = $f[5];
         my $k = join ("\t", @f[0,1,3..19]);
         push @{$hash1{$f[5]}},$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Entrez_id/){
         my $Entrez_id = $f[0];
         my $ensg_id = $f[1];
         $hash2{$Entrez_id} = $ensg_id;
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
            my $s = "$v\tNA";
            print $O1 "$s\n";
        }
    }
}

