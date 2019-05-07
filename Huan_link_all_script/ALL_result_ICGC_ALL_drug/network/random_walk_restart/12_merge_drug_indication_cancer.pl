#利用../../output/all_drug_infos_score.txt和./output/11_ICGC_snv_indel_network_drug_cancer.txt 联系起来，把drug原来的indication等信息加过来，得./output/12_ICGC_snv_indel_network_drug_indication_cancer.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../output/all_drug_infos_score.txt";
my $f2 ="./output/11_ICGC_snv_indel_network_drug_cancer.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 ="./output/12_ICGC_snv_indel_network_drug_indication_cancer.txt.gz"; 
open my $O2, "| gzip >$fo2" or die $!;
my $header ="drug_name_network\tstart_id\tstart_entrez\trandom_overlap_fact_end_id\tnormal_score_P\tend_entrze\tCADD_MEANPHRED\tMutation_ID\tENSG\tMap_to_gene_level\tproject\tcancer_specific_affected_donors\tcancer_ID\tproject_full_name\tproject_full_name_from_project\toncotree_term_detail";
$header = "$header\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_ID_main_tissue\tgene_role_in_cancer";
$header ="$header\tDrug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tENSG_ID\tDrug_type\tdrug_target_score";
print $O2 "$header\n";
my %hash1;
my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){  #entrezgene和network_id转换
        my $drug = $f[0];
        my $drug_name = $drug;
        $drug_name =~s/\s+/_/g;#为了建文件夹方便，把空格替换成_
        $drug_name =~s/"//g;#后面也是为了建文件夹方便
        $drug_name =~s/\(//g;
        $drug_name =~s/\)//g;
        $drug_name =~s/\//_/g;
        $drug_name =~s/\&/+/g; #把&替换+
        $drug_name =~s/-/_/g;
        $drug_name =~s/,//g;
        $drug_name =~s/'//g;
        $drug_name =~s/\.//g;
        $drug_name =~s/\+//g;
        $drug_name =~s/\;//g;
        $drug_name =~s/\://g;
        my $Gene_symbol = $f[1];
        my $Entrez_id = $f[2];
        my $ENSG_ID = $f[14];
        my $Drug_type = $f[17];
        my $drug_target_score = $f[-1];
        my $v= "$drug\t$Gene_symbol\t$Entrez_id\t$ENSG_ID\t$Drug_type\t$drug_target_score";
        push @{$hash2{$drug_name}},$v;
    }
}



while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drug_name = $f[0];
        $drug_name =~s/\s+/_/g;#为了建文件夹方便，把空格替换成_
        $drug_name =~s/"//g;#后面也是为了建文件夹方便
        $drug_name =~s/\(//g;
        $drug_name =~s/\)//g;
        $drug_name =~s/\//_/g;
        $drug_name =~s/\&/+/g; #把&替换+
        $drug_name =~s/-/_/g;
        $drug_name =~s/,//g;
        $drug_name =~s/'//g;
        $drug_name =~s/\.//g;
        $drug_name =~s/\+//g;
        $drug_name =~s/\;//g;
        $drug_name =~s/\://g;
        # push @{$hash1{$drug_name}},$_; #这里的end是network num id
        if (exists $hash2{$drug_name}){
            my @drug_infos = @{$hash2{$drug_name}};
            my %hash3;
            @drug_infos = grep { ++$hash3{$_} < 2 } @drug_infos;
            foreach my $drug_info(@drug_infos){
                my $output = "$_\t$drug_info";
                print $O2 "$output\n";
            }
        }
    }
}



# foreach my $drug (sort keys %hash1){
#     my @oncotree_ids = @{$hash1{$drug}};
#     my %hash3;
#     @oncotree_ids = grep { ++$hash3{$_} < 2 } @oncotree_ids;
#     if (exists $hash2{$drug}){
#         my @drug_infos= @{$hash2{$drug}};
#         my %hash4;
#         @drug_infos = grep { ++$hash4{$_} < 2 } @drug_infos;
#         foreach my $oncotree_id (@oncotree_ids){
#             foreach my $drug_info(@drug_infos){
#                 print $O2 "$oncotree_id\t$drug_info\n";
#             }
#         }
#     }
#     else{
#         print STDERR "$drug\n";
#     }
# }