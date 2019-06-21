#将./output/01_merge_out_icgc_info_and_position.txt和./output/02_unique_cgi_out_icgc_cancer_map_ICGC.txt和/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt
#merge起来，得到mutation_disease_cancer_project三者信息的集合体文件：./output/03_mutation_disease_cancer_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./output/01_merge_out_icgc_info_and_position.txt";
my $f2 = "./output/02_unique_cgi_out_icgc_cancer_map_ICGC.txt";
my $f3 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "./output/03_mutation_disease_cancer_project.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);
my $header = "gdna\tCHROM\tPOS\tREF\tALT\tgene\tprotein\tcancer_acronym\tcancer_id\tproject";
print $O1 "$header\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^variant_id/){
        my $CHROM = $f[0];
        my $POS =$f[1];
        my $REF = $f[2];
        my $ALT = $f[3];
        my $gene = $f[4];
        my $gdna = $f[5];
        $gdna =~ s/chr//g;
        my $protein =$f[6];
        my $transcript = $f[7];
        my $cancer_acronym= $f[10];
        my $v = "$CHROM\t$POS\t$REF\t$ALT\t$gene\t$protein\t$cancer_acronym";
       
        push @{$hash1{$gdna}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^disease/){
        my $disease = $f[0];
        my $cancer_ID = $f[2];
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
    my @vs = @{$hash1{$hgvsg}};
    foreach my $v(@vs){
        my @d= split/\t/,$v;
        my $disease =$d[-1];
        if (exists $hash2{$disease}){
            # print "$disease\n";
            my @ids = @{$hash2{$disease}};
            foreach my $id (@ids){
                # print "$id\n";
                if (exists $hash3{$id}){
                     
                    my $project =$hash3{$id};
                    my $output = "$hgvsg\t$v\t$id\t$project";
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
