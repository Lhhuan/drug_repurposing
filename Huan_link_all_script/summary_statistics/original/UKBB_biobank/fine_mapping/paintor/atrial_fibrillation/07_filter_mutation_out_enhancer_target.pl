#把在05_mutation_out_protein_coding_map_gene.vcf中存在，但是在06_connect_out_gene_varint_enhancer_target.bed中不存在的突变过滤出来，得文件07_mutation_out_enhancer_target.txt, 
#同时把06_connect_out_gene_varint_enhancer_target.bed输出成元vcf文件，只是在其后面追加gene的信息，得文件07_mutation_in_enhancer_target_level2.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./05_mutation_out_protein_coding_map_gene.vcf";
my $f2 = "./06_connect_out_gene_varint_enhancer_target.bed";
my $fo1 = "./07_mutation_in_enhancer_target_level2.vcf";
my $fo2 = "./07_mutation_out_enhancer_target.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    if (/^#/){
        #print $O2 "$_\n";
        if (/^#Uploaded_variation/){
            print $O1 "$_\tsource_level\tgene_score\tgene_source\n";
        }
    }
     else{
         my @f =split/\s+/;
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my $location = $f[1];
         push @{$hash1{$variation_id}},$_;
     }
}


while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    my $mutation_id =$f[10];
    my $new_gene = $f[4];
    my $gene_score = $f[5];
    my $gene_source =$f[6];
    $hash2{$mutation_id}=1;
    my $output = join("\t",@f[10..12],$new_gene,@f[14..23],"level2_enhancer_target",$gene_score,$gene_source);
    unless(exists $hash3{$output}){
        $hash3{$output}=1;
        print $O1 "$output\n";
    }
}

foreach my $k (sort keys %hash1){
    unless(exists $hash2{$k}){
        unless(exists $hash4{$k}){
            $hash4{$k}=1;
            print $O2 "$k\n";
        }
    }
}
