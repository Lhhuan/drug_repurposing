#为pancancer_mutation.largethan1_occurance.txt 从./cadd_score/SNV_Indel_cadd_score.vcf中提取CADD score,得pancancer_mutation.largethan1_occurance_CADD.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./cadd_score/SNV_Indel_cadd_score.vcf";
my $f2 = "./pancancer_mutation.largethan1_occurance.txt";
my $fo1 = "./pancancer_mutation.largethan1_occurance_CADD.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

print $O1 "Mutation_ID\tOccur_time\tPathogenicity_score\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my @f =split/\s+/;
        my $mutation_id = $f[2];
        my $MEANPHRED = $f[9];
        $hash1{$mutation_id}=$MEANPHRED;
        
        
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        my $Occur_time = $f[1];
        if (exists $hash1{$Mutation_ID}){
            my $CADD = $hash1{$Mutation_ID};
            print $O1 "$_\t$CADD\n";
        }
    }
}
