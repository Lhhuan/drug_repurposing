#统计"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf" 中CADD score 大于15，occurance 大于2的mutationID 的数目。
#得pathogenicity_15_occur_more_than2.txt ,在cancer中没有的mutation ID 文件cadd_morethan15_occur_morethan2_but_not_cancer_mutation_id.txt，在cancer中没有的mutation ID 等其他信息的文件cadd_morethan15_occur_morethan2_but_not_cancer_infos.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/cadd_score/SNV_Indel_cadd_score.vcf";
my $f2 = "../11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt";
my $fo1 = "./cadd_morethan15_occur_morethan2_but_not_cancer_mutation_id.txt";
my $fo2 = "./cadd_morethan15_occur_morethan2_but_not_cancer_infos.vcf";
my $fo3 = "./pathogenicity_15_occur_more_than2.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\s+/;
        my $mutation_id = $f[2];
        my $INFO = $f[7];
         my $MEANPHRED = $f[9];
        my @info_array = split(/;/,$INFO);
        foreach my $i (@info_array){
            if($i =~ /^affected_donors/){
                my @a_affected = split(/\=/,$i);
                if($a_affected[1] >1){
                    if($MEANPHRED>=15){
                        $hash1{$mutation_id}=$_;
                        print $O3 "$mutation_id\n";
                     }
                }
            }
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        $hash2{$Mutation_ID}=1;
    }
}

foreach my $mutation_id (sort keys %hash1){
    my $ori_info = $hash1{$mutation_id};
    unless(exists $hash2{$mutation_id}){
        print $O1 "$mutation_id\n";
        print $O2 "$ori_info\n";
    }
}