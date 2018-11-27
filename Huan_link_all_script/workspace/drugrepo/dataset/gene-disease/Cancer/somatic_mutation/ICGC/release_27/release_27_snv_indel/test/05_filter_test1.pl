#把04_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件05_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面文件05_varint_gene_in_level3_2.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./04_out_gene_varint_enhancer_target_info_vep.vcf";
my $fo1 = "./05_varint_gene_in_level3_1.vcf";
my $fo2 = "./05_varint_gene_in_level3_2.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    if (/^#/){
        if (/^#Uploaded_variation/){
            print $O1 "$_\tMap_to_gene_level\n";
            print $O2 "$_\tMap_to_gene_level\n";
        }
        else{
            print $O1 "$_\n";
            print $O2 "$_\n";
        }
    }
     else{
         my @f =split/\s+/;
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my $location = $f[1];
         my $gene = $f[3];
         if ($gene=~/ENSG/){
             print $O1 "$_\tlevel3.1\n";
             $hash1{$variation_id}=1;
         }
         else{
             unless(exists $hash1{$variation_id}){
                # print $O2 "$_\tlevel3.2\n";
                my @f1 = split/\;/,$Extra;
                foreach my $i(@f1){
                    if($i=~/^NEAREST/){
                        my @f2 = split/\=/,$i;
                        my $NEAREST_gene = $f2[1];
                        my @NEARESTs = split/\,/,$NEAREST_gene;
                        foreach my $NEAREST(@NEARESTs){
                        my $output = join("\t",@f[0..2],$NEAREST,@f[4..13]);
                        print $O2 "$output\tlevel3.2\n";
                        }
                    }
                }

             }
         }
         
     }
}