#尝试把unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.txt处理成vep input 的输入格式，得文件unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf
#!/usr/bin/perl
use warnings;
use strict;
use utf8;
my $f1 ="./unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.txt";
my $fo1 = "./unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "#";

my $i=0;
while(<$I1>)
{
   chomp;
   my @f = split/\t/;
   my $chr = $f[0];
   my $pos = $f[1]; 
   my $ref = $f[2];
   my $alt = $f[3];
   $i=$i+1;
   #print STDERR "$i\n";
   my $ID = "GWAS${i}";   #自定义的id，方便后面处理
   print $O1 "$chr\t$pos\t$ID\t$ref\t$alt\t.\t.\t.\n";
}