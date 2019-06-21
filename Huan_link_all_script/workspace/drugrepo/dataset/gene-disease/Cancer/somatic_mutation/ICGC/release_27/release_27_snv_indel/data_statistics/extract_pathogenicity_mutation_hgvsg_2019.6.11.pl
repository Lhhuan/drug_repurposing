#用../simple_somatic_mutation.largethan0_vep.vcf 中提取./pathogenicity_id_cadd_score.txt 的 hgvsg,得./pathogenicity_mutation_postion_hgvsg.txt,
#并得目前所有mutation的hgvsg文件./icgc_and_add_hgvsg_before_2019.6.11.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./pathogenicity_id_cadd_score.txt";
my $f2 = "../simple_somatic_mutation.largethan0_vep.vcf";
my $fo1 = "./pathogenicity_mutation_postion_hgvsg.txt";
my $fo2 = "./icgc_and_add_hgvsg_before_2019.6.11.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Mutation_ID\thgvsg\n";
print $O2 "Mutation_ID\thgvsg\n";

while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $mutation_id = $f[0];
        if ($mutation_id =~/Add/){#icgc 外的pathogenicity mutation 用其名字分隔hgvsg
            # Add17:g.7577575A>C
            my $add = $mutation_id;
            $add =~ s/Add//g;
            my $output = "$mutation_id\t$add";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                print $O1 "$output\n";
            }
            unless(exists $hash3{$output}){
                $hash3{$output} =1;
                print $O2 "$output\n";
            }
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
        my $id = $f[0];
        my $Extra = $f[-1];
        my @ts= split/\;/,$Extra;
        foreach my $t(@ts){
            if ($t =~ /^HGVSg/){
                my @h = split/\=/,$t;
                my $hgvsg = $h[1];
                my $output = "$id\t$hgvsg";
                if (exists $hash1{$id}){ # pathogenicity mutation
                    unless(exists $hash2{$output}){
                        $hash2{$output} =1;
                        print $O1 "$output\n";
                    }
                    unless(exists $hash3{$output}){
                        $hash3{$output} =1;
                        print $O2 "$output\n";
                    }
                }
                else{
                    unless(exists $hash3{$output}){
                        $hash3{$output} =1;
                        print $O2 "$output\n";
                    }
                }
            }
        }
    }
}
