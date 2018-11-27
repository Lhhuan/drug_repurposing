#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
#use Parallel::ForkManager; #多线程并行

my $f1 ="/f/mulinlab/huan/summary_statistics/original/summary_cancer_revise.txt";
# my $f1 ="./1234.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./all_cancer_credible_sets_0.99.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open input file '$fo1' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx\tPosterior_Prob\tsource_ID";
print $O1 "$header\n";
my $fo2 ="./all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open input file '$fo2' : $!\n";
print $O2 "chr\tpos\tref\talt\tsource_ID\n";
my %hash1;
# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目

my @text = <$I1>;#把文件读进数组
foreach my $line(@text) 
# while(<$I1>)
{
    chomp($line);
    unless($line=~/^File_name_Downloaded/){
        my @f= split /\t/,$line;
        # print "$_\n";
        my $PMID = $f[6];
        my $Folder_name_local = $f[10];   
        if($Folder_name_local=~/UKBB_biobank/){
            my $f2 = "$PMID/all_credible_sets_0.99.txt";
            open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
            while(<$I2>){
                chomp;
                unless(/^chromosome/){
                    my @sf = split/\t/;
                    my $chr = $sf[0];
                    my $pos = $sf[1]; 
                    my $ref = $sf[3];
                    my $alt = $sf[5];
                    #my $k = join("\t",@f[0..24]);

                    # for (my $i=0;$i<26;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
                    #     unless(defined $f[$i]){
                    #     $sf[$i] = "NONE";
                    #     }
                    # }
                    my $k = join("\t",@sf[0..24]);
                    # if ($sf[25]=~/^0.9/){
                    #     print $O1 "$_\t$PMID\n";
                    # }
                    # else{
                    #     print $O1 "$_\t\t$PMID\n";
                    # }
                    print $O1 "$k\t$PMID\n";
                    print $O2 "$chr\t$pos\t$ref\t$alt\t$PMID\n";

                }
                    
            }
           
            
        }
    }
}
      