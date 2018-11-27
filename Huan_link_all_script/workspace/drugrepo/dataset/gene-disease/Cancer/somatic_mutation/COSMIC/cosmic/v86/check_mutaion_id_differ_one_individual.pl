#检查chr pos ref alt 都相同一样，mutation ID不同，noncoding 是否来自同一个Sample name,Sample id,Id tumour
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $fo1 = "./test_sampleid_.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
print "sample_name\tID_sample\tID_tumor\tMutation_id\tChrom:pos.ref.alt\n";


open my $DATE1, 'zcat ./CosmicNonCodingVariants.vcf.gz|' or die "zcat CosmicNonCodingVariants.vcf.gz $0: $!\n"; 
open my $DATE2, 'zcat ./CosmicNCV.tsv.gz|' or die "zcat CosmicNCV.tsv.gz $0: $!\n";  
my (%hash1,%hash2,%hash3,%hash4);
while(<$DATE1>)
{
    unless (/^#/){
     chomp();  
      my @f1 = split /\s+/;
      my $chrom = $f1[0];
      my $pos = $f1[1];
          my $ref = $f1[3];
          my $alt = $f1[4];
          my $ID = $f1[2];
          my $v = "$chrom:$pos.$ref.$alt";
          $hash1{$ID}=$v;
    }
}

while(<$DATE2>)
{
    unless (/^Sample*name/){
     chomp();  
      my @f1 = split /\s+/;
      my $sample_name = $f1[0];
      my $ID_sample = $f1[1];
      my $ID_tumor = $f1[2];
      my $mutation_id = $f1[11];
      my $v= "$sample_name\t$ID_sample\t$ID_tumor";
          push@{$hash2{$mutation_id}},$v;
    }
}



foreach my $key (sort keys %hash1){
    if(exists $hash2{$key}){
        my @v = @{$hash2{$key}};
        my $pos = $hash1{$key};
        foreach my $v(@v){
            print $O1 "$v\t$key\t$pos\n";
        }
    }
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
