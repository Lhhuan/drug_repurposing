#将"/f/mulinlab/huan/hongcheng/script/08_snv_gene_in_cancer_gene_missense.vcf" 中的protein 提取出来得../output/01_filter_missense_protein.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../script/B_sift_tmp/missense_varient.txt";
my $fo1 ="../output/01_filter_missense_protein_all_gene.txt";  #所有基因包含的蛋白，这些基因是未筛选之前的，即有的基因不是cancer gene
# my $f1 ="/f/mulinlab/huan/hongcheng/script/08_snv_gene_in_cancer_gene_missense.vcf";
# my $fo1 ="../output/01_filter_missense_protein.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "variant_id\tSWISSPROT\tTREMBL\tUNIPARC\n";

my(%hash1,%hash2);

while(<$I1>)
{
    chomp;
    unless(/^#/){
        my @f= split /\t/;
        my $variant_id = $f[0];
        print $O1 "$variant_id\t";
        my $extra = $f[-1];
        my @ts=split /\;/,$extra;
        if ($extra =~/SWISSPROT/){
            foreach my $t(@ts){
                if ($t=~/^SWISSPROT/){
                    my @s = split/\=/,$t;
                    my $SWISSPROT = $s[1];
                    print $O1 "$SWISSPROT\t";
                }  
            }
        }
        else{
        print $O1 "NA\t"; 
        }

        if ($extra =~ /TREMBL/){
            foreach my $t(@ts){
                if ($t =~/^TREMBL/){
                    my @s = split/\=/,$t;
                    my $TREMBL =$s[1];
                    print $O1 "$TREMBL\t";
                }
            }
        }
        else{
            print $O1 "NA\t";
        }

        if($extra =~ /UNIPARC/){
            foreach my $t(@ts){
                if ($t =~/^UNIPARC/){
                    my @s = split/\=/,$t;
                    my $UNIPARC =$s[1];
                    print $O1 "$UNIPARC\n";
                }
            }
        } 
        else{
            print $O1 "NA\n";
        }
    }
}
