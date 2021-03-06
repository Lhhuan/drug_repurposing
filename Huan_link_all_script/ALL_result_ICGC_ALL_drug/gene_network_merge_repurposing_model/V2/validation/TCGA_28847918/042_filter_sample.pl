#用"./output/041_overlap_huan.txt 取"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/28847918_normal_type.txt"
#中的信息，得./output/042_overlap_drug_sample_infos.txt
#./output/042_overlap_drug_sample_infos.txt 与./output/04_overlap_drug_sample_infos.txt 合并得最终./output/04_overlap_drug_sample_infos_final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/output/28847918_normal_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/041_overlap_huan.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/042_overlap_drug_sample_infos.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "Drug_chembl_id|Drug_claim_primary_name\tDrug\tSample\tValue\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $drug = $f[0];
        my $Drug_claim_primary_name =$drug;
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        push @{$hash1{$Drug_claim_primary_name}},$_;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $drug = $f[0];
        my $Drug_claim_primary_name =$drug;
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        my $Drug = $Drug_claim_primary_name;
        my $chembl = $f[1];
       if (exists $hash1{$Drug}){
           my @infos = @{$hash1{$Drug}};
           foreach my $info(@infos){
               my $output = "$chembl\t$info";
               unless(exists $hash2{$output}){
                   $hash2{$output}=1;
                   print $O1 "$output\n";
               }
           }
       }
    }
}
close ($O1);

system "cat ./output/04_overlap_drug_sample_infos.txt ./output/042_overlap_drug_sample_infos.txt > ./output/04_overlap_drug_sample_infos_final.txt";