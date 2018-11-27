#对文件 somatic_mutation_coding_path_mutation_id.txt和somatic_mutation_noncoding_path_mutation_id.txt进行整理。得文件
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./somatic_mutation_coding_path_mutation_id.txt";
my $f2 ="./somatic_mutation_noncoding_path_mutation_id.txt";
my $fo1 ="./somatic_mutation_coding_path.txt"; 
my $fo2 ="./somatic_mutation_noncoding_path.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "Chrom:pos.ref.alt\tMutation_id\tENSG_ID";
select $O1;
print "$title\tSymbol\n"; 
select $O2;
print "$title\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^sample_id/){ #这个id其实是mutation_id
         my $mutation_id = $f[0];
         my $position = $f[1];
         my $ref = $f[2];
         my $alt = $f[3];
         my $ENSG_ID = $f[4];
         my $symbol = $f[5];
         $position = "$position.$ref.$alt";
         print $O1 "$position\t$mutation_id\t$ENSG_ID\t$symbol\n";
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^mutation_id/){
         my $mutation_id = $f[0];
         my $chr = $f[1];
         my $pos = $f[2];
         my $ref = $f[3];
         my $alt = $f[4];
         my $ensg_id = $f[5];
         my $position = "$chr:$pos.$ref.$alt";
         print $O2 "$position\t$mutation_id\t$ensg_id\n";
     }
}


