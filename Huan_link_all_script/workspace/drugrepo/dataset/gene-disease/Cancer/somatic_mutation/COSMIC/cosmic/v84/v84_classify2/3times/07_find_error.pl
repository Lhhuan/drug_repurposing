
# 因为有的数据既有mannal中出现的标注，也有mannal中没有出现的标注。此脚本对cosmic_no_mannal.txt中出现在cosmic_no_mannal.txt中的进行去除。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./cosmic_mannal.txt";
my $f2 ="./cosmic_no_mannal.txt";
my $fo1 = "./co.txt";
my $fo2 = "./cosmic_true_no_mannal.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
# select $O1;
# print "chr:pos.ref.alt\taaref\taaalt\trevel_score\tID\tENSG_ID\tvariant_type\tsymbol\n";
select $O2;
 print "chr:pos.ref.alt\tID\tENSG_ID\tvariant_type\tsymbol\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^chr/){
        my @f= split /\t/;
        $hash1{$f[0]}=1;
    }
}
          
while(<$I2>)
{
    chomp;
    unless(/^chr/){
        my @f= split /\t/;
        push{$hash2{$f[0]}},$_;
    }

}

foreach my $key (sort keys %hash2){
    if (exists $hash1{$key}){
        my $s = $hash1{$key};
        unless(exists $hash3{$key}){
          print $O1 "$key\n";
          $hash3{$key} = 1;
         
        }    
    }
    else{
        my @f = $hash2{$key};
        foreach my $s(@f){
            unless(exists $hash4{$s}){
                print $O2 "$s\n";
                $hash4{$s} = 1;
         
           }    

        }
    }
}