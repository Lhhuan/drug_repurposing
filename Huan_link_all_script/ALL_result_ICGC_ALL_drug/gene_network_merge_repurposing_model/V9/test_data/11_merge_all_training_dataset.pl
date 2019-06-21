#将./output/09_filter_test_data_for_logistic_regression.txt 和../validation/gdkb_cgi_oncokb_mtctscan/output/05_filter_mtctscan_use_to_validation_positive_prediction.txt
#merge 到一起，得./output/11_all_training_dataset.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/09_filter_test_data_for_logistic_regression.txt";
my $f2 ="../validation/gdkb_cgi_oncokb_mtctscan/output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";
my $fo1 ="./output/11_all_training_dataset_media.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^cancer_oncotree_id_type/){
        print $O1 "$_\n";
    }
    else{
       print $O1 "$_\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^cancer_oncotree_id_type/){
       print $O1 "$_\t1\n";
    }
}

close($O1);

#--------------------------------------------去重，即是positive 又是negative的，去掉，
my $f4 ="./output/11_all_training_dataset_media.txt";
my $fo3 ="./output/11_all_training_dataset.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    if (/^cancer_oncotree_id_type/){
        print $O3 "$_\n";
    }
    else{
        my $cancer_oncotree_id_type = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $k = "$cancer_oncotree_id_type\t$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        push @{$hash5{$k}},$_;
    }
}

foreach my $k(sort keys %hash5){
    my @vs = @{$hash5{$k}};
    my %hash7;
    @vs = grep {++$hash7{$_}<2} @vs;
    # @invs = grep { ++$hash36{$_} < 2 } @invs;
    my $num = @vs;
    unless($num>1){
        foreach my $v(@vs){
            print $O3 "$v\n";
        }
    }
}


