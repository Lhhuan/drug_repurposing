#选出MELA-AU和SKCM-US的>=2的snv和indel信息。得../output/snv_indel.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/ID_project.txt";
my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/simple_somatic_mutation.largethan2.vcf";
my $fo1 = "../output/snv_indel.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "ID\tchr\tpos\tref\talt\t\tproject\tcancer_specific_affected_donors\n";

while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f= split/\t/;
        my $ICGC_Mutation_ID =$f[0];
        my $project =$f[1];
        my $cancer_specific_affected_donors =$f[2];
        if ($project =~/MELA-AU|SKCM-US/){
            if ($cancer_specific_affected_donors>1){
                my $v = "$project\t$cancer_specific_affected_donors";
                push @{$hash1{$ICGC_Mutation_ID}},$v;
            }
        }
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\s+/;
    my $chr= $f[0];
    my $pos = $f[1];
    my $id = $f[2];
    my $ref = $f[3];
    my $alt = $f[4];
    if (exists $hash1{$id}){
        my @occurs = @{$hash1{$id}};
        foreach my $occur(@occurs){
            my $output= "$id\t$chr\t$pos\t$ref\t$alt\t$occur";
            print $O1 "$output\n";
        }
    }
}


