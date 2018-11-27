#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将所有有indication和target的drug数据和在一个文件里。
my $f1 ="./04_drug_target_indication.txt";
my $f2 = "./no_repeat_hub.txt";
my $fo1 = "./05_common.txt";  
my $fo2 = "./05_differ.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";


my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   my $key = $_;
   $hash1{$key}=1;
}

while(<$I2>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name = $f[0];
       $hash2{$drug_name}=1;     
   }
}

foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ #在dgidb中找不到target
           print $O1 "$key1\n";
       }
       else{
           print $O2 "$key1\n";
       }
}


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
#close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";