#此脚本是对../../test_data/01_filter_Sensitivity_clinical_significance.pl 的改进，因为相比于之前要加drug_interaction_type这列（因为要对两个药物的substance 进行拆分），所以重新跑
##把../../test_data/data/nightly-ClinicalEvidenceSummaries.tsv 中clinical_significan为Sensitivity的筛选出来，得./output/09_filter_Sensitivity_civic.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="../../test_data/data/nightly-ClinicalEvidenceSummaries.tsv";
my $fo1 ="./output/09_filter_Sensitivity_civic.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "drug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\tdrug_interaction_type\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^gene/){
        for (my $i=0;$i<38;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NONE";
        }
        unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
        }
        my $gene =$f[0];
        my $entrez_id = $f[1];
        my $variant = $f[2];
        my $disease = $f[3];
        my $drug = $f[6];
        my $clinical_significance = $f[11];
        my $evidence_statement = $f[12];
        my $evidence_id = $f[18];
        my $variant_id = $f[19];
        my $chr = $f[21];
        my $start = $f[22];
        my $end = $f[23];
        my $ref= $f[24];
        my $alt = $f[25];
        my $drug_interaction_type = $f[7];
        if ($clinical_significance =~/^Sensitivity/){
            unless($drug =~/NONE|NULL/){
                my $output = "$drug\t$disease\t$clinical_significance\t$gene\t$variant\t$evidence_statement\t$variant_id\t$chr\t$start\t$end\t$ref\t$alt\t$entrez_id\t$drug_interaction_type";
                unless(exists $hash1{$output}){
                    $hash1{$output}=1;
                    print $O1 "$output\n";
                }
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
