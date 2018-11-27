#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./28806749_Cervical_cancer.txt";
my $fo1 ="./28806749_Cervical_cancer_normalized.txt"; 
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
         #---------------------------------------#根据位置信息用tabix提取ref和alt
         my $pid = "$chr:$pos-$pos";
         my $line = `/f/Tools/htslib/htslib-1.5/tabix  /f/mulinlab/zhouyao/vanno_db/FA/VannoDB_FA_dbSNP_150/VannoDB_FA_dbSNP_150.vcf.gz $pid`;
        #  my $line = `/f/Tools/htslib/htslib-1.5/tabix  /f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/germline/1kg_phase3_v5/1kg_phase3_v5/EUR/1kg.phase3.v5.shapeit2.eur.hg19.all.SNPs.IDS.uniq.vcf.bgz.gz  $pid`;
        chomp($line);  
        my @f1 = split /\s+/,$line;
        my $chrom = $f1[0];
        my $POS = $f1[1];
        #  my $ID = $f1[2];
        my $ref = $f1[3];
        my $alt = $f1[4];
        #---------------------------------------------
        my $effect_allele = $f[3];
        my $OR_P = $f[11]; 
        my $odds_ratio = $f[6];
        my $se = $f[7];
        my $zscore = $odds_ratio/$se;
        if( $ref eq$effect_allele){
            my $baseline_allele= $alt;
            print $O1 "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$baseline_allele\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\t$zscore\tNA\tNA\t$OR_P\tNA\tNA\t9347\tNA\tNA\n";
        }
        # elsif($alt eq$effect_allele){
        else{
            my $baseline_allele= $ref;
            print $O1 "$chr\t$pos\t$rsid\t$ref\tNA\t$alt\tNA\tNA\tNA\t$baseline_allele\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\t$zscore\tNA\tNA\t$OR_P\tNA\tNA\t9347\tNA\tNA\n";
        }
        # else{
        #     print $O1 "$chr\t$pos\t$rsid\tUN\tNA\tUN\tNA\tNA\tNA\tUN\t$effect_allele\tNA\t$se\t$odds_ratio\tNA\t$zscore\tNA\tNA\t$OR_P\tNA\tNA\t9347\tNA\tNA\n";
        # }#填写UN代表在千人基因组中找不到，之后手动用dbSNP查找。
         
     }
}




