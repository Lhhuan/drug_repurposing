#把06_out_5000gene_varint_info_vep.vcf可以map到gene的文件筛选得临近基因法的第一个层面文件07_varint_gene_in_level3_3.vcf，得临近基因法的第二个层面文件07_varint_gene_in_level3_4.vcf,得没有map到protein coding 的mutation文件07_varint_out_gene_in_level3_5.vcf #
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./06_out_5000gene_varint_info_vep.vcf";
my $f2 = "./protein_coding_gene.txt";
my $fo1 = "./061_varint_gene_in_level3_3.vcf";
my $fo2 = "./061_varint_gene_in_level3_4.vcf";
my $fo3 = "./061_varint_out_gene_in_level3_5.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
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

my %hash5;
while(<$I2>) 
{
    chomp;
    unless (/^Gene/){   #这里所有的gene 为protein coding 
        my @f= split/\t/;
        my $gene = $f[0];
        my $type = $f[1];
        $hash5{$gene}=$type;
    }
}



my %hash6;
my %hash7;

foreach my $variation_id(sort keys %hash2){  #寻找离得最近的基因。
    unless(exists $hash1{$variation_id}){  #去重#判断variant没有在上面level3.3出现过。
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
                        #print STDERR "$NEAREST\n";
                        if(exists $hash5{$NEAREST}){   #判断最近基因是protein_coding基因
                            $hash6{$variation_id}=1;
                        my $output = join("\t",@f[0..2],$NEAREST,@f[4..13]);
                        print $O2 "$output\tlevel3.2\n";
                        }
                        else{
                            unless(exists $hash6{$variation_id}){  #判断variant没有在上面level3.4出现过。
                                unless(exists $hash7{$variation_id}){
                                    $hash7{$variation_id} =1;
                                    print $O3 "$variation_id\n";
                                }
                            }
                            
                        }
                    }
                }
            }
        }
       
    }
}


