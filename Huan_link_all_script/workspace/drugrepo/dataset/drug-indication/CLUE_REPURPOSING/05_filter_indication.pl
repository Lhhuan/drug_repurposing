#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#为04_split_indication.txt 寻找chembl id
my $f1 ="./04_split_indication.txt";
my $f2 = "./dgidb_unique_indication.txt";
my $fo1 = "./05_exist_indication.txt";  #indication是重复的文件
my $fo2 = "./05_no_indication.txt";  #indication没有重复的文件。 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2);

while(<$I1>)
{
   chomp;
   unless(/^chembl_id/){
       my @f = split/\t/;
       my $indication = $f[5];
       $indication=~ s/($indication)/\L$1/gi;
       $hash1{$indication} = 1;
   }
}

while(<$I2>)
{
   chomp;
    $_ =~ s/\(//g;
    $_ =~ s/\)//g;
   $_ =~ s/($_)/\L$1/gi;
   $hash2{$_}=1 ;
}

 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){  
           print $O1 "$key1\n";
       }
       else{
            print $O2 "$key1\n";
       }
 }

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";