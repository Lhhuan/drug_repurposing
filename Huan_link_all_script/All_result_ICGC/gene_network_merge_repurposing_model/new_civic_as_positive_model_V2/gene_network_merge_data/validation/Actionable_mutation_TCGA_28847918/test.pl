#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


#my $variant = "ALK:p.F1174L";

my $variant = "ERBB2:p.DEL 755-759";



my $hgvsg = transvar_results ($variant);
#print  "$hgvsg\n";

sub transvar_results {
    my ($final_variant) =@_;
    print STDERR "$final_variant\n";
    my $transvar_results = readpipe ("transvar panno -i $final_variant --ensembl | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
    my @v = split/\s+/,$transvar_results;
    my $hgvss = $v[1];
    my @h = split/\//,$hgvss;
    my $hgvsg = $h[0];
    return $hgvsg; 
}



# my $transvar_results = readpipe ("transvar panno -i $variant --ensembl | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
# my @v = split/\s+/,$transvar_results;
# my $hgvss = $v[1];
# my @h = split/\//,$hgvss;
# my $hgvsg = $h[0];
# print  "$hgvsg\n";


# my @text = <$I2>;#把文件读进数组
# my @new = randomElem ( $line_number, @text ) ; # pick any $num from @array ，把$num和@array传递给子程序。这里是用的值传递。还有一种方式是引用传递，相当于硬链接
#        # my $out = join ("\n",@new);
# foreach my $v(@new){
#     chomp($v);
#     print $O1 "$v\n";
# }

# sub randomElem { #随机取
#     my ($want, @array) = @_ ;
#     my (%seen, @ret);
#     while ( @ret != $want ) {
#         my $num = abs(int(rand(@array))); #@array 是指数组的长度，而$#array是指最后一个索引，由于rand的特殊性，如果用$#array会导致取不到最后一个值。
#         if ( ! $seen{$num} ) { 
#             ++$seen{$num};
#             push @ret, $array[$num];
#         }
#     }
#     return @ret;     
# }
