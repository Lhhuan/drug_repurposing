use warnings;
use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";

my %hash1;
my %hash2;
while(<$file_hander1>)
{
    chomp;
     my @f1 = split /\t/;
     my $gene1 = $f1[0];
     my $disease = $f1[3];
     push @{$hash1{$gene1}},$disease;
#print "$gene1\n";
}


while(<$file_hander2>)
{
    chomp;  
  my @f2 = split /\t/;
     my $gene2 = $f2[0];
     my $drug = $f2[4];
     push @{$hash2{$gene2}},$drug;
        #print"$gene2\n";
}

foreach my $gene ( sort keys %hash1) {
  if(exists $hash2{$gene}){
     my @disease = @{$hash1{$gene}};
     my @drug = @{$hash2{$gene}};
     foreach my $d1 (@disease){
     foreach my $d2 (@drug){
          print $d2."\t".$d1."\t".$gene."\n";
      }
      }
      }
      }

