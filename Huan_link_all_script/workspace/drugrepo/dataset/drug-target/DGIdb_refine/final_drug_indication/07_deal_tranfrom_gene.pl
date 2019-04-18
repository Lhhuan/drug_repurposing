#对./output/transform.txt的一些字符进行一些处理，得文件./output/dgidb_entrez-ENSG_ID.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./output/transform.txt";
my $fo1 = "./output/dgidb_entrez-ENSG_ID.txt";  
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

 