#判断./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt中的indication和cancer是否相同，
#得indication和cancer相同文件./output/07_indication_and_cancer_same.txt ,得indication和cancer不相同文件./output/07_indication_and_cancer_differ.txt，
#并从./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt中为./output/07_indication_and_cancer_differ.txt提取其他信息，得./output/07_indication_and_cancer_differ_info.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/06_drug_cancer_network_based_prediction_potential_drug_repurposing_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./output/07_indication_and_cancer_same.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./output/07_indication_and_cancer_differ.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "drug\trepo_cancer";
print $O1 "drug\tindication\n";
print $O2 "$title\n";



my (%hash1,%hash2,%hash3,%hash4,%hash7,%hash9);
while(<$I1>)
{
    chomp;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f= split /\t/;
        my $drug = $f[0];
        my $indications = $f[-1];
        $indications =~ s/"//g;
        my $cancer = $f[1];
        my $k = "$drug\t$cancer";
        push @{$hash7{$k}},$_;
        push @{$hash2{$drug}},$cancer;
        my @f2 = split/\;/,$indications; #因为一个drug可能多个Indication
        foreach my $indication(@f2){ 
            push @{$hash1{$drug}},$indication;
        }
        my $Max_phase= $f[-3];
        my $First_approval =$f[-2];
        my $v9 = "$Max_phase\t$First_approval";
        push @{$hash9{$drug}},$v9;
    }
}

foreach my $drug (sort keys %hash1){
    my @indications = @{$hash1{$drug}};
    my %hash5;
     @indications = grep { ++$hash5{$_} < 2 } @indications;  #对数组内元素去重
    my @cancers = @{$hash2{$drug}};
    my %hash6;
    @cancers = grep { ++$hash6{$_} < 2 } @cancers;  #对数组内元素去重
    foreach my $cancer(@cancers){
        if(grep /$cancer/, @indications ){  #捕获在indication里出现的cancer
            my $out = "$drug\t$cancer";
            unless(exists $hash3{$out}){
                $hash3{$out}=1;
                print $O1 "$out\n";
            }
        }
        else{
            my $out = "$drug\t$cancer";
            unless(exists $hash4{$out}){
                $hash4{$out}=1;
                print $O2 "$out\n";
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄


my $f2 ="./output/07_indication_and_cancer_differ.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo3 ="./output/07_indication_and_cancer_differ_info.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $fo4 ="./output/07_more_than1_status_drug.txt"; 
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tcancer_oncotree_main_id\taverage_drug_score\taverge_gene_mutation_frequency\taverage_gene_CADD_score\taverage_mutation_map_to_gene_level_score";
$header = "$header\taverage_path_length\tmin_rwr_normal_P_value\taverge_gene_num_in_del_hotspot\taverge_gene_num_in_dup_hotspot\taverge_gene_num_in_inv_hotspot\taverge_gene_num_in_tra_hotspot\taverge_gene_num_in_cnv_hotspot";
$header = "$header\tpredict\tpredict_value\tMax_phase\tFirst_approval";
print $O3 "$header\n";


my %hash8;
while(<$I2>)
{
    chomp;
    unless(/^drug/){
        my @f= split /\t/;
        my $drug = $f[0];
        my $cancer = $f[1];
        my $k = "$drug\t$cancer";
        if(exists $hash7{$k}){
            my @drug_cancer_infos = @{$hash7{$k}};
            foreach my $drug_cancer_info (@drug_cancer_infos){
                my @f= split/\t/,$drug_cancer_info;
                my $output = join("\t",@f[0..16]);
                unless(exists $hash8{$output}){
                    $hash8{$output}=1;
                    print $O3 "$output\n";
                }
            }
        }
    }
}


foreach my $drug(sort keys %hash9){
    my @Max_phases = @{$hash9{$drug}};
    my %hash10;
    @Max_phases = grep { ++$hash10{$_} < 2 } @Max_phases;  #对数组内元素去重
    my $num = @Max_phases;
    if($num>1){
        foreach my $Max_phase(@Max_phases){
            print $O4 "$drug\t$Max_phase\n";
        }
    }

}