# 筛选在../../test_data/output/08_drug_primary_calculate_features_for_logistic_regression.txt中出现的
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/gdkb_cgi_oncokb_mtctscan/output/02_merge_mtctscan_all_sensitivity_oncotree.txt"
#得./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt",把./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt" 中的drug claim primary name去掉
#得./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt，得mtctscan信息文件得./output/04_in_huan_mtctscan_ori.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my $f1 ="/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/gdkb_cgi_oncokb_mtctscan/output/02_merge_mtctscan_all_sensitivity_oncotree.txt";
my $f2 ="../../test_data/output/08_drug_primary_calculate_features_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt"; #prediction media file
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/04_in_huan_mtctscan_ori.txt";  #in huan file 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1, %hash2 ,%hash3, %hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if (/^drug_name/){
        print $O2 "$_\n";
    }
    else{
        my $drug_name= $f[0];
        my $source = $f[19];
        my $implication_result = $f[12];
        my $oncotree_detail_ID = $f[-3];
        my $oncotree_main_ID = $f[-1];
        my $Drug_claim_primary_name = $drug_name;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        my $k1 = "$Drug_claim_primary_name\t$oncotree_detail_ID";
        my $k2 = "$Drug_claim_primary_name\t$oncotree_main_ID"; 
        my $quality = "1|effective|FDA|sensitivity|approved"; #不加条件筛选 来数据会有很多，所以，要进一步筛选，将implication_result 的质量控制提高门槛
        my $un_quality = "19|10|may";
        # if ($implication_result =~/$quality/i ){
        #    unless($implication_result =~/$un_quality/i){
               unless($source =~/civic/i){
                    push @{$hash1{$k1}},$_;
                    push @{$hash2{$k2}},$_; 
                }
    #        }
    #    }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_claim_primary_name/){
        print $O1 "$_\tmtctscan_cancer_type\n";
    }
    else{
        my $Drug_claim_primary_name =$f[0];
        my $cancer_oncotree_id_type = $f[1];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
        my $cancer_oncotree_id = $f[3];
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_id";
        if (exists $hash1{$k}){
            print $O1 "$_\tdetail\n";
            my @vs = @{$hash1{$k}};
            foreach my $v(@vs){
                print $O2 "$v\n";
            }
        }
        else{
            if (exists $hash2{$k} ){
                print $O1 "$_\tmain\n";
                my @vs = @{$hash2{$k}};
                foreach my $v(@vs){
                    print $O2 "$v\n";
                }
            }
        }
    }
}


close ($O1);

my $f3 ="./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl_claim.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo3 ="./output/04_merge_mtctscan_all_sensitivity_oncotree_chembl.txt";  #in huan file final
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $k = join ("\t",@f[1..23]);
    unless (exists $hash4{$k}){
        $hash4{$k} =1;
        print $O3 "$k\n";
    }
}
