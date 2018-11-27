#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my $dio = ".";

my $fi = "$dio/miRNA_primary_mature.txt";
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $fo = "$dio/miRNA_primary_regions.txt";
open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;

print "miRNA\tstrand\tmature\tregion\tstart\tend\n";
while (<$I>) {
    chomp;
    my @f = split /\t/;
    my ( $strand, $start, $end ) = ( $f[5], $f[7], $f[8] );

    my ( $pair, @lines );
    if ( $strand eq "+" ) {
        $pair = define_ps(@f);    # "5p" or "3p"
        push @lines, cal_plus( $pair, $start, $end );  #将$pair, $start, $end这三个参数传递给子程序，然后将子程序 cal_plus的返回值push到@lines里。
    }
    elsif ( $strand eq "-" ) {
        $pair = define_ps(@f);    # "5p" or "3p"
        push @lines, cal_minus( $pair, $start, $end );

    }
    else {
        print STDERR "No strand:\t$f[3]!\n";
    }

    foreach my $line (@lines) {
        print "$f[3]\t$f[5]\t$line\n";
    }
}
close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

sub define_ps {
    my @f = @_;
    my $pair;
    if ( $f[9] =~ /5p$/ ) {
        $pair = "5p";
    }
    elsif ( $f[9] =~ /3p$/ ) {
        $pair = "3p";
    }
    else {
        my $mid_pri = ( $f[2] - $f[1] ) / 2 + $f[1];
        my $mid_mat = ( $f[8] - $f[7] ) / 2 + $f[7];
        if ( $mid_mat < $mid_pri ) {
            $pair = $f[5] eq "+" ? "5p" : "3p";
        }
        elsif ( $mid_mat > $mid_pri ) {
            $pair = $f[5] eq "+" ? "3p" : "5p";
        }
        else {
            print STDERR "Can not define 5/3p:\t$f[3] ($f[5])\n";
        }

    }
    return ($pair);
}

# +, 5p/3p: A=(S,S+7); C=(S+8,E)
# +, 5p: B=(S-4,S-1)
# +, 3p: B=(E+1,E+4)
sub cal_plus {
    my ( $p, $s, $e ) = @_;
    my @lines;
    push @lines, join "\t", $p, "A", $s, $s + 7;
    push @lines, cal_plus_B( $p, $s, $e );
    push @lines, join "\t", $p, "C", $s + 8, $e;
    return (@lines);
}

sub cal_plus_B {
    my ( $p, $s, $e ) = @_;
    my $line;
    if ( $p eq "5p" ) {
        $line = join "\t", $p, "B", $s - 4, $s - 1;
    }
    if ( $p eq "3p" ) {
        $line = join "\t", $p, "B", $e + 1, $e + 4;
    }
    return ($line);
}

# -, 5p/3p: A=(E-7,E); C=(S,E-8)
# -, 5p: B=(E+1,E+4)
# -, 3p: B=(S-4,S-1)
sub cal_minus {
    my ( $p, $s, $e ) = @_;
    my @lines;
    push @lines, join "\t", $p, "A", $e - 7, $e;
    push @lines, cal_minus_B( $p, $s, $e );
    push @lines, join "\t", $p, "C", $s, $e - 8;
    return (@lines);
}

sub cal_minus_B {
    my ( $p, $s, $e ) = @_;
    my $line;
    if ( $p eq "5p" ) {
        $line = join "\t", $p, "B", $e + 1, $e + 4;
    }
    if ( $p eq "3p" ) {
        $line = join "\t", $p, "B", $s - 4, $s - 1;
    }
    return ($line);
}
