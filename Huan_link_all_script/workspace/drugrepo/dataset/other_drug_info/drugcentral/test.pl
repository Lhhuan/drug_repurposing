# 把drug.target.interaction.tsv里ACT_VALUE不为0的unique的drug，得have_value_drug.txt #1855
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_drug ="./drug.target.interaction.tsv";
my $fo = "./have_value_drug.txt";

open my $I1, '<', $fi_drug or die "$0 : failed to open input file '$fi_drug' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
 my (%hash1,%hash2);
while(<$I1>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NONE"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
           unless($f[7] eq "NONE"){
              unless(exists $hash1{$f[0]}){
                  $hash1{$f[0]} =1;
                  print $O "$f[0]\n";
              }   
       }
   }
}



