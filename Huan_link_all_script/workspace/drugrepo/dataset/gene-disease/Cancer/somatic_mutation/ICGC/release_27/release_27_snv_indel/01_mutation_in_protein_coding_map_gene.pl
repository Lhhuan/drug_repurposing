#为simple_somatic_mutation.largethan0_vep.vcf的mutation寻找对应的gene，此step把出现在protein coding区域的特定 consequence的mutation对应的gene找出来，
#得map 到L1,1的文件01_mutation_in_protein_coding_map_gene_L1.1.vcf，map 到L1,2的文件01_mutation_in_protein_coding_map_gene_tmp_L1.2.vcf（则里面含有即map到L1.1,又map到1.2的数据）
#把01_mutation_in_protein_coding_map_gene_tmp_L1.2.vcf 在L1.1中出现的L1.2数据去掉，得01_mutation_in_protein_coding_map_gene_L1.2.vcf
#cat 01_mutation_in_protein_coding_map_gene_L1.1.vcf 01_mutation_in_protein_coding_map_gene_L1.2.vcf > 01_mutation_in_protein_coding_map_gene.vcf
#没有落在protein区域的是01_mutation_out_protein_coding_map_gene.vcf 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./simple_somatic_mutation.largethan0_vep.vcf";
my $f3 = "./simple_somatic_mutation.largethan0_vep.vcf";
my $fo1 = "./01_mutation_in_protein_coding_map_gene_L1.1.vcf";
my $fo2 = "./01_mutation_in_protein_coding_map_gene_tmp_L1.2.vcf";
my $fo3 = "./01_mutation_out_protein_coding_map_gene.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    if (/^#/){
        print $O3 "$_\n";
        if (/^#Uploaded_variation/){
            print $O1 "$_\tMap_to_gene_level\n";
            print $O2 "$_\tMap_to_gene_level\n";
        }
        else{
            print $O1 "$_\n";
        }
    }
     else{
         my @f =split/\s+/;
         my $consequence = $f[6];
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my @f2 = split/\;/,$Extra;
         my $level1_1 = "transcript_ablation|splice_acceptor_variant|splice_donor_variant|stop_gained|frameshift_variant|stop_lost|start_lost|transcript_amplification|inframe_insertion|inframe_deletion";
         $level1_1 = "$level1_1|missense_variant|protein_altering_variant|splice_region_variant|incomplete_terminal_codon_variant|coding_sequence_variant|mature_miRNA_variant|NMD_transcript_variant";
         my $level1_2 = "start_retained_variant|stop_retained_variant|synonymous_variant|5_prime_UTR_variant|3_prime_UTR_variant|non_coding_transcript_exon_variant|intron_variant|non_coding_transcript_variant";
         foreach my $i(@f2){
             if ($i =~/BIOTYPE/){
                 my @f3 = split/\=/,$i;
                 if ($f3[1]=~/protein_coding/){ #BIOTYPE必须是protein_coding
                     if ($consequence =~/$level1_1/){ #consequence只要有$level1_1中的任意一个出现，都是level1_1
                        # push @{$hash1{$variation_id}},$_;  #进入level1-1的不再进入其他variant map 到gene的规则，所以此处为去重做准备
                        $hash1{$variation_id}=1; 
                        print $O1 "$_\tLevel1_1_protein_coding\n";  
                        # print STDERR "$consequence\n";
                     }
                     else{
                        if ($consequence =~/$level1_2/){
                            # push @{$hash2{$variation_id}},$_;  #进入level1-2的不再进入其他variant map 到gene的规则，所以此处为去重做准备
                            $hash2{$variation_id}=1; 
                            print $O2 "$_\tLevel1_2_protein_coding\n";
                            # print STDERR "$consequence\n";
                        }
                        else{
                            $hash3{$variation_id} =1;
                        }
                     }
                 }
                 else{
                    $hash3{$variation_id} =1;
                 }
             }
             else{
                $hash3{$variation_id} =1;
             }
         }
     }
}

while(<$I3>)
{
    chomp;
    unless (/^#/){
        my @f =split/\s+/;
        my $consequence = $f[6];
        my $Extra = $f[13];
        my $variation_id = $f[0];
        # print "$variation_id\n";
        unless(exists $hash1{$variation_id}){  #只要variant 的一个注释落在protein coding，就算这个variant 所多对应的gene是该protein coding的基因，而不再进入其他variant map 到gene的规则，所以此处为去重。
            unless (exists $hash2{$variation_id}){
                print $O3 "$_\n";
            }
        }
    }
}
    


close ($O2);


my $f2 = "./01_mutation_in_protein_coding_map_gene_tmp_L1.2.vcf";
my $fo4 = "./01_mutation_in_protein_coding_map_gene_L1.2.vcf";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";


#---------------------------------------------------# 把在L1.1中出现的L1.2数据去掉
while(<$I2>)
{
    chomp;
    if (/^#/){
        print $O4 "$_\n";
    }
    else{
        my @f =split/\s+/;
        my $consequence = $f[6];
        my $Extra = $f[13];
        my $variation_id = $f[0];
        unless(exists $hash1{$variation_id}){ #不在L1.1中存在
            print $O4 "$_\n";
        }
    }
}
close ($O1);
close ($O4);
system "cat 01_mutation_in_protein_coding_map_gene_L1.1.vcf 01_mutation_in_protein_coding_map_gene_L1.2.vcf > 01_mutation_in_protein_coding_map_gene.vcf";