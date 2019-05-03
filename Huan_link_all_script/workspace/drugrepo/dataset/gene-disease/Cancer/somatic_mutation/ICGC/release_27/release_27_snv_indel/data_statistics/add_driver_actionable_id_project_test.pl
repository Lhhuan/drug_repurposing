#留住ID_project.txt 中的"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt"
#和 cancer specific mutation >1(>=2)的cancer 相关mutation id留住和../12_add_project_mutation_id.txt merge 到一起，add_project_mutation_id的occurance
#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/average_Pathogenic_occurance.txt"
#得最终id_project 文件 Final_ID_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt";
my $f2 = "./ID_project.txt";
my $f3 = "../12_add_project_mutation_id.txt";
my $fo1 = "./Final_ID_project.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "ID\tproject\tcancer_specific_affected_donors\n";

while(<$I1>)
{
    chomp;
    unless (/^ICGC_Mutation_ID/){
        $hash1{$_}=1;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f= split/\t/;
        my $ID = $f[0];
        my $project = $f[1];
        my $cancer_specific_affected_donors = $f[2];
        if (exists $hash1{$ID}){ #在ICGC中的driver和actionable mutation直接输出
            print $O1 "$_\n";
        }
        else{#除此之外的mutation 按照cancer specific mutattion occurance >1进行筛选
            if($cancer_specific_affected_donors>1){
                print $O1 "$_\n";
            }
        }
        
    }
}

while(<$I3>)
{
    chomp;
    unless (/^ID/){
        print $O1 "$_\t2.52075248953357\n" #由"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/pathogenicity_mutation_cancer/output/average_Pathogenic_occurance.txt"
    }
}
