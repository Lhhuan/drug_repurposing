#用./merge_occur_QC_pathogenicity_score.txt 和
#"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt"
#筛选最终的致病性文件，得pathogenicity mutation id project 文件./Pathogenicity_id_project.txt,得pathogenicity score 文件./pathogenicity_id_cadd_score.txt ,
#得pathogenicity mutation id project cadd score 文件./Pathogenicity_id_project_cadd_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/in_ICGC/output/01_unique_all_driver_actionable_in_ICGC.txt";
my $f2 = "./merge_occur_QC_pathogenicity_score.txt";
my $fo1 = "./Pathogenicity_id_project_cadd_score.txt";
my $fo2 = "./Pathogenicity_id_project.txt";
my $fo3 = "./pathogenicity_id_cadd_score.txt";
my $fo4 = "./occur_qc_cadd_score_small_than15.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my (%hash1, %hash2);
print $O1 "ID\tproject\tcancer_specific_affected_donors\tCADD_PHRED\n";
print $O2 "ID\tproject\tcancer_specific_affected_donors\n";
print $O3 "ID\tCADD_PHRED\n";
print $O4 "ID\tproject\tcancer_specific_affected_donors\tCADD_PHRED\n";

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
        my $CADD_PHRED = $f[3];
        my $id_project = "$ID\t$project\t$cancer_specific_affected_donors";
        my $id_cadd = "$ID\t$CADD_PHRED";
        if (exists $hash1{$ID}){ #在ICGC中的driver和actionable mutation直接输出
            print $O1 "$_\n";
            print $O2 "$id_project\n";
            unless(exists $hash2{$id_cadd}){
                $hash2{$id_cadd} =1;
                print $O3 "$id_cadd\n";
            }
        }
        else{#除此之外的mutation 
            if($ID =~/Add/){ #先将Add cadd 之外的留下来
                print $O1 "$_\n";
                print $O2 "$id_project\n";
                unless(exists $hash2{$id_cadd}){
                    $hash2{$id_cadd} =1;
                    print $O3 "$id_cadd\n";
                }
            }
            else{
                if ($CADD_PHRED>=15){
                    print $O1 "$_\n";
                    print $O2 "$id_project\n";
                    unless(exists $hash2{$id_cadd}){
                        $hash2{$id_cadd} =1;
                        print $O3 "$id_cadd\n";
                    }
                }
                else{
                    print $O4 "$_\n";
                }
            }
        }
        
    }
}
