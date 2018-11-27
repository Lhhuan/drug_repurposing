#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./17401363_Prostate_cancer_1.txt";
my $f2 ="./17401363_Prostate_cancer_2.txt";
my $fo1 ="./17401363_Prostate_cancer_1_normalized.txt"; 
my $fo2 ="./17401363_Prostate_cancer_2_normalized.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
select $O1;
print "$header\n";
select $O2;
print "$header\n";
#print  STDERR "$header\n";

while(<$I1>) 
{
    chomp;
    my @f= split /\t/;
     if(/^rs/){
         for (my $i=0;$i<17;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
         my $chr = $f[1];
         my $pos = $f[2];
         my $OR_P = $f[3]; 
         my $odds_ratio = $f[9];
         print $O1 "$chr\t$pos\t$rsid\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$odds_ratio\tNA\tNA\tNA\tNA\t$OR_P\tNA\tNA\t2329\tNA\tNA\n";
     }
}

while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     if(/^rs/){
         for (my $i=0;$i<17;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
         my $chr = $f[1];
         my $pos = $f[2];
         my $OR_P = $f[3]; 
         my $odds_ratio = $f[11];
         my $ci_low = $f[13];
         my $ci_high = $f[14];
         my $OR_95l = "[$ci_low, $ci_high]";
         print $O2 "$chr\t$pos\t$rsid\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$odds_ratio\t$OR_95l\tNA\tNA\tNA\t$OR_P\tNA\tNA\t2329\tNA\tNA\n";
     }

}

close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";



