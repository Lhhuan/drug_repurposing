#从./output/08_drug_primary_calculate_features_for_logistic_regression.txt过滤出./output/07_final_positive_and_negative.txt需要的feature，得./output/09_media_filter_test_data_for_logistic_regression.txt
#提取./output/09_media_filter_test_data_for_logistic_regression.txt中需要的feature，得 ./output/09_filter_test_data_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/08_drug_primary_calculate_features_for_logistic_regression.txt";
my $f2 ="./output/07_final_positive_and_negative.txt";
my $fo1 ="./output/09_media_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_claim_primary_name/){
        print $O1 "$_\tdrug_repurposing\n";
    }
    else{
        $_ =~ s/^\s+//g;
        my $Drug_claim_primary_name = $f[0];
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        my $cancer_oncotree_id= $f[3]; 
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k} =$_;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_term_detail/){
        my $Drug= $f[4];
        $Drug =~s/\(.*?$//g;
        $Drug =uc($Drug);
        $Drug =~ s/"//g;
        $Drug =~ s/'//g;
        $Drug =~ s/\s+//g;
        $Drug =~ s/,//g;
        $Drug =~s/\&/+/g;
        $Drug =~s/\)//g;
        $Drug =~s/\//_/g;
        my $oncotree_detail_ID= $f[1];
        my $oncotree_main_ID= $f[3];
        my $sample_type = $f[5];
        my $sample_value = $f[6];
        my $k1 = "$Drug\t$oncotree_detail_ID";
        my $k2= "$Drug\t$oncotree_main_ID";
        my $v = "$sample_value";
        # $hash2{$k2}=$v;
        # $hash3{$k3}=$v;
        if (exists $hash1{$k1}){
            my $features = $hash1{$k1};
            my $output = "$features\t$sample_value";
            print $O1 "$output\n";
        }
        else{
            if (exists $hash1{$k2}){
                my $features = $hash1{$k2};
                my $output = "$features\t$sample_value";
                print $O1 "$output\n";
            }
        }

    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 ="./output/09_media_filter_test_data_for_logistic_regression.txt";
my $fo2 ="./output/09_filter_test_data_for_logistic_regression.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $k = join ("\t",@f[1..17]);
    unless (exists $hash4{$k}){
        $hash4{$k} =1;
        print $O2 "$k\n";
    }
}

