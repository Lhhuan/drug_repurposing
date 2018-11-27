#把start_drug_target_network_num.txt生成作为RMR start 的文件 drug_target_start.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./start_drug_target_network_num.txt";
my $fo1 ="./drug_target_start.txt"; #
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
#print "$title\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);



for(my $i=1; $i<12278; $i++){
    $hash1{$i}=1;
   # print STDERR "$i\n";
}
while(<$I1>)
{
    chomp;
    $hash2{$_} = 1;
    #print "$_\n";
}
for my $k(sort keys %hash1){
    if (exists $hash2{$k}){
        print "$k\n";
    }
    # else{
    #     print "$k\t0\n";
    # }

}

# while(<$I2>)
# {
#     chomp;
#     my @f= split /\t/;
#      unless(/^gene/){
#          my $gene = $f[0];
#          $gene = uc($gene);
#          my $id = $f[1];
#          $hash2{$gene} = $id;
#      }
# }

#对第一列基因进行id的转换
# foreach my $ID (sort keys %hash1){
#     if (exists $hash2{$ID}){
#         my $s = $hash2{$ID};
#         #print $O1 "$ID\t$s\n";
#         print $O1 "$s\n";
#     } 
#     else{
#         print $O2 "$ID\n";
#     }

# }




