
#并从./output/12_merge_cancer_detail_main_ID.txt中提取./output/13_indication_and_cancer_lable.txt的信息，得./output/13_indication_and_cancer_lable_info.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/12_merge_cancer_detail_main_ID.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/13_indication_and_cancer_lable.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo3 ="./output/13_indication_and_cancer_lable_info.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3);
my (%hash7,%hash8,%hash9,%hash10);
while(<$I1>)
{
    chomp;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O3 "$_\tlable\n";
    }
    else{
        my @f= split /\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_detail_ID = $f[2];
        my $cancer_oncotree_main_ID =$f[3];
        my $cancer_oncotree_id_type = $f[4];
        my $predict = $f[5];
        my $predict_value = $f[6];
        my $indication_OncoTree_detail_ID = $f[8];
        $indication_OncoTree_detail_ID =~ s/"//g;
        my $indication_OncoTree_main_ID = $f[9];
        $indication_OncoTree_main_ID =~s/"//g;
        my $Max_phase = $f[10];
        my $First_approval =$f[11];
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
        my $cancer_oncotree = "$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID";
        my $k9 = "$k\t$cancer_oncotree_detail_ID";
        push @{$hash9{$k9}},$_; #把 cancer和tissue push 进数组
    }
}



while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_detail_id = $f[2];
        my $lable = $f[3];
        my $k = join ("\t",@f[0..2]);
        if (exists $hash9{$k}){
            # print "$k\n";
            my @vs = @{$hash9{$k}};
            my %hash6;
            @vs = grep { ++$hash6{$_} < 2 } @vs ;
            foreach my $v(@vs){
                my $output = "$v\t$lable";
                unless(exists $hash10{$k}){ #只为k保留一个indication
                    $hash10{$k}=1;
                    print $O3 "$output\n";
                }
            }
        }
        else{
            print "$k\n";
        }
    }
}