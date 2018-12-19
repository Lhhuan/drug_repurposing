#把"/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt" 中的drug target 中提取出来，新生成一列，这一列有ensg 用ensg填充，没有ensg用entrez填充，没有entrez拿gene symbol填充。
#并和./output/01_unique_merge_gene_based_and_network_based_data.txt merge在一起，得"./output/02_extract_drug_target_gene_network_data.txt",并得drug target 文件./output/02_drug_target.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
my $f2 = "./output/01_unique_merge_gene_based_and_network_based_data.txt";
my $fo1 = "./output/02_extract_drug_target_gene_network_data.txt";
my $fo2 = "./output/02_drug_target.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_entrze\tdrug_ENSG\tdrug_target_score\tend_entrze\tthe_shortest_path\tpath_length\tnormal_score_P\tMutation_ID\tcancer_specific_affected_donors\toriginal_cancer_ID\tCADD_MEANPHRED";
$header = "$header\tcancer_ENSG\toncotree_ID_main_tissue\tthe_final_logic\tMap_to_gene_level\tmap_to_gene_level_score\tdata_source\tdrug_target_number";
print $O1 "$header\n";
print $O2 "Drug_chembl_id_Drug_claim_primary_name\tdrug_target\n";

my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $symbol = $f[1];
        my $drug_entrze = $f[2];
        my $drug_ENSG = $f[14];
        if($drug_ENSG!~/NULL|UNKNOWN|NA|NONE/i){
            push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$drug_ENSG;
        }
        else{
            if($drug_entrze!~/NULL|UNKNOWN|NA|NONE/i){
                push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$drug_entrze;
            }
            else{
                if ($symbol!~/NULL|UNKNOWN|NONE/i){ #确认过 $symbol中没有NA
                    push @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}},$symbol;
                }
            }
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id_Drug_claim_primary_name/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        if (exists $hash1{$Drug_chembl_id_Drug_claim_primary_name}){
            my @drug_targets = @{$hash1{$Drug_chembl_id_Drug_claim_primary_name}};
            my %hash3;
            @drug_targets = grep { ++$hash3{$_} < 2 } @drug_targets;
            my $target_number = @drug_targets;
            my $targets = join ("|", @drug_targets);
            my $output = "$_\t$target_number";
            my $output2 = "$Drug_chembl_id_Drug_claim_primary_name\t$targets";
            print $O1 "$output\n";
            unless(exists $hash2{$output2}){
                $hash2{$output2} =1;
                print $O2 "$output2\n";
            }

        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄