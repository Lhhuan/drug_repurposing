#因为./output/07_indication_and_cancer_differ_info.txt中同一个drug有不同status，
#在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched,得./output/08_final_network_based_drug_repurposing_success.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/07_indication_and_cancer_differ_info.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/08_final_network_based_drug_repurposing_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";



my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f =split/\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\n";
    }
    else{
        my $k =join("\t",@f[0..9]);
        my $Max_phase = $f[10];
        my $First_approval = $f[11];
        my $v = "$Max_phase\t$First_approval";
        push @{$hash1{$k}},$v;
    }
}

foreach my $drug_info(sort keys %hash1){
    my @status_infos = @{$hash1{$drug_info}};
    my $num = @status_infos;
    if ($num eq 1){
        my $output ="$drug_info\t$status_infos[0]";
        unless (exists $hash2{$output}){
            $hash2{$output} =1;
            print $O1 "$output\n";
        }
    }
    else{   #在07中测试过，重复的药物状态中，所有药物的最大状态都是Launched，所以对于药物状态重复的，都保留launched
        foreach my $status_info(@status_infos){
            if ($status_info =~/^Launched/){
                my $output ="$drug_info\t$status_info";
                unless (exists $hash2{$output}){
                    $hash2{$output} =1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}