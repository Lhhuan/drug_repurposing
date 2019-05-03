#为./output/three_source_driver.txt transvar 转换成hgvsg. 得文件./output/02_transvar_hgvsg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/three_source_driver.txt";
my $fo1 ="./output/02_transvar_hgvsg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

print $O1 "chr;start;stop;ref;alt\tdisease\tfinal_variant\thgvsg\thgvsg_scource\n";
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^hgvs/){
        my $chromosome = $f[1];
        my $start = $f[2];
        my $stop = $f[3];
        my $ref = $f[4];
        my $alt = $f[5];
        my $length_ref = length($ref);
        my $length_alt = length($alt);
        my $pos = join(",",@f[1..5]);
        my $gene = $f[7];
        my $variant = $f[9];
        my $disease = $f[10];
        my $final_variant = "${gene}:${variant}";
        if ($start eq $stop ){ #start 和end 相同的尝试用位置
            if ($ref !~/NA/ && $alt !~/NA/){ #原来有ref 和alt信息,ref 和alt 长度为 1的不再用transvar转
                if ($length_ref eq 1 && $length_alt eq 1){#原来有ref 和alt信息,ref 和alt 长度为 1的不再用transvar转
                    my $hgvsg = "${chromosome}:g.${start}${ref}>${alt}";
                    print $O1 "$pos\t$disease\t$final_variant\t$hgvsg\toriginal\n";
                }
                else{
                    my $hgvsg = transvar_results ($final_variant); #ref 和alt 长度不为 1，用transvar
                    print $O1 "$pos\t$disease\t$final_variant\t$hgvsg\ttransvar\n"; 
                }
            }
            else{
                my $hgvsg = transvar_results ($final_variant); #没有ref 和alt用transvar
                print $O1 "$pos\t$disease\t$final_variant\t$hgvsg\ttransvar\n";                
            } 
        }
        else{#start 和end 不相同的用transvar
            my $hgvsg = transvar_results ($final_variant);
            print $O1 "$pos\t$disease\t$final_variant\t$hgvsg\ttransvar\n";    
        }
    }
}

sub transvar_results {  #transvar 处理
    my ($variant) =@_;
    # print STDERR "$variant\n";
    my $transvar_results = readpipe ("transvar panno -i $variant --ensembl | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
    my @v = split/\s+/,$transvar_results;
    my $number = @v;
    if ($number>1){
        my $hgvss = $v[1];
        my @h = split/\//,$hgvss;
        my $hgvsg = $h[0];
        return $hgvsg;       
    }
    else{
        my $hgvsg = "NA";
        return $hgvsg; 
    }
}
