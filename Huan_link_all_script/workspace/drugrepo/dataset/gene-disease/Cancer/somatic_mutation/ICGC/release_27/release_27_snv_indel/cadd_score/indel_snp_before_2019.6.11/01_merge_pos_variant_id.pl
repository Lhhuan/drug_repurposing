#用../simple_somatic_mutation.largethan0.vcf 和../12_add_mutation_ensg_entrezid_info.txt 为snp_add_cadd_score 添加mutation id, 得文件./snv_cadd_score_mutation_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./snp_add_cadd_score";
# my $f2 = "../12_add_mutation_ensg_entrezid_info.txt";
my $f3 = "../simple_somatic_mutation.largethan0.vcf";
my $fo1 = "./snv_cadd_score_mutation_id.txt";
my $fo2 = "./snv_add.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    if (/^#CHROM/){
        print $O1 "Mutation_id\t$_\n";
    }
    else{
        my @f = split/\t/;
        my $chr = $f[0];
        my $pos = $f[1];
        $pos =~s/\..*$//g;
        my $ref= $f[2];
        my $alt =$f[3];
        my $RAW = $f[4];
        my $PHRED =$f[5];
        my $COMMENT = $f[6];
        my $final_PHRED= $f[7];
        my $v= "$chr\t$pos\t$ref\t$alt\t$RAW\t$PHRED\t$COMMENT\t$final_PHRED";
        if ($COMMENT =~/ICGC/){
            my $k = "$chr,$pos,$ref,$alt";
            $hash1{$k}=$v;
        }
        else{
            my $mutation_id = "Add${chr}:g.${pos}${ref}>${alt}";
            my $output = "$mutation_id\t$v";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
            unless (exists $hash3{$mutation_id}){
                $hash3{$mutation_id} =1;
                print $O2 "$mutation_id\n";
            }
        }
    }
}

while(<$I3>)
{
    chomp;
    unless (/^#/){
        my @f = split/\s+/;
        my $chr = $f[0];
        my $pos = $f[1];
        my $ref = $f[3];
        my $alt = $f[4];
        my $mutation_id = $f[2];
        my $k = "$chr,$pos,$ref,$alt";
        # print "$k\n";
        if (exists $hash1{$k}){
            my $v= $hash1{$k};
            my $output = "$mutation_id\t$v";
            print $O1 "$output\n";
        }
    }
}
