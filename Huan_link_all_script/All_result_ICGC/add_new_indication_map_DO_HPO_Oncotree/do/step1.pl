#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将mapin的term，doid和对应的indication生成一张表
my $f1 ="../refine_new_add_drugbank_indication.txt";
my $f2 = "./2MQ5CTF.id-id.txt";
my $f3 = "./id-term.txt";
my $fo1 = "./step1_indication_do_term.txt";  
my $fo2 = "./step1_indication_no_do_term.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
select $O1;
print "ID\tindication\tDOID\tDO_term\n";
select $O2;
print "ID\tindication\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
   chomp;
   my @f = split/\t/;
   my $ID = $f[0];
   my $indication = $f[1]; 
   $indication =~s/"//g;
   $indication =lc($indication);
   $hash1{$ID} = $indication;
}

while(<$I2>)
{
   chomp;
   my @f = split/\t/;
   for (my $i=0;$i<3;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
   }
   unless($f[1] eq "NONE"){
       my $indiacation_id = $f[0];
       my $term_id = $f[1];
       my @term = split /\|/,$f[1];
       $hash2{$indiacation_id} = \@term;
      # print "$hash2{$indiacation_id}\n";
   }
}

while(<$I3>)
{
   chomp;
   my @f = split/\t/;
   my $ID = $f[0];
   my $term = $f[1];
   $hash3{$ID} = $term;

}


 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ 
            my $indication = $hash1{$key1};
            my @term = @{$hash2{$key1}};
            foreach my $term_id(@term){
                if(exists $hash3{$term_id}){ 
                    my $term = $hash3{$term_id};
                    print $O1 "$key1\t$indication\t$term_id\t$term\n";
                }
            }
        }
        else{ #在do中没有mapin的indiacation
            my $indication = $hash1{$key1};
            print $O2 "$key1\t$indication\n";
        }
 }

close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";