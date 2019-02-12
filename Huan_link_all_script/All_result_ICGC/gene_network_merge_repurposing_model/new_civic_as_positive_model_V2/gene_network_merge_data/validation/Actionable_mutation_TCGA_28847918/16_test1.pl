# 统计./output/15_pancancer_pandrug_hit_actionable_or_not.txt中每个drug 中出现的特定actionable_mutation的百分比 ,并从./output/05_count_drug_number_in_sample_info.txt 中
#获得药物hit 住的 Sample 数目得./output/16_count_actionable_mutation_percentage_in_per_drug.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/15_pancancer_pandrug_hit_actionable_or_not.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/05_count_drug_number_in_sample_info.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/16_count_actionable_mutation_percentage_in_per_drug.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash5, %hash7);
#print $O1 "Drug_chembl_id_Drug_claim_primary_name\tthe_number_of_all_mutation_by_sample\tthe_number_of_actionable_mutation_by_sample\tactionable_percentage\(%\)\n";
print $O1 "Drug_claim_primary_name\tDrug_chembl_id_Drug_claim_primary_name\tnumber_drug_repurposing_sample\tthe_number_of_all_mutation_in_samples\tthe_number_of_actionable_mutation_in_samples\tactionable_percentage\(%\)\n";
    
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Oncotree_term/){
        my $Drug_claim_primary_name =$f[1];
        $Drug_claim_primary_name =~s/^\s+//g;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
        my $paper_sample_name = $f[5];
        my $Mutation_ID =$f[-6];
        my $predict_value =$f[-5];
        my $Hit_actionable_or_not = $f[-1];
        #my $k = "$Drug_claim_primary_name\t$Drug_chembl_id_Drug_claim_primary_name";
        my $k = "$Drug_chembl_id_Drug_claim_primary_name";
        push @{$hash5{$k}},$Drug_claim_primary_name;
        my $v1 = "$paper_sample_name\t$Mutation_ID";
        push @{$hash1{$k}},$v1;
        if ($Hit_actionable_or_not =~/YES/){
            my $v2 ="$paper_sample_name\t$Mutation_ID";
            push @{$hash2{$k}},$v2;
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $number = $f[1];
        $hash7{$Drug_chembl_id_Drug_claim_primary_name}=$number;
    }
}

foreach my $drug (sort keys %hash1){
    my @v1s =@{$hash1{$drug}};
    my %hash3;
    @v1s = grep { ++$hash3{$_} < 2 } @v1s;
    my $all_mutation_sample= @v1s;
    my @pri_drugs =@{$hash5{$drug}};
    my %hash6;
    @pri_drugs = grep { ++$hash6{$_} < 2 } @pri_drugs;  #把 Drug_claim_primary_name 加进来，
    my $pri_drug = join(";| ",@pri_drugs); #同一chembl 对应的多个Drug_claim_primary_name 用";| " 连接
    if (exists $hash7{$drug}){
        my $number_drug_repurposing_sample = $hash7{$drug};
        if (exists $hash2{$drug}){ #有actionable mutation 用计算
            my @v2s = @{$hash2{$drug}};
            my %hash4;
            @v2s = grep { ++$hash4{$_} < 2 } @v2s;
            my $actionable_sample = @v2s;
            my $actionable_percentage= $actionable_sample/$all_mutation_sample *100;
            my $output = "$pri_drug\t$drug\t$number_drug_repurposing_sample\t$all_mutation_sample\t$actionable_sample\t$actionable_percentage";
            print $O1 "$output\n";
        }
        else{#没有actionable mutation用0计算
            my $actionable_sample =0;
            my $actionable_percentage= $actionable_sample/$all_mutation_sample *100;
            my $output = "$pri_drug\t$drug\t$number_drug_repurposing_sample\t$all_mutation_sample\t$actionable_sample\t$actionable_percentage";
            print $O1 "$output\n";
        }
    }
}