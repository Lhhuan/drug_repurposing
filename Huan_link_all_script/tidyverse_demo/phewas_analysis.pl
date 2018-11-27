#!/usr/bin/perl

use warnings;
use strict;

use Text::CSV;
my $csv = Text::CSV->new( { binary => 1 } )
  or die "Cannot use CSV: " . Text::CSV->error_diag();

my $dir_out  = "output_perl";
my $file_in  = "phewas.csv";
my $file_out = "$dir_out/phewas_brief.csv";
open my $I, '<:encoding(utf8)', $file_in
  or die "$0 : failed to open input file '$file_in' : $!\n";
open my $O, '>:encoding(utf8)', $file_out
  or die "$0 : failed to open output file '$' : $!\n";
my @header;
push @header, "chr", "pos", "snp", "cases", "pvalue", "ratio", "gene",
  "pehnotype", "gwas";
$csv->say( $O, \@header );
my %gene;

while ( my $row = $csv->getline($I) ) {
    my @fields = @$row;
    if ( $fields[0] =~ /\w\s\d/ && $fields[6] ne "NULL" ) {
        if ( $fields[3] >= 100 && $fields[5] >= 1 ) {
            my ( $chr, $pos ) = split /\s+/, $fields[0];
            $chr = "chr" . $chr;
            my $value = join "\t", $chr, $pos, $fields[1], @fields[ 3 .. 6 ],
              $fields[2], $fields[-1];
            my @record = split /\t/, $value;
            $csv->say( $O, \@record );
            push @{ $gene{ $fields[6] } }, $value;
        }
    }
}
$csv->eof or $csv->error_diag();
close $I  or warn "$0 : failed to close input file '$file_in' : $!\n";
close $O  or warn "$0 : failed to close output file '$file_out' : $!\n";

my $file_gene = "$dir_out/top15_gene.csv";
open my $G, '>:encoding(utf8)', $file_gene
  or die "$0 : failed to open output file '$file_gene' : $!\n";
push @header, "number";
$csv->say( $G, \@header );
my $i = 15;
foreach my $key ( sort { @{ $gene{$b} } <=> @{ $gene{$a} } } keys %gene ) {
    if ( $i > 0 ) {
        foreach my $snp ( @{ $gene{$key} } ) {
            my @record = split /\t/, $snp;
            push @record, scalar( @{ $gene{$key} } );
            $csv->say( $G, \@record );
        }
    }
    $i--;
}
close $G or warn "$0 : failed to close output file '$file_gene' : $!\n";
