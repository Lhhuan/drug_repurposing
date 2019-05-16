#Network_based_drug_cancer_pairs_information: "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz"
#进行过滤./data/Network_based_drug_cancer_pairs_information.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic.txt.gz";
my $fo1 ="./data/Network_based_drug_cancer_pairs_information_logic_true.txt.gz";
my $fo2 ="./data/Network_based_drug_cancer_pairs_information_logic_conflict.txt.gz"; 
my $fo3 ="./data/Network_based_drug_cancer_pairs_information_logic_no.txt.gz"; 
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
open my $O1, "| gzip >$fo1" or die $!;
open my $O2, "| gzip >$fo2" or die $!;
open my $O3, "| gzip >$fo3" or die $!;

my $header = "the_shortest_path\tpath_logic\tpath_length\tdrug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tMutation_ID";
$header = "$header\tCancer_ENSG_ID\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tgene_role_in_cancer\tDrug_chembl_id_Drug_claim_primary_name\tEntrez_id_drug_target\tENSG_ID_target";
$header = "$header\tDrug_type\tdrug_target_score\tdrug_target_network_id\tthe_final_logic";
print $O1 "$header\n";
print $O2 "$header\n";
print $O3 "$header\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^the_shortest_path/){
        my $the_shortest_path = $f[0];
        my $path_logic = $f[1];
        my $path_length = $f[2];
        my $drug_name_network = $f[3];
        my $start_id = $f[4];
        my $start_entrez =$f[5];
        my $random_overlap_fact_end_id = $f[6];
        my $normal_score_P = $f[7];
        my $end_entrze = $f[8];
        my $CADD_MEANPHRED = $f[9];
        my $Mutation_ID = $f[10];
        my $Cancer_ENSG_ID = $f[11];
        my $Map_to_gene_level = $f[12];
        my $project = $f[13];
        my $cancer_specific_affected_donors = $f[14];
        my $cancer_ID = $f[15];
        my $gene_role_in_cancer = $f[-9];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[-8];
        my $Entrez_id_drug_target = $f[-6];
        my $ENSG_ID_target =$f[-5];
        my $Drug_type = $f[-4];
        my $drug_target_score = $f[-3];
        my $drug_target_network_id = $f[-2];
        my $the_final_logic= $f[-1]; 
        my $output = "$the_shortest_path\t$path_logic\t$path_length\t$drug_name_network\t$start_id\t$start_entrez\t$random_overlap_fact_end_id\t$normal_score_P\t$end_entrze\t$Mutation_ID";
        $output = "$output\t$Cancer_ENSG_ID\t$Map_to_gene_level\t$project\t$cancer_specific_affected_donors\t$gene_role_in_cancer\t$Drug_chembl_id_Drug_claim_primary_name\t$Entrez_id_drug_target\t$ENSG_ID_target";
        $output = "$output\t$Drug_type\t$drug_target_score\t$drug_target_network_id\t$the_final_logic";
        if ($the_final_logic =~ /true/){
            unless(exists $hash1{$output}){
                $hash1{$output} =1;
                print $O1 "$output\n";                
            }
        }
        elsif($the_final_logic =~ /conflict/){
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O2 "$output\n";
            }
        }
        else{
            unless (exists $hash3{$output}){
                $hash3{$output} =1;
                print $O3 "$output\n";
            }            
        }
    }
}


