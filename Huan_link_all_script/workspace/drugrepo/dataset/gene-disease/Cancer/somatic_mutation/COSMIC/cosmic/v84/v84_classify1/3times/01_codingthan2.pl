#将coding 文件中，出现三次以上的variant筛选出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $fo1 = "./CosmicCodingMuts_largethan2_nm.vcf";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
#print "CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n";


open my $DATE, 'zcat ../CosmicCodingMuts.vcf.gz|' or die "zcat CosmicCodingMuts.vcf.gz $0: $!\n"; 
#open my $DATE, 'zless test.vcf.bed|' or die "zless test.vcf.bed $0: $!\n"; 
my %hash1;
my %hash2;
while(<$DATE>)
{
    if (/^#/){
        #print "$_\n";
        print $_;
    }
    else{
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){ #alt 为.的去掉。
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
    if($num > 2){
        foreach my $v(@v){
            unless(exists $hash2{$v}){
                        print "$v\n";
                        $hash2{$v} = 1;
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
