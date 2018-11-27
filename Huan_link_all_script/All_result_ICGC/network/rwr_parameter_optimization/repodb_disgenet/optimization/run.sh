# Parameter_data为各个参数run出来的r的值
# param_top_probability为每个r取top后，和预期end的交集数据存放文件夹




perl 01_get_end_probability.pl 
#得到../04_test_start_end_num_sorted.txt为start和end的pair
#对每个参数，每个start对应end result进行排序，取$top,得文件$sort_top_file， $top里的结果再与end取交集。所有重合的数据为param_top_probability/01_top_${top_p}_${parameter}_probability.txt
#然后查看param_top_probability/01_top_${top_p}_${parameter}_probability.txt的行数，输出到文件$final_parameter_result.txt里面。

#由E:\桌面\drug repositioning new\drug repositioning\drug repositioning\network\random walk\drugresponse\scripts下的nb_lin.m和huan_rwr_start_end.m run出来的
#以part1和part2分别为50:10:200（以50为开始，每次增加10，一共增加到200），100:100:1000,和50:50:500的rwr的结果，由01_get_end_probability.pl 分析，top分别取0.2,0.3，0.4,0.5发现有一些part1和part2的pair可以hit到给出的../04_test_start_end_num_sorted.txt
#这些pair在文件test_review_pair.txt中列出，其中，100_100出现top的次数最多。所以100_1000出现的次数也还可以。test_review_pair.txt出现的pair 均是100_100以上，用./../review_start_end_num.txt文章中给出的start和end来选出test_review_pair.txt中最合适的part pair。此脚本用01_review_get_end_top_probability.pl来执行。top分别取0.2,0.3，0.4,0.5。
perl 01_review_get_end_top_probability.pl #得结果final_parameter_result_review_sorted.txt 结果显示100_1000 top0.5表现很好，所以最终的参数为k1= 100;k2= 1000;Restart c =0.9;Cutuoff = top0.5；Restart c =0.9是因为李老师的师弟用的0.9，另一原因是用0.9，0.8,0.7,0.6，测试时发现0.9,0.8,0.7是一样的，而0.6则有点异常，所以选0.9



#由final_parameter_result_review_sorted.txt的结果可以看出，前几个表现都很好，结合在数据../04_test_start_end_num_sorted.txt验证时的表现情况，选100_1000作为最终的结果。他在top0.5 情况下可以全部hit到review中的4个数据






cat "/f/mulinlab/huan/All_result/network/original_network_num.txt" | sort -k3,3n > sort_original.txt  #原来的输入文件的weight范围是   0.367879441171442 - 0.5433508690745

#50_50_0.9的 #top 0.2： 都是NA
#80_80_0.9的 #top 0.2： 都是NA
#90_90_0.9的 #top 0.2：
#90_100_0.9的 #top 0.2： 31
#100_80_0.9的 #top 0.2：23
#100_90_0.9的 #top 0.2：
#100_100_0.9的最小值为0.007968 #top 0.2： 15个
#100_100_0.8的最小值为0.007968 #top 0.2： 15个
#100_100_0.7的最小值为0.010739 #top 0.2： 15个
#100_100_0.6的最小值为0.046835 #top 0.2： 35个
#100_200_0.9 #top 0.2： 14个
#200_200_0.9 #top 0.2： 都是NA
#300_300_0.9 #top 0.2： 6
#400_400_0.9 #top 0.2： 都是NA
#500_100_0.9 #top 0.2： 50
#500_500_0.9 #top 0.2： 41个
#1000_1000_0.9 #top 0.2： 37个
#1000_100_0.9 #top 0.2： 20个


#

