#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./17529973_Breast_cancer.txt";
my $fo1 ="./17529973_Breast_cancer_normalized.txt"; 
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
     if(/^rs/){
         for (my $i=0;$i<16;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
         my $chr = $f[2];
         my $pos = $f[3];
         my $ref = $f[7];
         my $alt = $f[8];
         my $OR_P = $f[1]; 
         my $odds_ratio = $f[13];
         my $ci_low = $f[14];
         my $ci_high = $f[15];
         my $OR_95l = "[$ci_low, $ci_high]";
         print $O1 "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$odds_ratio\t$OR_95l\tNA\tNA\tNA\t$OR_P\tNA\tNA\t2329\tNA\tNA\n";
     }
}

