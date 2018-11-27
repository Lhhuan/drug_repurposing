use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";
my $gene1;
my $disease;
while(<$file_hander1>)
{
    chomp;
    $gene1=(split /\t/,$_)[0] ;
    $disease=(split /\t/,$_)[3];

  
    
     # foreach ($gene1){print "$_\n";}   
    #print "$disease\n";  
 
# print "$gene1\n"
 }
# print "$disease\n"; 
my $gene2;
my $drug;
while(<$file_hander2>)

{
    chomp;
   $gene2=(split /\t/,$_)[0];
    $drug=(split /\t/,$_)[4];
#print "$gene2\n";
#print "$drug\n";
if($gene1 eq $gene2) { 
print $drug."\t".$disease."\t".$gene1."\n";
   }
}

