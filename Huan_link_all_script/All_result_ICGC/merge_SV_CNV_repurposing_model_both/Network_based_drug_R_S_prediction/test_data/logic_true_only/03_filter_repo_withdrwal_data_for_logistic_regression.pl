#根据"/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt"中的drug cancer pair 在"./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt"
#中提取repo_or_withdrawl 的logistic_regression信息。得./output/03_filter_repo_withdrwal_data_for_logistic_regression.txt,并把repo和indication的值设为1，Withdrawn|Terminated设为0，得"./output/03_final_filter_repo_withdrwal_data_for_logistic_regression.txt"
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/Network_based_drug_R_S_prediction/test_data/output/01_drug_taregt_cancer_gene_differ.txt";
my $f2 ="./output/02_drug_primary_calculate_for_network_based_repo_logistic_regression_data.txt";
my $fo1 ="./output/03_filter_repo_withdrwal_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug= $f[0];
        $Drug =uc($Drug);
        $Drug =~ s/"//g;
        $Drug =~ s/'//g;
        $Drug =~ s/\s+//g;
        $Drug =~ s/,//g;
        $Drug =~s/\&/+/g;
        $Drug =~s/\)//g;
        $Drug =~s/\//_/g;
        my $oncotree_main_ID= $f[10];
        my $repo_or_withdrawl = $f[11];
        my $k= "$Drug\t$oncotree_main_ID";
        $hash1{$k}=$repo_or_withdrawl;
    }
}




while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_claim_primary_name/){
        print $O1 "$_\trepo_info\n";
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


        my $Drug_chembl_id_Drug_claim_primary_name= $f[1];
        $Drug_chembl_id_Drug_claim_primary_name = uc ($Drug_chembl_id_Drug_claim_primary_name);
        $Drug_chembl_id_Drug_claim_primary_name =~ s/"//g;
        $Drug_chembl_id_Drug_claim_primary_name =~ s/'//g;
        $Drug_chembl_id_Drug_claim_primary_name =~ s/,//g;
        $Drug_chembl_id_Drug_claim_primary_name =~ s/\s+//g;
        $Drug_chembl_id_Drug_claim_primary_name =~s/\&/+/g;
        $Drug_chembl_id_Drug_claim_primary_name =~s/\)//g;
        $Drug_chembl_id_Drug_claim_primary_name =~s/\//_/g;
        my $oncotree_main_ID= $f[2]; 
        my $k1 = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_main_ID";
        my $k2 = "$Drug_claim_primary_name\t$oncotree_main_ID";
        if(exists $hash1{$k1}){    #先用$Drug_chembl_id_Drug_claim_primary_name，cancer 匹配drug cancer pair
            my $repo_withdrawl = $hash1{$k1};
            my $output = "$_\t$repo_withdrawl";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        elsif(exists $hash1{$k2}){ #如果用$Drug_chembl_id_Drug_claim_primary_name，cancer 不能匹配drug cancer pair，再用$Drug_claim_primary_name cancer pair匹配。
            my $repo_withdrawl = $hash1{$k2};
            my $output = "$_\t$repo_withdrawl";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

#_-------------------------------------------------------------------------------------并把repo和indication的值设为1，Withdrawn|Terminated设为0
my $f3 ="./output/03_filter_repo_withdrwal_data_for_logistic_regression.txt";
my $fo2 ="./output/03_final_filter_repo_withdrwal_data_for_logistic_regression.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


my $header="Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score\taverage_path_length\tmin_rwr_normal_P_value\tlogic_true_ratio";
$header = "$header\taverge_gene_num_in_del_hotspot\taverge_gene_num_in_dup_hotspot\taverge_gene_num_in_cnv_hotspot\taverge_gene_num_in_inv_hotspot\taverge_gene_num_in_tra_hotspot";
$header = "$header\trepo_or_withdrawn\tdrug_repurposing";
print $O2 "$header\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $Drug_claim_primary_name =$f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_main_id = $f[2];
        my $average_drug_score = $f[3];
        my $averge_gene_mutation_frequency = $f[4];
        my $average_gene_CADD_score = $f[5];
        my $average_mutation_map_to_gene_level_score = $f[6];
        my $average_path_length =$f[7];
        my $min_rwr_normal_P_value = $f[8];
        my $logic_true_ratio = $f[9];
        my $averge_gene_num_in_del_hotspot = $f[10];
        my $averge_gene_num_in_dup_hotspot = $f[11];
        my $averge_gene_num_in_inv_hotspot = $f[12];
        my $averge_gene_num_in_tra_hotspot = $f[13];
        my $averge_gene_num_in_cnv_hotspot = $f[14];
        my $repo_info = $f[15];
        my $output = join("\t",@f[1..15]);
        if ($repo_info =~/Drug_repo|Indication/){   #repo或者indication 给1
            my $output1 = "$output\t1";
            unless(exists $hash3{$output1}){
                $hash3{$output1} =1;
                print $O2 "$output1\n";
            }
        }
        elsif($repo_info =~/Withdrawn|Terminated/){ #Withdrawn或者Terminated给0
            my $output1 = "$output\t0";
            unless(exists $hash3{$output1}){
                $hash3{$output1} =1;
                print $O2 "$output1\n";
            }
        }
    }
}