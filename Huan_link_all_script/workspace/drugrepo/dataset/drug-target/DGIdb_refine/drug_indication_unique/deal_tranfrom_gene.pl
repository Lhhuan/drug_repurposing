#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将文件03_chembl_drug.txt中的一行中的多个indication进行分割
my $f1 ="./transform.txt";
my $fo1 = "./dgidb_symbol-ENSG_ID.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "Entrez_id\tENSG_ID\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/^query/){
       if (/^\d/){
           my @f = split/\t/;
           my $symbol = $f[0];
           my $ensg = $f[3];
           $ensg =~ s/\s+//g;
           $ensg =~ s/"list\(gene=""//g;
           $ensg =~ s/"list\(gene=c\(""//g;#只取转换过的第一个ensgid
           $ensg =~ s/"".\S+//g;#只取转换过的第一个ensgid
           #print STDERR "$ensg\n";
           my $out = "$symbol\t$ensg";
           unless(exists $hash1{$out}){
               print $O1 "$out\n";
               $hash1{$out} = 1; 
           }
       }
   }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";

 