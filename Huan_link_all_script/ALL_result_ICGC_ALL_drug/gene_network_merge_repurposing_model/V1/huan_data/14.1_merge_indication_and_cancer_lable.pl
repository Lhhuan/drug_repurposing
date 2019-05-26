#将./output/09_out_of_training_dataset_repurposing_data.txt 和 ./output/13_indication_and_cancer_lable.txt merge到一起，得./output/14_out_of_training_dataset_repurposing_label.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/13_indication_and_cancer_lable.txt";
my $f2 ="./output/09_out_of_training_dataset_repurposing_data.txt";
my $fo1 ="./output/14_out_of_training_dataset_repurposing_label.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name= $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $cancer_id = $f[2];
        my $lable = $f[3];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$cancer_id";
        my $v= "$Drug_claim_primary_name\t$lable";
        $hash1{$k}=$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\tDrug_claim_primary_name\tindication_or_repurposing\n";
    }
    else{
        my $Drug= $f[0];
        my $cancer_oncotree_id = $f[1];
        my $k = "$Drug\t$cancer_oncotree_id";
        if (exists $hash1{$k}){
            my $lable = $hash1{$k};
            print $O1 "$_\t$lable\n";
        }
        else{
            print "$k\n";
        }
        
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
