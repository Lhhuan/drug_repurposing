#用../simple_somatic_mutation.largethan0.vcf 和../12_add_mutation_ensg_entrezid_info.txt 为snp_add_cadd_score 添加mutation id, 得文件./snv_cadd_score_mutation_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../12_add_mutation_ensg_entrezid_info.txt";
my $f2 = "./snv_add.txt";
my $fo1 = "./cadd_in_add.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    unless (/^Mutation_ID/){
        my @f = split/\t/;
        my $id= $f[0];
        $hash1{$id}=1;
    }
}

while(<$I2>)
{
    chomp;
    unless (/^#/){
       my $id = $_;
       $hash2{$id}=1;
       if (exists $hash1{$id}){
           print  $O1 "$id\n";
       }
       else{
           print "$id\t1234\n";
       }
    }
}

foreach my $id (sort keys %hash1){
    unless(exists $hash2{$id}){
        print "$id\n";
    }
}