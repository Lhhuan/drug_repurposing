#0291_merge_drug_target_rwr_end_logic.txt利用"/f/mulinlab/huan/All_result_ICGC/brief_drug_target_info.txt"和"/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_all_sorted_drug_target_repo_symbol_entrez_num.txt"
#获取drug targetscore，利用028_the_shortest_path.txt获取最短路径中的长度。，得0292_acquire_drug_target_score_and_edge_length.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="/f/mulinlab/huan/All_result_ICGC/brief_drug_target_info.txt";
my $f2 ="/f/mulinlab/huan/All_result_ICGC/network/rwr_parameter_optimization/new_repo_disgenet/10_all_sorted_drug_target_repo_symbol_entrez_num.txt";
my $fo1 ="./0292_drug_target_score_network_id.txt"; #中间输出文件，记录drug target score及drug target 在网络中的编号。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "Entrez_id\tDrug_claim_primary_name\tDrug_type\tdrug_target_score\tdrug_entrez_network_id\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Entrez_id/){
         my $Entrez_id = $f[0];
         my $Drug_claim_primary_name = $f[1];
         my $Drug_type = $f[2];
         my $drug_target_score = $f[3];
         my $v= "$Drug_claim_primary_name\t$Drug_type\t$drug_target_score";
         push @{$hash1{$Entrez_id}},$v;
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
         my $drug_entrez=$f[2];
         my $drug_entrez_network_id = $f[3];
        $hash2{$drug_entrez}=$drug_entrez_network_id;
     }
}

foreach my $Entrez_id(sort keys %hash1){
    my @vs = @{$hash1{$Entrez_id}};
    if(exists $hash2{$Entrez_id}){
        my $drug_entrez_network_id = $hash2{$Entrez_id};
        foreach my $v(@vs){
            my $output1 = "$Entrez_id\t$v\t$drug_entrez_network_id";
            unless(exists $hash3{$output1}){
                $hash3{$output1}=1 ;
                print $O1 "$output1\n";
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 ="./0292_drug_target_score_network_id.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $f4 ="./0291_merge_drug_target_rwr_end_logic.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
my $fo2="./0292_drug_target_score_network_id_path.txt"; #中间输出文件，记录drug target score及drug target 在网络中的编号。
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "drug\tstart\tDrug_type\tdrug_target_score\tend\tshortest_logic_direction\n";
while(<$I3>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^Entrez_id/){
         my $Entrez_id = $f[0];
         my $Drug_claim_primary_name = $f[1];
         my $Drug_type = $f[2];
         my $drug_target_score = $f[3];
         my $drug_entrez_network_id = $f[4];
         my $k = "$Drug_claim_primary_name\t$drug_entrez_network_id";
         my $v = "$Drug_type\t$drug_target_score";
         $hash4{$k}=$v;
     }
}

while(<$I4>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $start = $f[1];
         my $end = $f[2];
         my $shortest_logic_direction = $f[3];
         my $k = "$drug\t$start";
         my $v = "$end\t$shortest_logic_direction";
        push @{$hash5{$k}},$v;
     }
}

foreach my $k(sort keys %hash4){
    my $score_info =$hash4{$k}; #$score_info= "$Drug_type\t$drug_target_score";
    if (exists $hash5{$k}){
       my @path_infos = @{$hash5{$k}}; #@path_infos = "$end\t$shortest_logic_direction";
       foreach my $path_info(@path_infos){
           my $output2 = "$k\t$score_info\t$path_info";
           unless(exists $hash6{$output2}){
               $hash6{$output2} =1;
               print $O2 "$output2\n";
           }
       }
    }
}

close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄



my $f5 ="./0292_drug_target_score_network_id_path.txt"; #是此脚本上面产生的文件
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
my $f6 ="./028_the_shortest_path.txt";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
my $fo3="./0292_acquire_drug_target_score_and_edge_length.txt"; #
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
print $O3 "drug\tstart_drug_target\tDrug_type\tdrug_target_score\tend\tshortest_logic_direction\tshortest_path_length\n";

while(<$I5>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $start = $f[1];
         my $end = $f[4];
         my $k = "$start\t$end";
        push @{$hash7{$k}},$_;
     }
}

while(<$I6>) 
{
    chomp;
    my @f= split /\t/;
     unless(/^start/){
         my $start=$f[0];
         my $end = $f[1];
         my $k = "$start\t$end";
         my $the_shortest_path = $f[2];
         my @paths = split/-/,$the_shortest_path;
         my $path_node_count = @paths;
         my $path_length = $path_node_count-1;
        if ($path_length>1 && $path_length <3.606){ #如果最短路径只有一个元素，说明没有最短路径，故此最短路径不保存下来,如果路径长度大于网络中平均最短路径长度，则说明这个路径太长了没有意义，所以只把路径长度大于1且小于平均路径3.606的最短路径留下来
             $hash8{$k}=$path_length;
         }
     }
}

foreach my $k (sort keys %hash7){  #my $k = "$start\t$end";
    my @drug_infos= @{$hash7{$k}};
    if(exists $hash8{$k} ){
        my $path_length=$hash8{$k};
        foreach my $drug_info(@drug_infos){
            my $output3 = "$drug_info\t$path_length";
            unless(exists $hash9{$output3}){
               $hash9{$output3} =1;
               print $O3 "$output3\n";
           }
        }
    }
}