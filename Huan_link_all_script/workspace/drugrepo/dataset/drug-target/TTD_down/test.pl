#!/usr/bin/perl
use warnings;
use strict;
my $fi_step2 ="step2-result-target-name";
my $fi_step3 ="step3-result-action";
my $fi_step4 ="P2-01-TTD_uniprot_all.txt";
open my $fh_step2, '<', $fi_step2 or die "$0 : failed to open input file '$fi_step2' : $!\n";
open my $fh_step3, '<', $fi_step3 or die "$0 : failed to open input file '$fi_step3' : $!\n";
open my $fh_step4, '<', $fi_step4 or die "$0 : failed to open input file '$fi_step4' : $!\n";

my %hash1;
my %hash2;
my %hash3;
my $name;
my $k2;
my $uniprot_id;

while(<$fh_step2>)
{
    chomp;
    my @f1 = split /\t/;
    my $id1 = $f1[0];
    $name = $f1[2];
    $hash1{$id1}=$name;  
}

while(<$fh_step3>)
{
    chomp;
    my @f1 = split /\t/;
    my $id2 = $f1[0];
    $k2 = join "\t", @f1[1,2];
    #$hash2{$id2}=$k2;
    push @{$hash2{$id2}},$k2;
}

while(<$fh_step4>)
{
    chomp;
    unless (/^TTD/){
        if(/^T/){
        my @f1 = split /\t/;
        my $id3 = $f1[0];
        my $target_name = $f1[1];
        print $f1[0]."\n"
        # $uniprot_id = $f1[3];
        # $hash3{$target_name}=$uniprot_id;
        }
    }
}

 

# foreach my $id2 (sort keys %hash2){
#     if (exists $hash1{$id2}){
#              my @k = @{$hash2{$id2}};
#              my $name = $hash1{$id2} ;
#              if (exists $hash3{$name}){
#                  $uniprot_id = $hash3{$name};
#               #   print $name."\n"
#                   foreach my $k(@k){
#             # #    print "$id2\t$name\t$uniprot_id\t$k\n"
#             # print $uniprot_id."\n"
#                    print $id2."\n"

#             #  #    }
#              }
#          }
#     }
# }

      