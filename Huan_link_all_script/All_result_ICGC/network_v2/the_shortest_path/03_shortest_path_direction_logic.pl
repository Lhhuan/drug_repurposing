#为the_shortest_path.txt找出节点之间的逻辑，找出start和end是还是抑制关系。得文件start_end_logical.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./normal_network_num.txt";
my $f2 ="./the_shortest_path.txt";
my $fo1 ="./the_shortest_path_edge.txt"; #中间文件#这里是把每个start和end的最短路径的边存下来
my $fo2 ="./start_end_logical.txt"; 
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
         if ($path_node_count==1){ #如果最短路径只有一个元素，说明没有最短路径，所以输出NA;
             print $O2 "$start\t$end\tNA";
         }
         else{
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

my $f3 ="./the_shortest_path.txt";
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
    foreach my $edge(sort keys %hash1){
        my @part_edges =@{$hash2{$start_end}};
        foreach my $part_edge(@part_edges){
            my $direction = $hash1{$edge};
            if ($part_edge =~/$edge/){#如果两个边相等
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
    }
    my $count_in = @countin;
    my $count_a = @counta;
    my $count__= @count_;
    if ($count_in==0){
        if ($count_a==0){ #如果只有方向是-，start和end之间没有逻辑性。
            print $O2 "$start_end\t-\n";
        }
        else{
            print $O2 "$start_end\ta\n";
        }
    }
    else{
        my $a = $count_in % 2;
        if ($a==0){
                print $O2 "$start_end\ta\n";
            }
        else{
                print $O2 "$start_end\tin\n";
        }
    }
}

            
            