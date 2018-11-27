
#将noncoding 文件中，出现两次以上的variant筛选出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fo1 = "./CosmicNonCodingVariants_largethan1_nm.vcf";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;

open my $DATE, 'zcat CosmicNonCodingVariants.vcf.gz|' or die "zcat CosmicNonCodingVariants.vcf.gz $0: $!\n";  
my %hash1;
my %hash2;
while(<$DATE>)
{
    if (/^#/){
        print $_;
    }
    else{
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){  #alt 为.的去掉。
          my $chrom = $f1[0];
          my $pos = $f1[1];
          my $key =$chrom."_".$pos;
          push @{$hash1{$key}},$_;
      }
    }
}

foreach my $key (sort keys %hash1){
    my @v = @{$hash1{$key}};
    my $num = @v;
    if($num > 1){
        foreach my $v(@v){
            unless(exists $hash2{$v}){
                        print "$v\n";
                        $hash2{$v} = 1;
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
