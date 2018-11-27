#将find_closest.bed文件中的snp和最邻近的基因选出来。得文件03_noncoding_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

#my $f1 ="./123.txt";
my $f1 ="./find_closest.bed";
my $fo1 = "./03_noncoding_gene.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $f2 ="./ds_res.csv";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";

my $title = "chr\tpos\tref\talt\tENSG_ID\n";
select $O1;
print $title;


my(%hash1,%hash2,%hash3);
       
while(<$I1>)
{
    chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    $chr =~ s/chr//g;
    my $pos = $f[2];
    my $ref = $f[3];
    my $alt = $f[4];
    my $ensg_id = $f[14];
    $ensg_id =~ s/\"//g;
    $ensg_id =~ s/\;//g;
    my $k= "$chr\t$pos\t$ref\t$alt";
    $hash1{$k}= $ensg_id;
}

while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    my $chr = $f[0];
    my $pos = $f[1];
    my $ref = $f[2];
    my $alt = $f[3];  
    my $k= "$chr\t$pos\t$ref\t$alt";
    $hash2{$k}=1;   
} 

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $v1 = $hash1{$ID};
        my $v2 = $hash2{$ID};
            print $O1 "$ID\t$v1\n";
        
    }
}      
