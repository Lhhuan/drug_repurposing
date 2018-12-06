#用"/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt"为028_the_shortest_path.txt里面的路径寻找start和end的逻辑关系,得029_start_end_logical.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/network/the_shortest_path/normal_network_num.txt";
my $f2 ="./028_the_shortest_path.txt";
my $fo1 ="./029_the_shortest_path_edge.txt"; #中间文件#这里是把每个start和end的最短路径的边存下来
my $fo2 ="./029_start_end_logical.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "start\tend\tthe_shortest_edge\n"; 
select $O2;
print "start\tend\tlogic_direction\n";
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
     unless(/^start/){
         my $start=$f[0];
         my $end = $f[1];
         my $the_shortest_path = $f[2];
         my @paths = split/-/,$the_shortest_path;
         my $path_node_count = @paths;
         my $path_length = $path_node_count-1;
        if ($path_length>1 && $path_length <3.606){ #如果最短路径只有一个元素，说明没有最短路径，故此最短路径不保存下来,如果路径长度大于网络中平均最短路径长度，则说明这个路径太长了没有意义，所以只把路径长度大于1且小于平均路径3.606的最短路径留下来
             my $max_node =$path_node_count-1;
            for (my $i=0;$i<$path_node_count;$i++){
                if ($i<$max_node){
                    my $edge = "$paths[$i]-$paths[$i+1]";#这里是把每个start和end的最短路径的边存下来
                    print $O1 "$start\t$end\t$edge\n";
                }
            }
         }
     }
}

close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";

my $f3 ="./029_the_shortest_path_edge.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^start/){
         my $start = $f[0];
         my $end = $f[1];
         my $k = "$start\t$end";
         my $edge = $f[2];
         push @{$hash2{$k}},$edge;
     }
}

my (@countin,@counta,@count_);
foreach my $start_end (sort keys %hash2){
    my @countin = ();
    my @counta = ();
    my @count_ = ();
     my @part_edges =@{$hash2{$start_end}};
    foreach my $part_edge(@part_edges){
        if(exists $hash1{$part_edge}){
            my $direction = $hash1{$part_edge};
            my $part_edge_direction = $direction;
            if($part_edge_direction =~/in/){
                push @countin,$part_edge_direction; #对方向是in的进行计数。
            }
            elsif($part_edge_direction =~/a/){
                push @counta,$part_edge_direction;#对方向是a的进行计数。
            }
             else{
                push @count_,$part_edge_direction;#对方向是-的进行计数。

            }
        }
    }
    my $count_in = @countin;
    my $count_a = @counta;
    my $count__= @count_;
    my $in = $count_in % 2;
    my $act = $count_a  % 2;
    if($count_in==0 && $count_a==0){   #当-|和->都为0，即全部为—时，start对end没有任何激动和抑制作用
        print $O2 "$start_end\t-\n";
    }
    elsif($in>0){
        print $O2 "$start_end\tin\n"; #当-|为奇数时，无论->个数为多少，start对end都是抑制作用
    }
    else{
        print $O2 "$start_end\ta\n"; #当-|为偶数时，无论->个数为多少，start对end都是激动作用
    }
}

            
            