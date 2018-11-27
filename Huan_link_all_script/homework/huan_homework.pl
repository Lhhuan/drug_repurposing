#!/usr/bin/perl
use warnings;
use strict;

my $fi_input ="./input.txt";
open my $fh_input, '<', $fi_input or die "$0 : failed to open input file '$fi_input' : $!\n";


my ($A,$B,$C,$region,$B_start,$B_end,$centre,$out,$out1);
#print "chr"."\t"."miRNA"."\t"."strand"."\t"."mature"."\t"."region"."\t"."startAbs"."\t"."endAbs"."\n";
print "chr\tmiRNA\tstrand\tmature\tregion\tstartAbs\tendAbs\n";
while(<$fh_input>)
{
    chomp;
    my @f = split /\t/;
    my $chr = $f[0];
    my $H = $f[1];
    my $T = $f[2];
    my $name = $f[3];
    my $strand = $f[5];
    my $S = $f[7];
    my $E = $f[8];
    $out = join ("\t", $chr,$name,$strand);
    if ($strand =~ /\-/){
        my $A_start = $E - 7 ;
        $A = join ("\t", "A", $A_start, $E);
        my $C_end = $E - 8 ;
        $C = join ("\t", "C", $S, $C_end);
        $centre = ($H + $T)/2 ; 
        if ($S < $centre){
            $out1= join ("\t", $out, "3p");
            $B_start = $S - 4;
            $B_end = $S - 1;
            $B = join ("\t", "B", $B_start, $B_end);
            print "$out1\t$A\n$out1\t$B\n$out1\t$C\n"      
            }
        else{ 
            $out1= join ("\t", $out, "5p");
            my $B_start = $E + 1;
            my $B_end = $E + 4;
            $B = join ("\t", "B", $B_start, $B_end);
            print "$out1\t$A\n$out1\t$B\n$out1\t$C\n"
            }
    }
    else{
        my $A_end = $S + 7 ;
        $A = join ("\t", "A", $S, $A_end);
        my $C_start = $S + 8;
        $C = join ("\t", "C", $C_start, $E);
        $centre = ($H + $T)/2 ;
        if ($S < $centre){
            $out1= join ("\t", $out, "5p");
            $B_start = $S - 4;
            $B_end = $S - 1;
            $B = join ("\t", "B", $B_start, $B_end);
            print "$out1\t$A\n$out1\t$B\n$out1\t$C\n"
          }
        else{
            $out1= join ("\t", $out, "3p");
            $B_start = $E + 1;
            $B_end = $E + 4;
            $B = join ("\t", "B", $B_start, $B_end);
            print "$out1\t$A\n$out1\t$B\n$out1\t$C\n"
        }
    }

}
