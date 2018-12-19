#根据是否明确说明是ref 和alt变异进行对./output/02_Sensitivity_clinical_significance_oncotree.txt筛选，得有ref和alt文件./output/04_known_ref_alt.txt,对ref和alt的文件进行处理，
#得到transvar可以转换的文件./output/04_unknown_ref_alt.txt
#用transvar 对./output/04_unknown_ref_alt.txt中的variant进行转换，得./output/04_transvar_unknown_ref_alt.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/02_Sensitivity_clinical_significance_oncotree.txt";
my $fo1 ="./output/04_known_ref_alt.txt";
my $fo2 ="./output/04_unknown_ref_alt.txt";
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
        if($ref!~/NULL|NONE/ || $alt !~/NULL|NONE/){ #ref 或者alt不为空
            $hash1{$drug_cancer_pairs}=1;
            print $O1 "$_\n";
        }
        else{
            push @{$hash2{$drug_cancer_pairs}},$_;
        }
    }
}

foreach my $drug_cancer_pairs(sort keys %hash2){
    my @infos = @{$hash2{$drug_cancer_pairs}};
    foreach my $info(@infos){
        my @f= split/\t/,$info;
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
        # $variant =~s/\s+\+\s+/,/g;
        # $variant =~ s/Ex19delL858R/L858R/g;
        # $variant =~s/EML4-ALKC1156Y–L1198F/C1156Y,L1198F/g;
        if(exists $hash1{$drug_cancer_pairs}){
            if ($variant =~/FUSION|DUP|DELETION|COPY NUMBER VARIATION|AMPLIFICATION|/i){ #把有点突变的FUSION|DUP|DELETION|COPY NUMBER VARIATION|AMPLIFICATION纳入进来，其他的FUSION|DUP|DELETION和 over expression等
                unless(exists $hash3{$info}){
                    $hash3{$info} =1;
                    print $O1 "$info\n";
                }
            }
            # else{ #只要FUSION|DUP|DELETION类型的突变丢掉
            # }
        }
        #ref 和alt都是NULL或者NONE,把可以用transvar转换的格式
        if($variant=~/C284Y|E2014K\ \+\ E2419K|E374K|C1156Y|L1198F|L858R|G719D|L1237F|L747P|L838P|L861Q|L861R|N826Y|N842S|Q456X|R201H|R705K|R776C|S310F\/Y|T618I|T847I|V742A|V774A|V774M|V834I|V851I/){
            $variant =~s/\s+\+\s+/,/g;
            $variant =~ s/Ex19\ del\ L858R/L858R/g;
            $variant =~s/\s+/"/g;
            $variant =~s/EML4\-ALK"//g;
            $variant =~s/C1156Y(.+?)L1198F/C1156Y,L1198F/g;
            $variant =~ s/S310F\/Y/S310F,S310Y/g;
            # print STDERR "$variant\n";
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


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
