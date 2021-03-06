#把08_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件09_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面文件09_varint_gene_in_level3_2.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./08_out_gene_varint_enhancer_target_info_vep.vcf";
my $fo1 = "./09_varint_gene_in_level3_1.vcf";
my $fo2 = "./09_varint_gene_in_level3_2.vcf";
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
             my @f1 = split/\;/,$Extra;
            foreach my $i(@f1){
                if ($i =~/BIOTYPE/){
                    my @f3 = split/\=/,$i;
                    if ($f3[1]=~/protein_coding/){
                        $hash1{$variation_id}=1;  #只要variant 的一个注释落在protein coding，就算这个variant 所对应的gene是该protein coding的基因level3.1，而不再进入其他variant map 到gene的规则，所以此处为去重做准备
                        print $O1 "$_\tlevel3.1\n";
                    }
                    else{  #variant 不在protein coding
                     push @{$hash2{$variation_id}},$_;   
                     }
                }
            }
        }
        else{
            push @{$hash2{$variation_id}},$_; #没有ensg存在
        }
     }
}


foreach my $variation_id(sort keys %hash2){  #寻找离得最近的基因。
    unless(exists $hash1{$variation_id}){  #去重
        my @vs =@{$hash2{$variation_id}};
        foreach my $v(@vs){
             my @f= split/\t/,$v;
             my $Extra = $f[13];
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


