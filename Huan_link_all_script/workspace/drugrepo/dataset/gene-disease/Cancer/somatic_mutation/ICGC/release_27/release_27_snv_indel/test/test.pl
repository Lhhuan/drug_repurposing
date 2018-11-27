#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Time::HiRes qw(gettimeofday) ;

my $f1 = "../01_mutation_out_protein_coding_map_gene.vcf";
my $f2 = "../../../../enhancer–target/01_merge_all_fantom5_ENCODE_Roadmap_data.txt";
my $fo1 = "./02_mutation_in_enhancer–target_gene.txt";
my $fo2 = "./02_mutation_out_enhancer–target_gene_muti.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    if (/^#/){
        print $O2 "$_\n";
        if (/^#Uploaded_variation/){
            print $O1 "$_\tMap_to_gene_level\tscore\tsource\n";
        }
        else{
            print $O1 "$_\n";
        }
    }
     else{
         my @f =split/\s+/;
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my $location = $f[1];
         push @{$hash1{$location}},$_;
     }
}


my $i =0;
my ($start_sec, $start_usec) = gettimeofday;
my @text = <$I2>;#把文件读进数组
foreach my $line(@text) 
{
    #my $pid = $pm->start and next; #开始多线程
    chomp($line);
    my @f= split /\t/,$line;
    unless ($line=~/^region/){
        #my @f= split/\t/;
        my $region = $f[0];
        my $gene = $f[1];
        my $score = $f[2];
        my $source = $f[3];
        $region=~s/chr//g;
        my @f1= split/\:/,$region;
        my $chr1 = $f1[0];
        my @f2 = split/\-/,$f1[1];
        my $start =$f2[0];
        my $start1 = $start - 1;
        my $end1 =$f2[1];
        foreach my $ID(sort keys %hash1){
            $i=$i+1;
            #my $pid = $pm->start and next; #开始多线程
            my @infos =@{$hash1{$ID}};
            my @f3 = split/\:/,$ID;
            my $chr2 = $f3[0];
            my @f4=split/\-/,$f3[1];
            my $num_p = @f4;#判断数组内有几个元素。看位置是一个点还是一个区域。
            if($num_p==1){
                my $pos = $f4[0];
                if ($chr1 eq $chr2){
                    if($pos ge $start1&&$pos le $end1){ #如果pos 在target的文件中，就取该区域所对应的gene
                        foreach my $info(@infos){
                            my @vep = split/\s+/,$info;
                            my $output = join ("\t",@vep[0..2],$gene,@vep[4..13],$score,$source);
                            unless(exists $hash3{$output}){
                                $hash3{$output} =1;
                                print $O1 "$output\n";
                            }
                        }
                    }
                }

            }
            else{#$num_p ==2
                my $start2 = $f4[0];
                my $end2 = $f4[1];
                if ($chr1 eq $chr2){
                    if($start2 ge $start1&&$end2 le $end1){
                        foreach my $info(@infos){
                            my @vep = split/\s+/,$info;
                            my $output = join ("\t",@vep[0..2],$gene,@vep[4..13],$score,$source);
                            unless(exists $hash3{$output}){
                                $hash3{$output} =1;
                                print $O1 "$output\n";
                            }
                        }
                    }
                }
            }
            #print STDERR "$i\n";
            if ($i==10000){
                my($end_sec, $end_usec) = gettimeofday;
                my $timeDelta = ($end_usec - $start_usec) / 1000 + ($end_sec - $start_sec) * 1000;
                print STDERR "$timeDelta\n";
                last;
                
            }
        }
    }
}



# my ($start_sec, $start_usec) = gettimeofday;






# ($end_sec, $end_usec) = gettimeofday;
#  my $timeDelta = ($end_usec - $start_usec) / 1000 + ($end_sec - $start_sec) * 1000;
#     print $timeDelta ;



