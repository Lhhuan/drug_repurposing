#为 "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt"
#从"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"提出mutation pathogenicity score，
#从"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"提出drug target score，得./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt";
my $f2 ="/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"; #致病性的mutation p score 
my $f3 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt";
my $fo1 = "./output/01_filter_gene_based_drug_target_score_cancer_mutation_pathogenicity.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, "| gzip >$fo1" or die $!;
print $O1 "CADD_MEANPHRED\tdrug_target_score\t";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if (/^Mutation_ID/){
        print $O1 "$_\n";
    }
    else{
        my @f =split/\t/;
        my $mutation_id = $f[0];
        push @{$hash1{$mutation_id}},$_;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#CHROM/){
        my @f =split/\t/;
        my $mutation_id = $f[2];
        my $MEANPHRED = $f[9];
        $hash2{$mutation_id}=$MEANPHRED;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){ #中Drug_chembl_id和$symbol均为大写
        my $Drug_chembl_id = $f[0]; #这列为Drug_chembl_id|Drug_claim_primary_name
        $Drug_chembl_id = uc($Drug_chembl_id);
        my $symbol = $f[1];
        $symbol =~s/"//g;
        $symbol =uc($symbol);
        my $drug_target_score = $f[-1];
        my $k = "$Drug_chembl_id\t$symbol";
        $hash3{$k}= $drug_target_score;
     }
}


foreach my $Mutation_ID (sort keys %hash1){
    my @cancer_infos = @{$hash1{$Mutation_ID}};
    if(exists $hash2{$Mutation_ID}){
        my $MEANPHRED = $hash2{$Mutation_ID};
        foreach my $cancer_info(@cancer_infos){
            my @f =split/\t/,$cancer_info;
            my $Drug_chembl_id= $f[13];
            $Drug_chembl_id =uc($Drug_chembl_id);
            my $gene_symbol =$f[14];
            $gene_symbol =uc($gene_symbol);
            my $drug_symbol = "$Drug_chembl_id\t$gene_symbol";
            if(exists $hash3{$drug_symbol}){
                my $drug_target_score = $hash3{$drug_symbol};
                my $output = "$MEANPHRED\t$drug_target_score\t$cancer_info";
                unless(exists $hash4{$output}){
                    $hash4{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }

    }
}



