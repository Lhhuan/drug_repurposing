#提取./output/10_merge_drug_indication.txt 中的unique的status,得./output/11_drug_unique_status.txt 并得附加其他信息的文件./output/11_drug_unique_status_infos.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./output/10_merge_drug_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/11_drug_unique_status.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/11_drug_unique_status_infos.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    my $Drug_claim_primary_name = $f[0];
    my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
    my $cancer_oncotree_id = $f[2];
    my $cancer_oncotree_id_type = $f[3];
    my $predict = $f[4];
    my $predict_value = $f[5];
    my $Max_phase = $f[6];
    my $First_approval = $f[7];
    my $Drug_indication_Indication_class =$f[8];
    my $indication_OncoTree_detail_ID = $f[9];
    my $indication_OncoTree_main_ID = $f[10];
    my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
    my $v1 = "$Max_phase\t$First_approval";
    my $v2 = "$cancer_oncotree_id\t$cancer_oncotree_id_type\t$predict\t$predict_value\t$Drug_indication_Indication_class\t$indication_OncoTree_detail_ID\t$indication_OncoTree_main_ID";
    if(/^Drug_claim_primary_name/){
        print $O1 "$k\t$v1\n";
        print $O2 "$k\t$v2\t$Max_phase\t$First_approval\n";
    }
    else{
        push @{$hash1{$k}},$v1;
        push @{$hash4{$k}},$v2;
    }
}

foreach my $drug_info(sort keys %hash1){
    my @ori_status_infos = @{$hash1{$drug_info}};
    my @status_infos = sort {$b cmp $a} @ori_status_infos; #对数组按照字符串从大到小排序
    my $num = @ori_status_infos;
    if ($num eq 1){
        my $output ="$drug_info\t$status_infos[0]";
        unless (exists $hash2{$output}){
            $hash2{$output} =1;
            print $O1 "$output\n";
        }
    }
    else{   #在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched
        foreach my $status_info(@status_infos){
            unless($status_info =~/^unknown|Preclinical/){ #因为对数组到升序排列的时候，Preclinical在Launched前面，只能后面再对Preclinical进行处理。
                if ($status_info =~/^Launched/){ #最大是launched
                    $hash3{$drug_info}=1;
                    my $output ="$drug_info\t$status_info";
                    unless (exists $hash2{$output}){
                        $hash2{$output} =1;
                        print $O1 "$output\n";
                    }                                                                                                             
                }
                else{
                    unless(exists $hash3{$drug_info}){
                        if ($status_info =~/^4/){#最大是phase4
                            $hash3{$drug_info}=1;
                            my $output ="$drug_info\t$status_info";
                            unless (exists $hash2{$output}){
                                $hash2{$output} =1;
                                print $O1 "$output\n";
                            }                                                                                                             
                        }
                        else{
                            unless(exists $hash3{$drug_info}){
                                if ($status_info =~/^3/){#最大是phase3
                                    $hash3{$drug_info}=1;
                                    my $output ="$drug_info\t$status_info";
                                    unless (exists $hash2{$output}){
                                        $hash2{$output} =1;
                                        print $O1 "$output\n";
                                    }                                                                                                             
                                }
                                else{
                                    unless(exists $hash3{$drug_info}){
                                       if ($status_info =~/^2/){#最大是phase2
                                            $hash3{$drug_info}=1;
                                            my $output ="$drug_info\t$status_info";
                                            unless (exists $hash2{$output}){
                                                $hash2{$output} =1;
                                                print $O1 "$output\n";
                                            }                                                                                                             
                                        }
                                        else{
                                            unless(exists $hash3{$drug_info}){
                                                if ($status_info =~/^1/){#最大是phase1
                                                    $hash3{$drug_info}=1;
                                                    my $output ="$drug_info\t$status_info";
                                                    unless (exists $hash2{$output}){
                                                        $hash2{$output} =1;
                                                        print $O1 "$output\n";
                                                    }                                                                                                             
                                                }
                                                else{
                                                    unless(exists $hash3{$drug_info}){
                                                        if ($status_info =~/^0/){#最大是phase0
                                                            $hash3{$drug_info}=1;
                                                            my $output ="$drug_info\t$status_info";
                                                            unless (exists $hash2{$output}){
                                                                $hash2{$output} =1;
                                                                print $O1 "$output\n";
                                                            }                                                                                                             
                                                        }
                                                        else{
                                                            unless(exists $hash3{$drug_info}){##在上面的状态不存在的情况，drug 的stutas只能是unknown和Preclinical，最大只能是Preclinical,
                                                                $status_info = "Preclinical\tNA";
                                                                $hash3{$drug_info}=1;
                                                                my $output ="$drug_info\t$status_info";
                                                                unless (exists $hash2{$output}){
                                                                    $hash2{$output} =1;
                                                                    print $O1 "$output\n";
                                                                }                                                                                                             
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
close($O1);


my $f2 ="./output/11_drug_unique_status.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
    my $Drug_claim_primary_name = $f[1];
    my $Max_phase = $f[2];
    my $First_approval = $f[3];
    my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
    my $status = "$Max_phase\t$First_approval";
    unless(/^Drug_chembl_id/){
        if (exists $hash4{$k}){
            my @vs = @{$hash4{$k}};
            foreach my $v(@vs){
                my $output ="$k\t$v\t$status";
                unless (exists $hash5{$output}){
                    $hash5{$output} =1;
                    print $O2 "$output\n";
                }
            }
        }
    }
}

