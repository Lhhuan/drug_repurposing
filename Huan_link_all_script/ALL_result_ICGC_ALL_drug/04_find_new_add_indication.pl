# 找出在./output/before_indication_do_hpo_oncotree.txt中存在但在./output/huan_target_drug_indication.txt 中不存在的indication,得文件./output/04_new_indication.txt
#在./output/before_indication_do_hpo_oncotree.txt中存在，在./output/huan_target_drug_indication.txt 中也存在的indication也存在的indication及oncotree map等得文件./output/04_indication_in_before_do_hpo_oncotree.txt,
#得在./output/before_indication_do_hpo_oncotree.txt中存在，在./output/huan_target_drug_indication.txt不存在的indication 文件是./output/04_before_indication_not_in_now_indication.txt
#得现在全部的indication文件./output/04_all_indication_now.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/before_indication_do_hpo_oncotree.txt";
my $f2 ="./output/huan_target_drug_indication.txt";
my $fo1 ="./output/04_indication_in_before_do_hpo_oncotree.txt";
my $fo2 ="./output/04_new_indication.txt"; 
my $fo3 ="./output/04_before_indication_not_in_now_indication.txt"; #在./output/before_indication_do_hpo_oncotree.txt中存在，在./output/huan_target_drug_indication.txt不存在的indication
my $fo4 ="./output/04_all_indication_now.txt"; #现在全部的indication
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
print $O1 "Drug_indication|Indication_class\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID\n";


while(<$I1>)
{
    chomp;
    my @f = split/\t/;
    unless(/^Drug_indication/){
        my $drug_indication = $f[0];#是Drug_indication|Indication_class
        # print "$drug_indication\n";
        my $Drug_indication = $drug_indication;
        $Drug_indication =~s/"//g;
        $Drug_indication =~s/^\s+//;
        $Drug_indication=lc($Drug_indication);#转换成小写。
        $Drug_indication =~ s/\(//g;
        $Drug_indication =~ s/\)*//g;
        $hash1{$Drug_indication}=$_;
    }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Indication = $f[18];
        my $indication = $Indication;
        $indication =~ s/"//g;
        $indication =~s/^\s+//;
        $indication = lc($indication);
        $indication =~ s/\(//g;
        $indication =~ s/\)//g;
        $hash2{$indication} =1;
        unless (exists $hash5{$indication}){
            $hash5{$indication} =1;
            print $O4 "$indication\n";
        }
        if(exists $hash1{$indication}){
            my $term = $hash1{$indication};
            unless (exists $hash3{$term}){
                $hash3{$term} =1;
                print $O1 "$term\n";
            }
        }
        else{
            unless(exists $hash4{$indication}){
                $hash4{$indication} =1;
                print $O2 "$indication\n";
            }
        }
    }
}


foreach my $k(sort keys %hash1){
    unless(exists $hash2{$k}){
        print $O3 "$k\n";
    }
}









# while(<$I2>) 
# {
#     chomp;
#     my @f= split /\t/;
#     unless(/^Drug_chembl_id/){
#         my $Indication = $f[18];
#         my $indication = $Indication;
#         $indication =~ s/"//g;
#         $indication =~s/^\s+//;
#         $indication = lc($indication);
#         $indication =~ s/\(//g;
#         $indication =~ s/\)//g;
#         unless(exists $hash1{$indication}){
#             unless(exists $hash2{$indication}){
#                 $hash2{$indication} =1;
#                 print $O1 "$indication\n";
#             }
#         }
#     }
# }