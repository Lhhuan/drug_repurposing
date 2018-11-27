#将interactions_v3.tsv中的unique的drug筛出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi  ="./interactions_v3.tsv";
#my $fi  ="./test123.txt";
my $fo = "./interactions_v3-5drug.txt";

open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print"drug_chembl_id\n";
my %hash1;
my %hash2;

while(<$I>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       }
       if($f[5] =~ /\bNONE\b/){  
           my $drug_claim_name = $f[5];
           my $key =  $drug_claim_name;
           #my $key = "$f[1]\t$drug_claim_name\t$f[8]";
           unless(exists $hash2{$drug_claim_name}){
           print "$key\n";
           $hash2{$key} = 1
           } 
       }  
   }    
}

close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

