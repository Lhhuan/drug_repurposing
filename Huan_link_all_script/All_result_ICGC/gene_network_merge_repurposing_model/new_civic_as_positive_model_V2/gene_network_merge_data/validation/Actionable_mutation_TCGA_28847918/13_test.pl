 #把区分./output/12_merge_civic_and_mtctscan_other_database.txt里面的突变类型是否可以用transvar 转换,得./output/13_transvar_ref_alt.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/12_merge_civic_and_mtctscan_other_database.txt";
my $fo1 ="./output/13_transvar_ref_alt.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $output ="oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt";
$output = "$output\tentrez_id\tdrug_interaction_type\tstd_mutation_super_class\tsource\tfinal_variant\thgvsg\thgvsg_source";
print  $O1 "$output\n";


my (%hash1,%hash2,%hash3,%hash4);
# my $hgvsg = ${chr}:g.${pos}${ref}>${alt};

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
        my $source = $f[-1];
        my $gene = $f[7];
        my $variant = $f[8];
        my $final_variant = "${gene}:p.${variant}";
        my $chr = $f[11];
        my $start = $f[12];
        my $end = $f[13];
        my $pos = $start;
        my $ref = $f[14];
        my $length_ref = length($ref);
        my $alt= $f[15];
        my $length_alt = length($alt);
        my $std_mutation_super_class = $f[-2];
        if ($source =~/Civic/){ 
            if ($start eq $end ){#civic 中 start == end时,
                if ($ref =~/NULL/ && $alt =~/NULL/){ #ref 和alt 都是NULL 时用 填写na
                    print $O1 "$_\tNA\tNA\tCivic\n";
                }
                else{ #ref 或 alt 不是NULL时，用transvar
                    my $hgvsg = transvar_results ($final_variant);
                    print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";
                }
            }
            else{
                if ($ref =~/NULL/ && $alt =~/NULL/){ #ref 和alt 都是NULL 时用 填写na
                    print $O1 "$_\tNA\tNA\tCivic\n";
                }
                else{ #ref 或 alt 不是NULL时，用transvar
                    my $hgvsg = transvar_results ($final_variant);
                    print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";
                }    
            }
        }
    }
}


sub transvar_results {  #transvar 处理
    my ($variant) =@_;
    # print STDERR "$variant\n";
    my $transvar_results = readpipe ("transvar panno -i $variant --ensembl | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
    my @v = split/\s+/,$transvar_results;
    my $number = @v;
    if ($number>1){
        my $hgvss = $v[1];
        my @h = split/\//,$hgvss;
        my $hgvsg = $h[0];
        return $hgvsg;       
    }
    else{
        my $hgvsg = "NA";
        return $hgvsg; 
    }
}




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



# 4:g.1803564C>T

# close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

#  my $transvar_results = readpipe ("transvar panno -i $final_variant --ensembl | cut -f1,5");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
#                         print $O3 "$transvar_results";


# BRAF:p.V600D

# transvar panno -i NPM1:p.W288FS --ensembl

# BRAF	V600D
