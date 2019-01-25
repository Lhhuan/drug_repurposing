#将./output/13_transvar_ref_alt.txt 和./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt 通过cancer drug mutation merge 到一起，得
#hit 住的action mutation 文件得./output/14_cancer_drug_specific_hit_actionable_mutation.txt ,
##得potential 的actionable mutation 得文件./output/14_cancer_drug_specific_potential_actionable_mutation.txt
#得标注mutation 是否是actionable的文件./output/14_cancer_drug_specific_hit_actionable_or_not.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/13_transvar_ref_alt.txt";
my $f2 = "./output/082_merge_Drug_top_number_drug_sample_mutation_hgvsg_cancer_term.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/14_cancer_drug_specific_hit_actionable_mutation.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/14_cancer_drug_specific_potential_actionable_mutation.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 = "./output/14_cancer_drug_specific_hit_actionable_or_not.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
my $header = "Oncotree_term\tDrug_claim_primary_name\tDrug_chembl_id_Drug_claim_primary_name\toncotree_id\toncotree_id_type\tpaper_sample_name";
$header="$header\taverage_effective_drug_target_score\taverage_mutation_frequency";
$header ="$header\taverage_mutation_pathogenicity\taverage_mutation_map_to_gene_level_score\taverage_the_shortest_path_length\tmin_rwr_normal_P_value\tmedian_rwr_normal_P_value";
$header = "$header\tcancer_gene_exact_match_drug_target_ratio\taverage_del_svscore\taverage_dup_svscore\taverage_inv_svscore\taverage_tra_svscore\taverage_cnv_svscore";
my $output = "$header\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length";
$output = "$output\tnormal_score_P\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED\tcancer_ENSG\tthe_final_logic\tMap_to_gene_level";
$output ="$output\tmap_to_gene_level_score\tdata_source\tMutation_ID";
$output=  "$output\tpredict_repurposing_value\tnumber_of_sample_hit_drug\tHGVSg";
print $O1 "$output\tfinal_actionable_mutation\thit_actionable_by_cancer_type\n";
print $O2 "$output\n";
print $O3 "$output\tfinal_actionable_mutation\thit_actionable_by_cancer_type\tHit_actionable_or_not\n";  
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $oncotree_ID_detail = $f[1];
        my $oncotree_main_tissue_ID = $f[3];
        my $drug = $f[4];
        my $Drug_claim_primary_name = $drug;
        $Drug_claim_primary_name =uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~s/\&//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\//_/g;
        my $hgvsg = $f[-2];
        my $final_variant = $f[-3];
        my $k1 = "$Drug_claim_primary_name\t$oncotree_ID_detail\t$hgvsg";
        my $k2 = "$Drug_claim_primary_name\t$oncotree_main_tissue_ID\t$hgvsg";
        push @{$hash1{$k1}},$final_variant;
        push @{$hash2{$k2}},$final_variant;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Oncotree_term/){
        my $Drug_claim_primary_name = $f[1];
        $Drug_claim_primary_name =uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~s/\&//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\//_/g;
        my $oncotree_id = $f[3];
        my $HGVSg = $f[-1];
        my $k = "$Drug_claim_primary_name\t$oncotree_id\t$HGVSg";
        if (exists $hash1{$k}){
            my @v1s = @{$hash1{$k}};
            foreach my $v1(@v1s){
                my $output = "$_\t$v1\thit_actionable_by_detail";
                unless(exists $hash3{$output}){
                    $hash3{$output} =1;
                    print $O1 "$output\n";
                    print $O3 "$output\tYes\n";
                }
            }
        }
        elsif(exists $hash2{$k}){
            my @v2s = @{$hash2{$k}};
            foreach my $v2(@v2s){
                my $output = "$_\t$v2\thit_actionable_by_main";
                unless(exists $hash3{$output}){
                    $hash3{$output} =1;
                    print $O1 "$output\n";
                    print $O3 "$output\tYes\n";
                }
            }
        }
        else{
            my $output = $_;
            unless(exists $hash4{$output}){
                $hash4{$output} =1;
                print $O2 "$output\n";
                print $O3 "$output\tNA\tNA\tNO\n";
            }
        }
    }
}

