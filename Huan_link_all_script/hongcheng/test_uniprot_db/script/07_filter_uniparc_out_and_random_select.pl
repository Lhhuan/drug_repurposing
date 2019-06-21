#将../output/02_filter_in_uniparc.txt中的ID 从"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz" 中提取出来，并随机提取一倍其他id对应的文件，得../output/06_used_to_build_db_uniparc.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/02_filter_in_uniparc.txt";
my $f2 ="/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz";
my $fo1 ="../output/07_random_select_uniparc.txt"; 
# my $f1 ="./test.txt";
# my $f2 ="123.txt.gz";
# my $fo1 ="./12345_test.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my(%hash1,%hash2,%hash3);


while(<$I1>)
{
    chomp;
    $hash1{$_}=1;    
}



my @ids;
# my $old_id= 1;
while(<$I2>)
{
    chomp;
    if (/^\>/){
        my @f =split/\s+/;
        my $protein = $f[0];
        $protein =~s/>UNIPARC://g;
        unless (exists $hash1{$protein}){
           push @ids, $protein;
        }
    }
}

my @new = randomElem ( 160000, @ids ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
my $output = join("\n", @new);
print $O1 "$output\n";
# foreach my $v(@new){
#     chomp($v);
#     print $O1 "$v\n";
# }

sub randomElem { #随机取
    my ($want, @array) = @_ ;
    my (%seen, @ret);
    while ( @ret != $want ) {
        my $num = abs(int(rand(@array))); #@array 是指数组的长度，而$#array是指最后一个索引，由于rand的特殊性，如果用$#array会导致取不到最后一个值。
        if ( ! $seen{$num} ) { 
            ++$seen{$num};
            push @ret, $array[$num];
        }
    }
    return @ret;     
}