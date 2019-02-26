#all_drug_infos_score.txt 中的drug 因为有多个indication，所有会显示有多个status, 为drug找出最大的status 确定为drug 的status，得all_drug_unique_status_media.txt ,
#将all_drug_unique_status_media.txt中First_approval有年份的写fda approved
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./all_drug_unique_status_media.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Drug_chembl_id_Drug_claim_primary_name\tMax_phase\tFirst_approval\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
    my $Max_phase = $f[6];
    $Max_phase=~s/unknown/Unknown/g;
    $Max_phase=~s/NA/unknown/g;
    # $Max_phase=~s/0/Phase0/g;
    # $Max_phase=~s/1/Phase1/g;
    # $Max_phase=~s/2/Phase2/g;
    # $Max_phase=~s/3/Phase3/g;
    # $Max_phase=~s/4/Phase4/g;
    my $First_approval = $f[7];
    my $v1 = "$Max_phase\t$First_approval";
    unless(/^Drug_chembl_id/){
        push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v1;
    }
}

foreach my $drug_info(sort keys %hash1){
    my @ori_status_infos = @{$hash1{$drug_info}};
    my %hash15;
    @ori_status_infos = grep { ++$hash15{$_} < 2 } @ori_status_infos;
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

my $f2 ="./all_drug_unique_status_media.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 ="./all_drug_unique_status.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O2 "Drug_chembl_id_Drug_claim_primary_name\tMax_phase\tFirst_approval\n";
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Max_phase = $f[1];
        $Max_phase =~ s/Launched/FDA approved/g;
        my $First_approval = $f[2];
        if ($First_approval=~/\d+/){
            # print "$First_approval\n";
            print $O2 "$Drug_chembl_id_Drug_claim_primary_name\tFDA approved\t$First_approval\n";
        }
        else{
            print $O2 "$Drug_chembl_id_Drug_claim_primary_name\t$Max_phase\t$First_approval\n";
        }
    }
}

