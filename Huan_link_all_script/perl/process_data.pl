
#!/usr/bin/perl

use warnings;
use strict;
my $file1 = "./data/CGD.txt";
my $file2 = "./data/interactions.tsv";
open my $file_hander1, '<', $file1 or die "$0 : failed to open input file '$file1' : $!\n";
open my $file_hander2, '<', $file2 or die "$0 : failed to open input file '$file2' : $!\n";
my @gene1;
my @disease;

#my $ith_row = 0;
#my %file1=("@gene1" => $ith_row );
while(<$file_hander1>)
{
    chomp;
    push(@gene1, (split /\t/,$_)[0] );
     push(@disease, (split /\t/,$_)[3]);

    
    #print "@gene1\n";
    #print "@disease\n";
    # my %relation1=('@gene1','@disease');
}
   #print "@gene1\n";
   #foreach (@gene1){print "$_\n";}   
    #print "@disease\n";                                                                                         
my @gene2;
my @drug;

#my $jth_row = 0;
#my %file2=("@gene2" => $jth_row );
while(<$file_hander2>)
{
    chomp;
    push(@gene2,(split /\t/,$_)[0]);
    push(@drug,(split /\t/,$_)[4]);
    
    #print "@gene2\n";
    #print "@drug\n";
    #my %relation2=('@gene2','@drug');
}


 #print "@gene2\n";
 #print "@drug\n";
 my %seen;
 my @intergene;
   %seen=();
   foreach(@gene1) {
   $seen{$_}=1;
   }
   @intergene=grep($seen{$_},@gene2);
   
   # print "@intergene\n";
    # print "1234\n";
 
  #@gene1=keys %file1;
  #@gene2=keys %file2;   
   
    
    my %hash1;
foreach  (@gene1){
$hash1{$_}=1;
}
my %hash2;
foreach (@gene2){
$hash2{$_}=1;
}

foreach my $key (sort keys %hash1){
if(exists $hash2{$key}){
print "$key\n";
}
}
    
my @gene1 = <$file_hander1>;

while(<$file_hander2>){
  chomp;
  my $gene2_drug = (split(/\t/,$_))[4];
  my $gene2_gene = (split(/\t/,$_))[0]; 
  foreach my $gene1_line (@gene1){
    my $gene1_gene = (split(/\t/,$gene1_line))[0];
    my $gene1_disease = (split(/\t/,$gene1_line))[3];
    if($gene2_gene eq $gene1_gene){
      # print $gene2_drug."\t".$gene1_disease."\t".$gene2_gene."\n";
    }
  }
}
  # print "1234\n";





