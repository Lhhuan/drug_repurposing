#把04_out_gene_varint_enhancer_target_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件05_varint_gene_in_level3_1.vcf，得临近基因法的第二个层面的mutation，05_varint_out_level3_1.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./04_out_gene_varint_enhancer_target_info_vep.vcf";
my $fo1 = "./05_varint_gene_in_level3_1.vcf";
my $fo2 = "./05_varint_out_level3_1.vcf";
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
        }
        else{
            print $O1 "$_\n";
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
                        $hash2{$variation_id}=1;   
                    }
                }
                else{
                    $hash2{$variation_id}=1;#没有biotype
                }
            }
        }
        else{
            $hash2{$variation_id}=1; #没有ensg存在
        }
     }
}



my %hash6;
my %hash7;

foreach my $variation_id(sort keys %hash2){  #寻找离得最近的基因。
    unless(exists $hash1{$variation_id}){  #去重#判断variant没有在上面level3.1出现过。
       print $O2 "$variation_id\n";
    }
}


