
#将文件./output/09_huan_transform_ensg_symbol.txt和./output/08_huan_target_drug_indication_no_symbol.txt merge起来，
#使./output/08_huan_target_drug_indication_no_symbol.txt有symbol,并且和有symbol的文件./output/08_huan_target_drug_indication_symbol.txt共同输入到一个文件
#得文件./output/10_huan_target_drug_indication_final_symbol.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/08_huan_target_drug_indication_symbol.txt";
my $f2 ="./output/09_huan_transform_ensg_symbol.txt";
my $f3 ="./output/08_huan_target_drug_indication_no_symbol.txt";
my $fo1 ="./output/10_huan_target_drug_indication_final_symbol.txt"; 
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
    unless(/^query/){
        my $symbol = $f[3];
        my $ensg_id = $f[0];
        $hash2{$ensg_id} = $symbol;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $gene_symbol = $f[2];
        my $ensg_id = $f[-3];
        if (exists $hash2{$ensg_id} ){
            my $symbol = $hash2{$ensg_id};
            my $output = join ("\t",@f[0,1],$symbol,@f[3..21]);
            print $O1 "$output\n";
        }
        else{
            print $O1 "$_\n";
        }
    }
}
