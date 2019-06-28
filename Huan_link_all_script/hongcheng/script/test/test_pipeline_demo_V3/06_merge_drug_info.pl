#利用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt和./output/05_network_drug_mutation.txt 联系起来，把drug原来的indication等信息加过来，
#得./output/06_mutation_network_drug_indication_cancer.txt.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt";
my $f2 ="./output/05_network_drug_mutation.txt.gz";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
my $fo2 ="./output/06_mutation_network_drug_indication_cancer.txt.gz"; 
open my $O2, "| gzip >$fo2" or die $!;
my $header= "network_drug_name\tstart_id\tstart_entrez\trandom_overlap_fact_end\tnormal_score_P"; #network
# $header = "$header\tcancer_entrez"; #
$header = "$header\tVariant_id\tENSG\tConsequence\tProtein\tB_sift_score\tmutation_to_gene_moa\tEntrez\tTumour_Types\tcancer_gene_normal_MOA\tMOA_rule"; #mutation
$header= "$header\tDrug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id";
$header= "$header\tDrug_type\tdrug_target_score\tPACTIVITY_median";
print $O2 "$header\n";
my %hash1;
my %hash2;


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){  #entrezgene和network_id转换
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_name = $Drug_chembl_id_Drug_claim_primary_name;
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
        my $Drug_claim_primary_name= $f[4];
        my $Drug_chembl_id =$f[5];
        my $Max_phase =$f[6];
        my $First_approval =$f[7];
        my $Clinical_phase =$f[11];
        my $Drug_indication_Indication_class =$f[13];
        my $ENSG_ID =$f[14];
        my $Indication_ID = $f[16];
        my $Drug_type = $f[17];
        my $indication_OncoTree_term_detail =$f[22];
        my $indication_OncoTree_IDs_detail =$f[23];
        my $indication_OncoTree_main_term =$f[24];
        my $indication_OncoTree_main_ID =$f[25];
        my $drug_target_score =$f[26];
        my $PACTIVITY_median = $f[27];
        # my $v= "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id\t$Drug_claim_primary_name\t$Drug_chembl_id\t$Max_phase\t$First_approval\t$Clinical_phase\t$Drug_indication_Indication_class\t$Indication_ID";
        # $v= "$v\t$Drug_type\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID\t$drug_target_score\t$PACTIVITY_median";
        my $v= "$Drug_chembl_id_Drug_claim_primary_name\t$Gene_symbol\t$Entrez_id";
        $v= "$v\t$Drug_type\t$drug_target_score\t$PACTIVITY_median";
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
