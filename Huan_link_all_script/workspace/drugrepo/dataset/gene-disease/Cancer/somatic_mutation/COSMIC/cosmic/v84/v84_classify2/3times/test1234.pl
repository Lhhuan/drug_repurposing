#将coding 文件中，出现三次以上的variant筛选出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $fo1 = "./123_original_cosmic.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "Chrom:pos.ref.alt\n";


open my $DATE1, 'zcat ../../CosmicCodingMuts.vcf.gz|' or die "zcat CosmicCodingMuts.vcf.gz $0: $!\n"; 
open my $DATE2, 'zcat ../../CosmicNonCodingVariants.vcf.gz|' or die "zcat CosmicNonCodingVariants.vcf.gz $0: $!\n";  
my (%hash1,%hash2,%hash3,%hash4);
while(<$DATE1>)
{
    unless (/^#/){
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){  #alt 为.的去掉。
          my $chrom = $f1[0];
          my $pos = $f1[1];
          my $ref = $f1[3];
          my $alt = $f1[4];
          my $ID = $f1[2];
          my $v = "$chrom:$pos.$ref.$alt";
          unless(exists $hash1{$v}){
                print "$v\n";
                $hash1{$v} = 1;
            }
          
        }
  }
}


while(<$DATE2>)
{
    unless (/^#/){
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){  #alt 为.的去掉。
          my $chrom = $f1[0];
          my $pos = $f1[1];
          my $ref = $f1[3];
          my $alt = $f1[4];
          my $ID = $f1[2];
          my $v = "$chrom:$pos.$ref.$alt";
          unless(exists $hash1{$v}){
                print "$v\n";
                $hash1{$v} = 1;
            }
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
