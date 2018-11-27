#为调参的start和end的gene symbol转换成entrez和在网络中的编号。分别得文件03_test_symbol_to_entrez_networkid.txt和03_test_start_end_networkid.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

#my $f1 ="./12345_sorted.paintorformat.11_119215476_120766806.processed.results";
my $f1= "/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28806749/fine_mapping/paintor/fine_mapping_output_result/28806749_Cervical_cancer_normalized_sorted.txt.paintorformat.6_31571218_32682664.processed.results";
# my $f2 ="../network_gene_num.txt";
# my $f3 ="./start_end.txt";
# my $fo1 ="./03_test_symbol_to_entrez_networkid.txt"; 
# my $fo2 ="./03_test_start_end_networkid.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

# select $O1;
# print "symbol\tentrezid\tid\n"; 
# select $O2;
# print "start_id\tend_id\n"; 
# my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
my $sum =0;
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^chromosome/){

         $sum = $sum+$f[-1];
         print"$sum\n";
     }
}

