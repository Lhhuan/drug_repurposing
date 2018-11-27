#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./25751625_Breast_cancer.txt";
my $fo1 ="./25751625_Breast_cancer_normalized.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
select $O1;
print "$header\n";


while(<$I1>) 
{
    chomp;
    my @f= split /\t/;
    unless(/^var_name/){
         for (my $i=0;$i<15;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[6];
         my $chr = $f[1];
         my $pos = $f[2];
         my $ref = $f[3];
         my $alt = $f[4];
         my $effect_allele = $f[7];
         my $beta = $f[10];
         my $se = $f[11];
         my $odds_ratio = $f[12];
         my $OR_P = $f[14];
         my $Zscore =$beta/$se;
        #  my $ci_low = $f[14];
        #  my $ci_high = $f[15];
        #  my $OR_95l = "[$ci_low, $ci_high]";
        #my $title = "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$effect_allele\t$beta\t$se\t$odds_ratio\tNA\tNA\tNA\tNA\t$OR_P\tNA\tNA\t123509\tNA\tNA";

        if ($effect_allele =~/a1/){
            my $effect_allele = $alt;
            my $baseline_allele = $ref;
            print "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$baseline_allele\t$effect_allele\t$beta\t$se\t$odds_ratio\tNA\t$Zscore\tNA\tNA\t$OR_P\tNA\tNA\t123509\tNA\tNA\n";
        }
        elsif($effect_allele =~/a0/){
            my $effect_allele = $ref;
            my $baseline_allele = $alt;
            print "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$baseline_allele\t$effect_allele\t$beta\t$se\t$odds_ratio\tNA\t$Zscore\tNA\tNA\t$OR_P\tNA\tNA\t123509\tNA\tNA\n";
        }
        else{
            print "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\tNA\t$effect_allele\t$beta\t$se\t$odds_ratio\tNA\t$Zscore\tNA\tNA\t$OR_P\tNA\tNA\t123509\tNA\tNA\n";
        }
    }
}

