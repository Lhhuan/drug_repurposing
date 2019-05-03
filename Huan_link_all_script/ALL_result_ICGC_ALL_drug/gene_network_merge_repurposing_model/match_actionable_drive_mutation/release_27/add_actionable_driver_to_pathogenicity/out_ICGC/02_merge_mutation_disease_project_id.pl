#将./output/01_all_driver_action_out_ICGC.txt和./output/01_unique_disease_map_ICGC.txt和/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt
#merge起来，得到mutation_disease_cancer_project三者信息的集合体文件：./output/02_mutation_disease_cancer_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/01_all_driver_action_out_ICGC.txt";
my $f2 = "./output/01_unique_disease_map_ICGC.txt";
my $f3 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/02_mutation_disease_cancer_project.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "final_variant\thgvsg\tdisease\tcancer_id\tproject";
print $O1 "$header\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        my $final_variant = $f[1];
        my $hgvsg = $f[2];
        my $disease = $f[3];
        $disease=~s/-/ /g;
        $disease=~s/_/ /g;
        $disease =lc($disease);
        my $k = "$final_variant\t$hgvsg";
        push @{$hash1{$k}},$disease;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^disease/){
        my $disease = $f[0];
        my $cancer_ID = $f[1];
        $disease=~s/-/ /g;
        $disease=~s/_/ /g;
        $disease =lc($disease);
        my @cs = split/\;/,$cancer_ID;
        foreach my $c (@cs){
            push @{$hash2{$disease}},$c;
        }
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^term/){
        my $project = $f[1];
        my $cancer_ID = $f[2];
        $hash3{$cancer_ID}=$project;
    }
}

foreach my $hgvsg (sort keys %hash1){
    my @diseases = @{$hash1{$hgvsg}};
    foreach my $disease(@diseases){
        if (exists $hash2{$disease}){
            # print "$disease\n";
            my @ids = @{$hash2{$disease}};
            foreach my $id (@ids){
                # print "$id\n";
                if (exists $hash3{$id}){
                     
                    my $project =$hash3{$id};
                    my $output = "$hgvsg\t$disease\t$id\t$project";
                    unless(exists $hash4{$output}){
                        $hash4{$output} =1;
                        print $O1 "$output\n";
                    }
                }
                else{
                    # print "$id\n";
                }
            }
        }
        else{
            # print "$disease\n";
        }
    }
}
