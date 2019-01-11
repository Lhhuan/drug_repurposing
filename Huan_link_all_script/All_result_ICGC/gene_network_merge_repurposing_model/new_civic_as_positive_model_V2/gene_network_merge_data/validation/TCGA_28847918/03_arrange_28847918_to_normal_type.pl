#将./data/28847918/supp9.txt 转换成数组的格式，即：drug sample number 得./output/28847918_normal_type.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "./data/28847918/supp9.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "./output/28847918_normal_type.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "Drug\tSample\tValue\n";


my @samples =();
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if ($. ==1){
        push @samples,@f;#将sample 存进数组
        # my $i =0;
        # foreach my $title(@samples){
        #     $i++;
        #     print STDERR "$i\n"; #可以看出，一共5449列，
        # }
        # print STDERR "$samples[5448]\n";
    }
    else{
        for (my $i=1;$i<5449;$i++){ #对原表格进行逐个转换
            my $drug = $f[0];
            my $sample = $samples[$i];
            my $value = $f[$i];
            my $output = "$drug\t$sample\t$value";
            print $O1 "$output\n";
        }  
    }
}

close($O1);