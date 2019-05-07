#./output/all_drug_infos_score.txt 中的drug 因为有多个indication，所有会显示有多个status, 为drug找出最大的status 确定为drug 的status，得./output/all_drug_unique_status.txt ,
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/max min/;

my $f1 ="./output/all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/all_drug_unique_status.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Drug_chembl_id_Drug_claim_primary_name\tMax_phase\tFirst_approval\n";

my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
    my $phase = $f[6];
    my $Max_phase = $phase;
    $Max_phase=~s/unknown|Nutraceutical|NA/Unknown/g;
    $Max_phase=~s/0/Phase0/g;
    $Max_phase=~s/1/Phase1/g;
    $Max_phase=~s/2/Phase2/g;
    $Max_phase=~s/3/Phase3/g;
    $Max_phase=~s/4/Phase4/g;
    $Max_phase=~ s/Vet Approved/Unknown/g;
    $Max_phase =~s/Approved|Launched/FDA approved/g;
    $Max_phase =~s/Experimental/Preclinical/g;
    $Max_phase =~s/Clinical Trials/Unclassified Clinical Trials/g;
    # print "$phase\t$Max_phase\n";
    my $First_approval = $f[7];
    my $v = $Max_phase;
    unless(/^Drug_chembl_id/){
        if($First_approval=~/\d+/){ #年份匹配数字
            if ($First_approval !~/Err:520/){ #年份不匹配Err:520
                unless(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
                    $hash1{$Drug_chembl_id_Drug_claim_primary_name} =1;
                    print $O1 "$Drug_chembl_id_Drug_claim_primary_name\tFDA approved\t$First_approval\n";
                }
            }
            else{
                unless(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){ #$Drug_chembl_id_Drug_claim_primary_name只出现一次 没有approved 年份的药物后面接着处理
                    push @{$hash2{$Drug_chembl_id_Drug_claim_primary_name}},$v;
                }
            }
        }
        elsif($First_approval =~/approved/i){ ##年份匹配approved
            if ($First_approval !~/not/i){ #不匹配 not approved
                unless(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
                    $hash1{$Drug_chembl_id_Drug_claim_primary_name} =1;
                    print $O1 "$Drug_chembl_id_Drug_claim_primary_name\tFDA approved\t$First_approval\n";
                }
            } 
            else{ #not approved
                # print "$First_approval\n";
                unless(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){ #$Drug_chembl_id_Drug_claim_primary_name只出现一次
                    push @{$hash2{$Drug_chembl_id_Drug_claim_primary_name}},$v;
                }
            }
        }
        else{
            unless(exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){ #$Drug_chembl_id_Drug_claim_primary_name只出现一次
                push @{$hash2{$Drug_chembl_id_Drug_claim_primary_name}},$v;
            }
        }
    }
}

foreach my $drug (sort keys %hash2){  
    my @phases = @{$hash2{$drug}};
    my %hash3;
    @phases = grep { ++$hash3{$_} < 2 } @phases ; ##数组内去重
    if(grep /FDA approved/,@phases ){  #捕获在@phases里出现的出现的phase,优先排序药物的phase
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tFDA approved\tNA\n";
        }   
    }
    elsif(grep /Phase4/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPhase4\tNA\n";
        } 
    }
    elsif(grep /Phase3/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPhase3\tNA\n";
        } 
    }
    elsif(grep /Phase2/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPhase2\tNA\n";
        } 
    }
    elsif(grep /Phase1/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPhase1\tNA\n";
        } 
    }
    elsif(grep /Phase0/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPhase0\tNA\n";
        } 
    }
    elsif(grep /Unclassified Clinical Trials/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tUnclassified Clinical Trials\tNA\n";
        } 
    }
    elsif(grep /Preclinical/,@phases){
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            print $O1 "$drug\tPreclinical\tNA\n";
        } 
    }
    else{
        unless(exists $hash1{$drug}){
            $hash1{$drug} =1;
            # print "@phases\t$drug\n";
            print $O1 "$drug\tUnknown\tNA\n";
        } 
    }
}







# while(<$I1>)
# {
#     chomp;
#     my @f =split/\t/;
#     my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
#     my $Max_phase = $f[6];
#     $Max_phase=~s/unknown|Nutraceutical|NA/Unknown/g;
#     $Max_phase=~s/0/Phase0/g;
#     $Max_phase=~s/1/Phase1/g;
#     $Max_phase=~s/2/Phase2/g;
#     $Max_phase=~s/3/Phase3/g;
#     $Max_phase=~s/4/Phase4/g;
#     $Max_phase=~ s/Vet Approved/Unknown/g;
#     my $First_approval = $f[7];
#     my $v1 = "$Max_phase\t$First_approval";
#     unless(/^Drug_chembl_id/){
#         push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$v1;
#     }
# }
