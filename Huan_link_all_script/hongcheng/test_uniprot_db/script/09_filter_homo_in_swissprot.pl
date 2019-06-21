#将在../output/swissprot_homo.txt 中的"/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_swissprot"内容调出来，得../output/09_filter_homo_in_swissprot.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="./test.txt";
# my $f2 ="123.txt.gz";
my $f1 ="../output/swissprot_homo.txt";
my $f2 ="/f/mulinlab/huan/hongcheng/uniprot_db/uniprotkb_swissprot";
my $fo1 ="../output/09_filter_homo_in_swissprot.txt"; 

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# open( my $I2 ,"gzip -dc $f2|") or die ("can not open input file '$f2' \n"); #读压缩文件
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my(%hash1,%hash2,%hash3);


while(<$I1>)
{
    chomp;
    $hash1{$_}=1;    
}



my @data;
my $old_id= 1;
while(<$I2>)
{
    chomp;
    if (/^\>/){
        my @f =split/\s+/;
        my $protein = $_;
        my $new_id = $protein;
        if (exists $hash1{$old_id}){
            # print $O1 "$_\n";
            print $O1 "$old_id\n";
            my $squence = join("\n",@data);
            print $O1 "$squence\n";
            @data=();
            $old_id =$new_id;
        }
        else{
            @data =();
            $old_id =$new_id;
        }
    }
    else{
        push @data,$_;
    }
    
}
