#将FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式，得文件normal_network.txt。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./FIsInGene_022717_with_annotations.txt";
# my $f1 ="./test1234.txt";
my $fo1 ="./normal_network.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

# select $O1;
print $O1 "Gene1\tGene2\tweight\tdirection\n";
while(<$I1>) #将FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式
{
    chomp;
    my @f= split /\t/;
     unless(/^Gene1/){
         my $gene1 = $f[0]; #图中给的start
         $gene1 =~s/\s+/-/g; #因为中间有空格，会让rmr程序认为那是两列，
         my $gene2 = $f[1]; #图中给的end
         $gene2 =~s/\s+/-/g;
         my $Annotation = $f[2];
         my $Direction = $f[3];
         my $probility = $f[4]; #相当于权重weight
         my $weight = exp(-$probility);
         $Direction =~s/\<-/a/g; #<-替换为a, <->替换为aa,<-|替换为ain,|-替换为in,|->替换为ina,|-|替换为inin,-不替换，->替换为-a, -|替换为-in
         $Direction =~s/\|-/in/g;
         $Direction =~s/\>/a/g;#a代表激活，in代表抑制。
         $Direction =~s/\|/in/g;
        if($Direction=~/a/){
            if($Direction=~/in/){
                if($Direction=~/ain/){ #这里表示的是<-|
                    print $O1 "$gene2\t$gene1\t$weight\ta\n"; #
                    print $O1 "$gene1\t$gene2\t$weight\tin\n";
                }
                else{ #这里是ina 这里表示的是|->
                    print $O1 "$gene2\t$gene1\t$weight\tin\n"; #
                    print $O1 "$gene1\t$gene2\t$weight\ta\n";

                }
            }
            elsif($Direction=~/^a$/){#这里是a，也就是源文件中的<-
                print $O1 "$gene2\t$gene1\t$weight\ta\n"; 
            }
            else{
                if($Direction=~/aa/){ #这里表示的是<->
                print $O1 "$gene1\t$gene2\t$weight\ta\n"; 
                print $O1 "$gene2\t$gene1\t$weight\ta\n"; 
                }
                else{ #这里是-a，也就是表示的->
                 print $O1 "$gene1\t$gene2\t$weight\ta\n";
                }
            }
        }
        elsif($Direction=~/in/){
            if($Direction=~/inin/){#这里表示的是|-|
                print $O1 "$gene1\t$gene2\t$weight\tin\n"; 
                print $O1 "$gene2\t$gene1\t$weight\tin\n"; 
            }
            elsif($Direction=~/^in$/){ #这里表示的是|-
                print $O1 "$gene2\t$gene1\t$weight\tin\n";  
            }
            else{ #这里是-in表示的是-|
                print $O1 "$gene1\t$gene2\t$weight\tin\n";
            }
        }
        else{ #这里表示的是-，双向走，既不激活也不抑制
            print $O1 "$gene1\t$gene2\t$weight\t-\n";
            print $O1 "$gene2\t$gene1\t$weight\t-\n";  
        }
     }
}
close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";


