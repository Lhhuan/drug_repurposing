#将文件normal_network_num.txt的前后节点交换后去重输出为metis可以用的格式做准备。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./w2.txt";
my $fo1 ="./w2_metis.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
# print "id1\tid2\tweight\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

my @group;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $gene1 = $f[0];
    my $gene2 = $f[1];
    my $weight = $f[2];
    unless($weight == -1){
        $weight = sprintf "%.4f",$weight;
        $weight = $weight *10000; #为了后面分割文件，weight是positive,所以将$weight *10000得到所以的$weight都是整数。
       
        my $k1 = "$gene1\t$gene2\t$weight";
        #my $k2 = "$gene2\t$gene1\t$weight"; #因为这里的输入数据进行过标准化，形成了12277*12277的矩阵，所以这里不需要对节点进行颠倒输出
        unless(exists $hash1{$k1}){
            push @group,$k1;
            $hash1{$k1}=1;
        }
        # unless(exists $hash1{$k2}){ #因为这里的输入数据进行过标准化，形成了12277*12277的矩阵，所以这里不需要对节点进行颠倒输出
        #     push @group,$k2;
        #     $hash1{$k2}=1;
        # }
    }


}

for my $g(@group){
    my @f= split/\t/,$g;
    my $gene1 = $f[0];
    my $gene2 = $f[1];
    my $weight = $f[2];
    my $v= "$gene2\t$weight";
    push @{$hash2{$gene1}},$v;
}

for my $k( sort keys %hash2){
    my @v = @{$hash2{$k}};
    print $O1 "$k\t";
    for my $v(@v){
        print $O1 "$v\t"; #metis的输入格式为node右图是有权图，第一行表示顶点个数和边的条数，以及format格式为带权重图。第 i 行表示 i-1 节点连接的顶点编号，紧跟边的权重值参考mannual和https://blog.csdn.net/vernice/article/details/47144509
    } #这里的输出把开始节点也输出，为了按开始节点进行排序,排序后将第一列（开始节点）去掉
    print $O1 "\n";

}
