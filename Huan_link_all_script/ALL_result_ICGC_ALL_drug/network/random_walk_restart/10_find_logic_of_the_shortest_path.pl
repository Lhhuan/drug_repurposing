#用"/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt"为./output/09_the_shortest_path.txt里面的路径寻找start和end的逻辑关系,
#并利用./output/network_gene_num_symbol.txt获取基因的symbol信息,得./output/10_start_end_path_logical.txt
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt";
my $f2 ="./output/network_gene_num_symbol.txt";
my $f3 ="./output/09_the_shortest_path.txt";
my $fo1 ="./output/10_start_end_path_logical.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "start_tend\tpath_logic_direction\tsymbol_path_logic_direction\n";
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^start/){
        my $start = $f[0];
        my $end = $f[1];
        my $edge = "$start-$end";
        my $direction = $f[3];
        $hash1{$edge}=$direction;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^gene_symbol/){
        my $id = $f[2];
        my $final_symbol = $f[3];
        $hash2{$id}=$final_symbol;
    }
}

while(<$I3>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^start/){
         my $start=$f[0];
         my $end = $f[1];
         my $the_shortest_path = $f[2];
         my @paths = split/-/,$the_shortest_path;
         my $path_node_count = @paths;
         my $path_length = $path_node_count-1;
        if ($path_length>0 && $path_length <3.606){ #如果最短路径只有一个元素，说明没有最短路径，故此最短路径不保存下来,如果路径长度大于网络中平均最短路径长度，则说明这个路径太长了没有意义，所以只把路径长度大于0且小于平均路径3.606的最短路径留下来
             my $max_node =$path_node_count-1;
            my @path_logic;
            my @path_logic_symbol;
            for (my $i=0;$i<$path_node_count;$i++){
                if ($i<$max_node){
                    my $edge = "$paths[$i]-$paths[$i+1]";#这里是把每个start和end的最短路径的边存下来
                    if (exists $hash1{$edge}){
                        my $direction = $hash1{$edge};
                        my $output_path = "$paths[$i]\,$direction\,$paths[$i+1]";
                        push @path_logic, $output_path;
                        if (exists $hash2{$paths[$i]}){
                            if (exists $hash2{$paths[$i+1]}){
                                my $start_node = $hash2{$paths[$i]};
                                my $end_node = $hash2{$paths[$i+1]};
                                my $output_path_symbol = "$start_node\,$direction\,$end_node";
                                push @path_logic_symbol,$output_path_symbol;
                            }
                        }
                    }
                    # print $O1 "$start\t$end\t$edge\t$path_length\n";
                }
            }
            my $path_logic_final = join(";",@path_logic);
            my $path_logic_symbol_final = join(";",@path_logic_symbol);
            my $output = "${start}_${end}\t$path_logic_final\t$path_logic_symbol_final";
            print $O1 "$output\n";
        }
    }
}

close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";

