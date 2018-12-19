#根据是否明确说明是ref 和alt变异进行对./output/02_Sensitivity_clinical_significance_oncotree.txt筛选，得有SV文件./output/04_SV.txt,
#得到transvar可以转换的文件./output/04_used_to_transvar.txt
#用transvar 对./output/04_used_to_transvar.txt中的variant进行转换，得./output/04_transvar_unknown_ref_alt.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/02_Sensitivity_clinical_significance_oncotree.txt";
my $fo1 ="./output/04_SV.txt";
my $fo2 ="./output/04_used_to_transvar.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./output/04_transvar_unknown_ref_alt.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "oncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\n";
print  $O2 "oncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene:variant\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_main_tissue_ID/){
        my $oncotree_main_tissue_ID = $f[0];
        my $drug = $f[1];
        my $disease = $f[2];
        my $clinical_significance = $f[3];
        my $gene =$f[4];
        my $variant = $f[5];
        my $evidence_statement = $f[6];
        my $variant_id = $f[7];
        my $chr = $f[8];
        my $start = $f[9];
        my $end = $f[10];
        my $ref =$f[11];
        my $alt = $f[12];
        my $entrez_id = $f[13];
        my $drug_cancer_pairs = "$drug\t$oncotree_main_tissue_ID";
        if ($variant =~/FUSION|DELETION|COPY NUMBER VARIATION|AMPLIFICATION/i){
            if($variant=~/[A-Z]\d+[A-Z]/){
                if ($variant =~/ATP1B1-NRG1 fusion/){ #属于没有氨基酸突变的SV
                    print $O1 "$_\n";
                }
                else{ #有三个类似于ALK FUSION F1245C这样子的突变
                    $variant =~s/ALK FUSION//g;
                    $variant =~s/\s+//g;
                    $variant=~ s/.*\s+//g;
                    my $output1 ="$oncotree_main_tissue_ID\t$drug\t$disease\t$clinical_significance\t$gene\:p.$variant\t$gene\t$variant\t$evidence_statement\t$variant_id\t$chr\t$start\t$end\t$ref\t$alt\t$entrez_id";
                    print $O2 "$output1\n";
                    my $transvar_results = readpipe ("transvar panno -i $variant --ensembl | cut -f1,5");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
                    print $O3 "$transvar_results";
                }
               
            }
            else{
                print $O1 "$_\n";#属于没有氨基酸突变的SV
            }
        }
        else{
            # unless ($variant =~/mutation/i){
            if($variant=~/[A-Z]\d+[A-Z]/){
                $variant=~ s/\+/,/g; #将+前后的空格及+替换成，
                #$variant=~ s/\s+\+\s+/,/g; #将+前后的空格及+替换成，
                $variant=~ s/.*\s+//g;
                unless($variant=~/FGFR3-BAIAP2L1|MEF2D-CSF1R|KIF5B-RET|FIP1L1-PDGFRA/){
                    $variant=~ s/S310F\/Y/S310F,S310Y/g;
                    $variant=~ s/-/,/g;
                    $variant=~ s/_/,/g;
                    $variant =~s/C1156Y(.+?)L1198F/C1156Y,L1198F/g;
                    my @variant_array = split /\,/,$variant;
                    foreach my $variant_after_split (@variant_array){
                        my $final_variant = "$gene\:p.$variant_after_split";
                        my $output = "$oncotree_main_tissue_ID\t$drug\t$disease\t$clinical_significance\t$gene\:p.$variant_after_split\t$gene\t$variant_after_split\t$evidence_statement\t$variant_id\t$chr\t$start\t$end\t$ref\t$alt\t$entrez_id";
                        unless(exists $hash4{$output}){
                            $hash4{$output}=1;
                            print  $O2 "$output\n";
                        }
                        my $transvar_results = readpipe ("transvar panno -i $final_variant --ensembl | cut -f1,5");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
                        print $O3 "$transvar_results";

                    }
                }
            }
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
