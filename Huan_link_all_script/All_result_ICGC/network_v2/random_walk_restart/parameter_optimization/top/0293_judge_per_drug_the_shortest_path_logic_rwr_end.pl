#用0292_acquire_drug_target_score_and_edge_length.txt判断每个药物对于rwr的end的最短路径的逻辑关系。得0293_judge_per_drug_the_shortest_path_logic_rwr_end.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="0292_acquire_drug_target_score_and_edge_length.txt";
my $fo1 ="./0293_judge_per_drug_the_shortest_path_logic_rwr_end.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "drug\tstart\tend\tlogic_direction\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $start = $f[1];
         my $Drug_type = $f[2];
         my $drug_target_score = $f[3];
         my $end = $f[4];
         my $shortest_logic_direction = $f[5];
         my $shortest_path_length = $f[6];
         my $target_info = "$start\t$drug_target_score";
         push @{$hash1{$drug}},$target_info;
         push @{$hash2{$drug}},$end;
         my $start_end = "$start\t$end";
         my $path_info = "$shortest_logic_direction\t$shortest_path_length";
         $hash3{$start_end}=$path_info;
     }
}

foreach my $drug(sort keys %hash1){
    my @target_infos = @{$hash1{$drug}};
    my @ends= @{$hash2{$drug}};
    my %hash7;
    @target_infos = grep { ++$hash7{$_} < 2 } @target_infos;  #对数组内元素去重
    my %hash8;
    @ends = grep { ++$hash8{$_} < 2 } @ends;  #对数组内元素去重
    foreach my $target_info(@target_infos){
        my @f =split/\t/,$target_info;
        my $start =$f[0];
        my $drug_target_score = $f[1];
        # print STDERR "$drug\t$start\t$drug_target_score\n";
        foreach my $end(@ends){
            foreach my $start_end(sort keys %hash3){
                my $path_info = $hash3{$start_end};
                my @f2=split/\t/,$path_info;
                my $shortest_logic_direction = $f2[0];
                my $shortest_path_length = $f2[1];
                my $start_end1 = "$start\t$end";
                if($start_end1 eq $start_end){
                    #print STDERR "$drug\t$start\t$drug_target_score\t$end\t$start_end\t$shortest_logic_direction\n";
                    
                    my @ac;
                    my @in;
                    # if($shortest_logic_direction=~/in/){
                    #     print STDERR "$drug\t$start\t$drug_target_score\t$end\t$start_end\t$shortest_logic_direction\n";
                    # }
                   
                    if($shortest_logic_direction=~/a/){
                        my $Acscore =0;
                        my $Ascore = 1/$drug_target_score*$shortest_path_length;
                        $Acscore = $Acscore + $Ascore; 
                        push @ac,$Acscore;
                    }
                    elsif($shortest_logic_direction=~/in/){
                        my $Inscore =0 ;
                        my $Iscore = 1/$drug_target_score*$shortest_path_length;
                        $Inscore =$Inscore +$Iscore;
                        push @in,$Inscore;
                    }
                    my $ac_length = @ac;
                    my $in_length = @in;
                    if ($ac_length>0 && $in_length >0){
                        #my $acn = $ac[0];
                        my $inn = $in[0];
                      #  print STDERR "$inn\n";
                        # if ($acn gt $inn){
                        #     my $output = "$drug\t$start\t$end\ta";
                        #     unless($hash4{$output}){
                        #         $hash4{$output} =1;
                        #         print $O1 "$output\n";
                        #     }
                        # }
                        # elsif($inn gt $acn){
                        #     my $output = "$drug\t$start\t$end\tin";
                        #     unless($hash4{$output}){
                        #         $hash4{$output} =1;
                        #         print $O1 "$output\n";
                        #     }
                        # }
                        @ac=();
                        @in=();
                    }
                }
            }
        }
    }
}
