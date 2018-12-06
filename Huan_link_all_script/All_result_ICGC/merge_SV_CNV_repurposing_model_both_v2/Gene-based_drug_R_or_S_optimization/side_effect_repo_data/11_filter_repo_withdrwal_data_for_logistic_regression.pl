#根据09_prepare_data_for_repo_logistic_regression.txt中的drug cancer pair 在"10_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt"
#中提取repo_or_withdrawl 的logistic_regression信息。得./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt,
use warnings;
use strict; 
use utf8;



my $f1 ="./09_prepare_data_for_repo_logistic_regression.txt";
my $f2 ="./10_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt";
my $fo1 ="./11_drug_primary_calculate_for_gene_based_repo_logistic_regression_data.txt";
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
        #my $oncotree_main_ID= $f[-2];
        my $oncotree_main_ID= $f[1];
        my $repo_or_withdrawl = $f[-1];
        my $k= "$Drug\t$oncotree_main_ID";
        $hash1{$k}=$repo_or_withdrawl;
    }
}




while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $out = join("\t",@f[1..11]);
    if(/^Drug_claim_primary_name/){
        print $O1 "$out\trepo_info\n";
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
            my $output = "$out\t$repo_withdrawl";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
        }
        else{
            if(exists $hash1{$k2}){ #如果用$Drug_chembl_id_Drug_claim_primary_name，cancer 不能匹配drug cancer pair，再用$Drug_claim_primary_name cancer pair匹配。
                my $repo_withdrawl = $hash1{$k2};
                my $output = "$out\t$repo_withdrawl";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
            
        }
        
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

