cp "/f/mulinlab/huan/All_result/normal_network.txt" normal_network.txt
# cat normal_network_num.txt| perl -ane 'chomp;@f= split/\t/;print "$f[0],$f[1],$f[2]\t";' > normal_network_num_input.txt
perl 01_map_normal_netowrk_num.pl #为normal寻找在网络中的特定基因所对应的编号。得文件normal_network_num.txt
Rscript 02_the_shortest_path.R #为test_start_end.txt在normal_network_num.txt找到最短路径,得文件the_shortest_path.txt
perl 03_shortest_path_direction_logic.pl #为the_shortest_path.txt找出节点之间的逻辑，找出start和end是还是抑制关系。得文件start_end_logical.txt


cat normal_network_num.txt| perl -ane 'chomp;@f= split/\t/;print "$f[0],$f[1],$f[2],\t";' > normal_network_num_input.txt