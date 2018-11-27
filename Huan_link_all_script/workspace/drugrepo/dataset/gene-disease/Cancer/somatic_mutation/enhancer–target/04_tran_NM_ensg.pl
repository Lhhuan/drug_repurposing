#把02_all_NM.txt和03_NM_to_ensg.txt merge 在一起，得到每个区间所对应的ensg id，得文件04_all_NM_ensg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./02_all_NM.txt";
my $f2 ="./03_NM_to_ensg.txt";
my $fo1 ="./04_all_NM_ensg.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     if (/^region/){
         print $O1 "$_\n";
     }
     else{
         my $region = $f[0];
         my $gene =$f[1];
         my $score = $f[2];
         my $source = $f[3];
         push @{$hash1{$gene}},$_;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $NM = $f[0];
         my $ensg_id = $f[3];
         unless($ensg_id=~/NULL/){
            $ensg_id =~ s/"list\(gene//g;
            $ensg_id =~ s/\s+//g;
            $ensg_id =~ s/"//g;
            $ensg_id =~ s/\)//g;
            $ensg_id =~ s/\(//g;
            $ensg_id =~ s/\=//g;
            $ensg_id =~ s/c//g;
            $ensg_id =~s/listgene//g;
            my @e = split/,/,$ensg_id;
            my $ensg = $e[0];
            
            $hash2{$NM} = $ensg;
         }         
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $ensg = $hash2{$ID};
        my @infos = @{$hash1{$ID}};
        foreach my $info(@infos){
            my @f1= split/\t/,$info;
            my $out = "$f1[0]\t$ensg\t$f1[2]\t$f1[3]";
            unless(exists $hash3{$out}){
                $hash3{$out} =1;
                print $O1 "$out\n";
            }
        }
    } 
    else {
        my @infos = @{$hash1{$ID}};
        foreach my $info(@infos){
            my $out = $info;
            unless(exists $hash3{$out}){
                $hash3{$out} =1;
                print $O1 "$out\n";
            }
        }
    }
}

