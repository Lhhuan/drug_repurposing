
#!/usr/bin/perl

use warnings;
use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";
my @gene1;
my @disease;
while(<$file_hander1>)
{
    chomp;
    push(@gene1, (split /\t/,$_)[0] );
     push(@disease, (split /\t/,$_)[3]);
     my @f = split /\t/;
     my $gene = $f[0];
     my $dis = $f[3];
     push @{$hash1{$gene}},$dis;
}
my @gene2;
my @drug;
while(<$file_hander2>)
{
    chomp;
    push(@gene2,(split /\t/,$_)[0]);
    push(@drug,(split /\t/,$_)[4]);
    
   
}

my %hash1;
my %hash2;


while (<>) {

    chomp;

    my ($gene1, $disease) = split("=>");

    push @{$hash1{$gene1}}, $disease;

}

while (<>) {

    chomp;

    my ($gene2, $drug) = split("=>");

    push @{$hash2{$gene2}}, $drug;

}


foreach my $gene1 (keys %hash1) {

 

    my $disease = $hash1{$gene1};

  
    
     foreach my $gene2 (keys %hash2) {

  

      my $drug = $hash2{$gene2};


      
       my @f1 = split /\t/;
     my $gene1 = $f[0];
     my $disease = $f[3];
     push @{$hash1{$gene1}},$disease;
      }
  

}
print "1234\n"