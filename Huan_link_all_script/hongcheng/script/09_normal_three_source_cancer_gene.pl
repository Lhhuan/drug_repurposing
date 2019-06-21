#将../output/07_merge_three_source_gene_ensg.txt 中的MOA进行统一的命名，得../output/09_normal_three_source_cancer_gene_source.txt,../output/09_normal_three_source_cancer_gene.txt得unique的cancer信息，
#得../output/09_unique_tumor.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/07_merge_three_source_gene_ensg.txt";
my $fo1 ="../output/09_normal_three_source_cancer_gene_source.txt"; 
my $fo3 ="../output/09_normal_three_source_cancer_gene.txt";
my $fo2 ="../output/09_unique_tumor.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O1 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tSource\tENSG\tnormal_MOA\n";
print $O3 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tENSG\tnormal_MOA\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene_symbol/){
        my $Gene_symbol = $f[0];
        my $Entrez = $f[1];
        # my $Tumour_Types =$f[2];
        my $Tumour =$f[2];
        my $Tumour_Types = $Tumour;
        my $Role_in_Cancer = $f[3];
        my $Source = $f[4];
        my $ENSG = $f[5];
        my $normal_MOA= $Role_in_Cancer;
        $normal_MOA =~ s/\s+//g;
        $normal_MOA =~ s/oncogene,fusion/TSG,Oncogene/g;
        $normal_MOA =~ s/oncogene,TSG/TSG,Oncogene/g;
        $normal_MOA =~ s/TSG,fusion/TSG,Oncogene/g;
        $normal_MOA =~ s/TSG,Oncogene,fusion/TSG,Oncogene/g;
        $normal_MOA =~ s/fusion/Oncogene/g;
        $normal_MOA =~ s/oncogene/Oncogene/g;
        $normal_MOA =~ s/Driver/NA/g;
        $Tumour_Types =~s/\,>*\s/,/g; #把逗号后的空格替换为空
        $Tumour_Types =lc($Tumour_Types);
        # print "$Tumour_Types\t$Tumour\n";
        my @ts= split/\,/,$Tumour_Types;
        foreach my $t(@ts){
            $t =~ s/(^\s+|\s+$)//g; #去掉字符串前后的空格，前后各至少有一个空格
            my $output = "$Gene_symbol\t$Entrez\t$t\t$Role_in_Cancer\t$Source\t$ENSG\t$normal_MOA";
            unless(exists $hash1{$output}){
                $hash1{$output} =1;
                print $O1 "$output\n";
            }
            unless(exists $hash2{$t}){
                $hash2{$t} =1;
                print $O2 "$t\n";
            }
            my $output3 = "$Gene_symbol\t$Entrez\t$t\t$Role_in_Cancer\t$ENSG\t$normal_MOA";
            unless(exists $hash3{$output3}){
                $hash3{$output3} =1;
                print $O3 "$output3\n";
            }
        }
    }
}
