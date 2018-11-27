my $f1 ="./123.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

while(<$I1>) #将FIsInGene_022717_with_annotations.txt转化成random walk restart 可以用的格式
{
    chomp;
    # $Direction=~s/-/two/g;#把所有的-替换成two;
    # $Direction=~s/\</transact/g; #
    # $Direction=~s/\|/inhi/g;
    # $Direction =~s/transacttwo/a/g; #把<-替换成a

    #      $Direction =~s/inhitwo/in/;

    #      #print STDERR "$Direction\n";

    #      if($Direction=~/a|in/){
    #          print $O1 "$gene2\t$gene1\t$weight\t$Direction\n"; #反方向的按照与图中给的相反的顺序输出。
    #      }
    #      elsif($Direction=~/^two$/){ #这种相互作用的按照两个方向输出。
    #          print $O1 "$gene2\t$gene1\t$weight\t$Direction\n$gene1\t$gene2\t$weight\t$Direction\n";
    #      }
    #      else{
    #         #  $Direction =~s/>/a/;
    #         #  $Direction =~s/|/in/;
    #          print $O1 "$gene1\t$gene2\t$weight\t$Direction\n";
    #      }
    #  }
    my $Direction =$_;
    $Direction =~s/\<-/a/g;
    $Direction =~s/\|-/in/g;
    $Direction =~s/\>/a/g;
    $Direction =~s/\|/in/g;
    print "$Direction\n";
}
