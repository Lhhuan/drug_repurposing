#把所有的mutation Pathogenicity 合在一起
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output/Pathogenicity_score_inversion.txt";
my $f2 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output/Pathogenicity_score_translocation.txt";
my $f3 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output/Pathogenicity_score_duplication.txt";
my $f4 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output/Pathogenicity_score_cnv.txt";
my $f5 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_cnv_and_indel_both/huan_handle_Pathogenicity/output/Pathogenicity_score_deletion.txt";
my $f6 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/pancancer_mutation.largethan1_occurance_CADD.txt";
my $fo1 = "../output_data/all_mutation_Pathogenicity.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

my $duplication_c = "wc -l $f1";
my $duplication_line = readpipe($duplication_c); #system 返回值


print $O1 "Mutation_ID\tPathogenicity_score\tSource\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $pos = join("\,",@f[0..5]);
        my $MEANPHRED = $f[-1];
        print $O1 "$pos\t$MEANPHRED\tInversion\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $pos = join("\,",@f[0..5]);
        my $MEANPHRED = $f[-1];
        print $O1 "$pos\t$MEANPHRED\tTranslocation\n";
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $pos = join("\,",@f[0..2]);
        my $MEANPHRED = $f[-1];
        print $O1 "$pos\t$MEANPHRED\tDuplication\n";
    }
}

while(<$I4>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $pos = join("\,",@f[0..2]);
        my $MEANPHRED = $f[-1];
        print $O1 "$pos\t$MEANPHRED\tCNV\n";
    }
}

while(<$I5>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\t/;
        my $pos = join("\,",@f[0..2]);
        my $MEANPHRED = $f[-1];
        print $O1 "$pos\t$MEANPHRED\tDeletion\n";
    }
}
while(<$I6>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_ID/){
        my @f =split/\t/;
        my $Mutation_ID = $f[0];
        my $MEANPHRED = $f[-1];
        print $O1 "$Mutation_ID\t$MEANPHRED\tSNV/Indel\n";
    }
}
close ($O1);

# while(<$I2>)
# {
#     chomp;
#     my @f= split/\t/;
#     unless (/^Mutation_ID/){
#         my $Mutation_ID =$f[0];
#         my $Occur_time = $f[1];
#         if (exists $hash1{$Mutation_ID}){
#             my $CADD = $hash1{$Mutation_ID};
#             print $O1 "$_\t$CADD\n";
#         }
#     }
# }
