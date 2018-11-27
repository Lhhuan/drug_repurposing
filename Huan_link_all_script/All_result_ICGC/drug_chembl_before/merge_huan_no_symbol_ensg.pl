#将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件.
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_symbol.txt";
my $f2 ="./huan_target_drug_indication_no_symbol.txt";
my $f3 ="./huan_transform_ensg_symbol.txt";
my $fo1 ="./huan_target_drug_indication_final_symbol.txt"; #将文件huan_transform_ensg_symbol.txt和huan_target_drug_indication_no_symbol.txt merge起来，使huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件huan_target_drug_indication_symbol.txt共同输入到一个文件.
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
select $O1;
print "$title\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         print $O1 "$_\n";
     }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $gene_symbol = $f[2];
         my $ensg_id = $f[19];
         push@{$hash2{$ensg_id}},$_;
     }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $symbol = $f[3];
         my $ensg_id = $f[0];
         $hash3{$ensg_id} = $symbol;
     }
}
for my $k3(keys %hash3){
    if(exists $hash2{$k3}){
        my @v2 = @{$hash2{$k3}};
        my $v3 = $hash3{$k3};
        foreach my $v2(@v2){
            my @f=split/\t/,$v2;
            my $k= join ("\t",@f[0,1],$v3,@f[3..21]);
            print $O1 "$k\n";
        }
    }
}