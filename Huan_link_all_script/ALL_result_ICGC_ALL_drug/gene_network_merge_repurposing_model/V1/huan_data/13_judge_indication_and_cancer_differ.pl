#判断./output/12_merge_cancer_detail_main_ID.txt中的indication和cancer是否相同，
#得indication和cancer相同文件./output/13_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/13_indication_and_cancer_differ.txt，#得加标签的原文件./output/13_indication_and_cancer_lable.txt
#并从./output/12_merge_cancer_detail_main_ID.txt中提取./output/13_indication_and_cancer_lable.txt的信息，得./output/13_indication_and_cancer_lable_info.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="./1234.txt";
my $f1 ="./output/12_merge_cancer_detail_main_ID.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/13_indication_and_cancer_same.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/13_indication_and_cancer_differ.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo4 ="./output/13_indication_and_cancer_lable.txt"; 
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my $fo3 ="./output/13_indication_and_cancer_lable_info.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";


my $title = "Drug_chembl_id_Drug_claim_primary_name\tDrug_claim_primary_name\tcancer_oncotree_detail_ID";
print $O1 "$title\tindication\n";
print $O2 "$title\n";
print $O4 "$title\tlable\n";


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
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
        my $cancer_oncotree = "$cancer_oncotree_detail_ID\t$cancer_oncotree_main_ID";
        push @{$hash1{$k}},$cancer_oncotree;
        my @indication_details =split/\;/,$indication_OncoTree_detail_ID;
        foreach my $indication_detail(@indication_details){ #数组作为hash的值 #把indication的main 和detail 都push进同一数组
            push @{$hash3{$k}},$indication_detail;
        }
        my @indication_mains =split/\;/,$indication_OncoTree_main_ID;
        foreach my $indication_main(@indication_mains){
            push @{$hash3{$k}},$indication_main;
        }
        my $k9 = "$k\t$cancer_oncotree_detail_ID";
        push @{$hash9{$k9}},$_; # #cancer_oncotree_detail_ID是原来预测中的cancer_oncotree_id
    }
}


foreach my $drug (sort keys %hash1){
    # print STDERR "$drug\n";
    my @cancer_oncotrees = @{$hash1{$drug}};
    my %hash4;
    @cancer_oncotrees = grep { ++$hash4{$_} < 2 } @cancer_oncotrees;  #对数组内元素去重
    my %hash6;
    my @indications = @{$hash3{$drug}};
    @indications = grep { ++$hash6{$_} < 2 } @indications ;
    foreach my $cancer_oncotree(@cancer_oncotrees){
        my @f = split/\t/,$cancer_oncotree;
        my $cancer_detail =$f[0];
        my $cancer_main = $f[1];
        if(grep /$cancer_detail/, @indications ){  #捕获在indication里出现的cancer
            my $out = "$drug\t$cancer_detail"; #标注和indication的来源
            unless(exists $hash7{$out}){
                $hash7{$out}=1;
                print $O1 "$out\toverlap_indication_with_oncotree_detail_id\n";
                print $O4 "$out\tindication\n";
            }
        }
        else{
            if(grep /$cancer_main/, @indications ){
                my $out = "$drug\t$cancer_detail";
                unless(exists $hash7{$out}){
                    $hash7{$out}=1;
                    print $O1 "$out\toverlap_indication_with_oncotree_main_id\n";
                    print $O4 "$out\tindication\n";
                }
            }
            else{
                my $out = "$drug\t$cancer_detail";
                unless(exists $hash8{$out}){
                    $hash8{$out}=1;
                    print $O2 "$out\n";
                    print $O4 "$out\trepo_cancer\n";
                }      
            }
        }
    }
}

close ($O1);
close ($O2);
close ($O4);


my $f2 ="./output/13_indication_and_cancer_lable.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";


while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_detail_ID = $f[2];
        my $lable = $f[3];
        my $k = join ("\t",@f[0..2]);
        if (exists $hash9{$k}){
            my @vs = @{$hash9{$k}};
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