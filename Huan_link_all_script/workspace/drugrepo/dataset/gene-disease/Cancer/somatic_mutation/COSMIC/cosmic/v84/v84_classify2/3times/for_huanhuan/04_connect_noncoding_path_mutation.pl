
#vep注释出来coding添加原来vcf中的alt,ref等信息。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../All_cosmic_Muts_largethan2_nm.vcf";
my $f2 ="./03_noncoding_gene.txt";
my $fo1 = "./04_noncoding_path_mutation_id.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "mutation_id\tchr\tpos\tref\talt\tensg_id\n";
select $O1;
print $title;
my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
     unless(/^CHROM/){
         my $chr = $f[0];
         my $pos = $f[1];
         my $mutation_id = $f[2];
         my $ref = $f[3];
         my $alt = $f[4];
         my $key = "$chr:$pos.$ref.$alt";
         my $v = "$mutation_id\t$chr\t$pos\t$ref\t$alt";
         push@{$hash1{$key}},$v;
     }
}                    


while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    unless(/^chr/){
        my $chr = $f[0];
        my $pos = $f[1];
        my $ref = $f[2];
        my $alt = $f[3];
        my $ensg_id = $f[4];
        $ensg_id =~ s/\.\S+//g;
        #print STDERR "$ensg_id\n";
        my $key = "$chr:$pos.$ref.$alt";
        my $v = $ensg_id;
        $hash2{$key}= $v;
    }
}



foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my @v1 = @{$hash1{$ID}};
        my $v2 = $hash2{$ID};
        foreach my $v(@v1){
            print $O1 "$v\t$v2\n";
        }
    }
}