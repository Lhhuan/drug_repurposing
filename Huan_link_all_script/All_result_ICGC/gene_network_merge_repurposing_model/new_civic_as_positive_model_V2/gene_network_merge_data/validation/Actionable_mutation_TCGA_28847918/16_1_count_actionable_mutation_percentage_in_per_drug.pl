# 统计./output/15_pancancer_pandrug_hit_actionable_or_not.txt中每个drug 中出现的特定actionable_mutation的百分比 ,并从./output/05_count_drug_number_in_sample_info.txt 中
#获得药物hit 住的 Sample 数目得./output/16_count_actionable_mutation_percentage_in_per_drug_simple.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/15_pancancer_pandrug_hit_actionable_or_not.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/05_count_drug_number_in_sample_info.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/16_count_actionable_mutation_percentage_in_per_drug_simple.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash5, %hash7);
#print $O1 "Drug_chembl_id_Drug_claim_primary_name\tthe_number_of_all_mutation_by_sample\tthe_number_of_actionable_mutation_by_sample\tactionable_percentage\(%\)\n";
my $out = "Drug_claim_primary_name\tDrug_chembl_id_Drug_claim_primary_name\tnumber_drug_repurposing_sample\tthe_number_of_all_mutation_in_samples\tthe_number_of_actionable_mutation_in_samples\tactionable_percentage\(%\)";
$out = "$out\tAll_paper_sample_name\tAll_Mutation_ID\tAll_Oncotree_term\tAll_oncotree_id\tAll_oncotree_id_type\tAll_HGVSg";
print $O1 "$out\n";
    
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Oncotree_term/){
        my $Oncotree_term = $f[0];
        my $Drug_claim_primary_name =$f[1];
        $Drug_claim_primary_name =~s/^\s+//g;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[2];
        my $oncotree_id = $f[3];
        my $oncotree_id_type = $f[4];
        my $paper_sample_name = $f[5];
        my $Mutation_ID =$f[-6];
        my $predict_value =$f[-5];
        my $HGVSg = $f[-3];
        my $Hit_actionable_or_not = $f[-1];
        #my $k = "$Drug_claim_primary_name\t$Drug_chembl_id_Drug_claim_primary_name";
        my $k = "$Drug_chembl_id_Drug_claim_primary_name";
        push @{$hash5{$k}},$Drug_claim_primary_name;
        my $v1 = "$paper_sample_name\t$Mutation_ID";
        push @{$hash1{$k}},$v1;
        if ($Hit_actionable_or_not =~/YES/){
            my $v2 ="$paper_sample_name\t$Mutation_ID\t$Oncotree_term\t$oncotree_id\t$oncotree_id_type\t$HGVSg";
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
            my @v2a = @{$hash2{$drug}};
            my %hash8;
            @v2a = grep { ++$hash8{$_} < 2 } @v2a;

            my @p_name_array= ();
            my @mutation_id_array = ();
            my @Oncotree_term_array = ();
            my @oncotree_id_array =();
            my @oncotree_id_type_array =();
            my @HGVSg_array =();
            my @v2s =();
            foreach my $v2_v(@v2a){
                my @v2 =split/\t/,$v2_v;
                my $paper_sample_name =$v2[0];
                push @p_name_array, $paper_sample_name;
                my $Mutation_ID =$v2[1];
                push @mutation_id_array, $Mutation_ID;
                my $Oncotree_term = $v2[2];
                push @Oncotree_term_array, $Oncotree_term;
                my $oncotree_id = $v2[3];
                push @oncotree_id_array, $oncotree_id;
                my $oncotree_id_type = $v2[4];
                push @oncotree_id_type_array,$oncotree_id_type ;
                my $HGVSg = $v2[5];
                push @HGVSg_array, $HGVSg;
                #------------------ my $v = "$paper_sample_name\t$Mutation_ID"; #是actionable mutation 的sample的信息统计
                my $v= join("\t",@v2[0,1]);
                push @v2s,$v;
            }
            my %hash4;
            @v2s = grep { ++$hash4{$_} < 2 } @v2s;
            my $actionable_sample = @v2s;
            my $actionable_percentage= $actionable_sample/$all_mutation_sample *100;
            my $output = "$pri_drug\t$drug\t$number_drug_repurposing_sample\t$all_mutation_sample\t$actionable_sample\t$actionable_percentage";
            #---------------------------------------------------------------------------将cancer mutation等具体信息输出
            my %hash9;
            @p_name_array = grep { ++$hash9{$_} < 2 } @p_name_array; #数组内元素去重
            my $all_paper_sample_name = join (";|", @p_name_array);
            my %hash10;
            @mutation_id_array = grep { ++$hash10{$_} < 2 } @mutation_id_array;
            my $all_Mutation_ID = join(";|",@mutation_id_array);
            my %hash11;
            @Oncotree_term_array = grep { ++$hash11{$_} < 2 } @Oncotree_term_array;
            my $all_Oncotree_term = join (";|",@Oncotree_term_array);
            my %hash12;
            @oncotree_id_array = grep { ++$hash12{$_} < 2 } @oncotree_id_array;
            my $all_oncotree_id = join (";|",@oncotree_id_array);
            my %hash13;
            @oncotree_id_type_array = grep { ++$hash13{$_} < 2 } @oncotree_id_type_array;
            my $all_oncotree_id_type = join (";|",@oncotree_id_type_array);
            my %hash14;
            @HGVSg_array = grep { ++$hash14{$_} < 2 } @HGVSg_array;
            my $all_HGVSg = join (";|",@HGVSg_array);
            my $output2 = "$all_paper_sample_name\t$all_Mutation_ID\t$all_Oncotree_term\t$all_oncotree_id\t$all_oncotree_id_type\t$all_HGVSg";
            my $final_output = "$output\t$output2";
            print $O1 "$final_output\n";
        }
        else{#没有actionable mutation用0计算
            my $actionable_sample =0;
            my $actionable_percentage= $actionable_sample/$all_mutation_sample *100;
            my $output = "$pri_drug\t$drug\t$number_drug_repurposing_sample\t$all_mutation_sample\t$actionable_sample\t$actionable_percentage";
            my $all_paper_sample_name = "NA";
            my $all_Mutation_ID = "NA";
            my $all_Oncotree_term = "NA";
            my $all_oncotree_id = "NA";
            my $all_oncotree_id_type = "NA";
            my $all_HGVSg = "NA";
            my $output2 = "$all_paper_sample_name\t$all_Mutation_ID\t$all_Oncotree_term\t$all_oncotree_id\t$all_oncotree_id_type\t$all_HGVSg";
            my $final_output = "$output\t$output2";
            print $O1 "$final_output\n";
        }
    }
}