#用从../simple_somatic_mutation.aggregated.vcf.gz中提取./pathogenicity_id_cadd_score.txt 的位置信息，得./pathogenicity_mutation_postion.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./pathogenicity_id_cadd_score.txt";
my $f2 = "../simple_somatic_mutation.aggregated.vcf.gz";
my $fo1 = "./pathogenicity_mutation_postion.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n");
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\tChr\tPos\tref\talt\n";

while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $mutation_id = $f[0];
        if ($mutation_id =~/Add/){#icgc 外的pathogenicity mutation 用其名字分隔位置
            # Add17:g.7577575A>C
            my $add = $mutation_id;
            $add =~ s/Add//g;
            $add =~ s/g.//g;
            my @t = split/:/,$add;
            my $chr = $t[0];
            $t[1] =~ /(\d+)/; #提取数字
            my $pos = $1;
            $add =~ s/\d+//g;
            $add =~ s/://g;
            my @allele = split/\>/,$add;
            my $ref= $allele[0];
            my $alt= $allele[1];
            print $O1 "$mutation_id\t$chr\t$pos\t$ref\t$alt\n";
        }
        else{
            $hash1{$mutation_id}=1;
        }
    }
}

while(<$I2>)
{
    chomp;
    unless (/^#/){
        my @f= split/\s+/;
        my $chr = $f[0];
        my $pos = $f[1];
        my $id = $f[2];
        my $ref= $f[3];
        my $alt = $f[4];
        my $output = "$id\t$chr\t$pos\t$ref\t$alt";
        if (exists $hash1{$id}){
            print $O1 "$output\n";
        }
    }
}
