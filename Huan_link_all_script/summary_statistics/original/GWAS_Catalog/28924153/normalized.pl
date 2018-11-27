#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./28924153_Neuroblastoma_\(1p_deletion\).txt";
my $fo1 ="./28924153_Neuroblastoma_\(1p_deletion\)_normalized.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
select $O1;
print "$header\n";

while(<$I1>) 
{
    chomp;
    my $file = $_;
    $file =~ s/^\s+//g;
    my @f= split /\s+/,$file;
     unless(/CHR/){
         for (my $i=0;$i<16;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
           unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[1];
         my $chr = $f[0];
         my $pos = $f[2];
         #my $ref = $f[3];
        #  my $alt = $f[8];
        my $effect_allele = $f[3];
        my $Chisq = $f[7];
        my $OR_P = $f[8]; 
        my $odds_ratio = $f[9];
        my $se = $f[10];
                #  my $ci_low = $f[14];
        #  my $ci_high = $f[15];
        #  my $OR_95l = "[$ci_low, $ci_high]";
         print $O1 "$chr\t$pos\t$rsid\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\tNA\tNA\t$Chisq\t$OR_P\tNA\tNA\t7168\tNA\tNA\n";
     }
}


my $f2 ="./28924153_Neuroblastoma_\(11q_deletion\).txt";
my $fo2 ="./28924153_Neuroblastoma_\(11q_deletion\)_normalized.txt"; 
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O2;
print "$header\n";

while(<$I2>) 
{
    chomp;
    my $file = $_;
    $file =~ s/^\s+//g;
    my @f= split /\s+/,$file;
     unless(/CHR/){
         for (my $i=0;$i<16;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
           unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[1];
         my $chr = $f[0];
         my $pos = $f[2];
         #my $ref = $f[3];
        #  my $alt = $f[8];
        my $effect_allele = $f[3];
        my $Chisq = $f[7];
        my $OR_P = $f[8]; 
        my $odds_ratio = $f[9];
        my $se = $f[10];
                #  my $ci_low = $f[14];
        #  my $ci_high = $f[15];
        #  my $OR_95l = "[$ci_low, $ci_high]";
         print $O2 "$chr\t$pos\t$rsid\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\tNA\tNA\t$Chisq\t$OR_P\tNA\tNA\t7168\tNA\tNA\n";
     }
}

my $f3 ="./28924153_Neuroblastoma_\(MYCN_amplification\).txt";
my $fo3 ="./28924153_Neuroblastoma_\(MYCN_amplification\)_normalized.txt"; 
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

select $O3;
print "$header\n";

while(<$I3>) 
{
    chomp;
    my $file = $_;
    $file =~ s/^\s+//g;
    my @f= split /\s+/,$file;
     unless(/CHR/){
         for (my $i=0;$i<16;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
           unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[1];
         my $chr = $f[0];
         my $pos = $f[2];
         #my $ref = $f[3];
        #  my $alt = $f[8];
        my $effect_allele = $f[3];
        my $Chisq = $f[7];
        my $OR_P = $f[8]; 
        my $odds_ratio = $f[9];
        my $se = $f[10];
                #  my $ci_low = $f[14];
        #  my $ci_high = $f[15];
        #  my $OR_95l = "[$ci_low, $ci_high]";
         print $O3 "$chr\t$pos\t$rsid\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\tNA\tNA\t$Chisq\t$OR_P\tNA\tNA\t7168\tNA\tNA\n";
     }
}



