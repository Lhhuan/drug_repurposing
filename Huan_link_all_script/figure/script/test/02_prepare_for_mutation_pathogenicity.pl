#计算画图需要的数据
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../output_data/all_mutation_Pathogenicity.txt";
my $fo1 = "../output_data/final_all_mutation_Pathogenicity_to_plot.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my %hash1;
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Mutation_ID/){
        my @f =split/\t/;
        my $Mutation_ID=$f[0];
        my $Pathogenicity_score = $f[1];
        my $source = $f[2];
        my $v = "$Mutation_ID\t$Pathogenicity_score";
        push @{$hash1{$source}},$v;
    }
}

foreach my $k(sort keys %hash1){
    my %hash2;
    my @arrar_small_than15;
    my @arrar_large_than;
    my @vs = @{$hash1{$k}};
    my $vs_number = @vs; #每种突变类型的数目
    foreach my $v(@vs){
        my @f =split/\t/,$v;
        my $Mutation_ID=$f[0];
        my $Pathogenicity_score = $f[1];
        if ($Pathogenicity_score<15){
            push @arrar_small_than15,$Mutation_ID; 
        }
        elsif($Pathogenicity_score>=15 && $Pathogenicity_score<=50){
            push @{$hash2{$Pathogenicity_score}},$Mutation_ID;
        }
        else{
            push @arrar_large_than,$Mutation_ID; 
        }
    }
    foreach my $p_score(sort keys %hash2){
        my @Vps =@{$hash2{$p_score}};
        my $number = @Vps;
        my $ratio = $number/$vs_number *100;
        my $output = "$p_score\t$ratio\t$k";
        print $O1 "$output\n";
    }
    my $n_small =  @arrar_small_than15;
    my $n_samll_r = $n_small/$vs_number *100;
    print $O1 "<15\t$n_samll_r\t$k\n";
    my $n_large = @arrar_large_than;
    my $n_large_r = $n_large/$vs_number *100;
    print $O1 ">50\t$n_large_r\t$k\n";

}



# foreach my $k(sort keys %hash1){
#     my @vs = @{$hash1{$k}};
#     my $number = @vs;
#     foreach my $v(@vs){
#         my @f =split/\t/,$v;
#         my $Mutation_ID=$f[0];
#         my $Pathogenicity_score = $f[1];
#         my @array = (0,15,16,17,18,19,20);
#         my $length_array = @array;
#         for (my $i=0;$i < $length_array-1;$i++){
#             if ($Pathogenicity_score>=$array[$i] && $Pathogenicity_score <$array[$i+1]){
#                 my $path_region = "$array[$i]_$array[$i+1]";
#                 print "$path_region\n";
#                 # my $output = "$Mutation_ID\t$Pathogenicity_score\t$array[i]"
#             }
#         }

#     }
# }