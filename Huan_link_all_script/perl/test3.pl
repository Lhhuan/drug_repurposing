1. Keep SNP records, discard CNV records
2. Discard some columns and arrange the remaining columns, format chromosome to "chrN"
3. Class records according to distanceTSS (20kb, 50kb)
4. Compare the rho value between groups


#!/usr/bin/perl

use warnings;
use strict;

my $dir_out = "output_perl";
my $fi      = "pgen.tsv";
my $fo      = "$dir_out/pgen_brief.tsv";
open my $I, '<', $fi or die "$0 : failed to open input file '$fi' : $!\n";
open my $O, '>', $fo or die "$0 : failed to open output file '$' : $!\n";
select $O;
print join "\t", "SNP", "gene", "chr", "posSNP", "posTSS", "distanceTSS", "rho", "pvalue", "group";
print "\n";

while (<$I>) {
    if (/^rs\d+/) {
        my @fields = split /\t/;
        my $chr    = "chr" . $fields[3];
        my $group =
          $fields[7] >= 50000
          ? "Large"
          : ( $fields[7] >= 20000 ? "Middle" : "Small" );
        print join "\t", $fields[0], $fields[2], $chr, @fields[ 5 .. 9 ], $group;
        print "\n";
    }
}
close $I or warn "$0 : failed to close input file '$fi' : $!\n";
close $O or warn "$0 : failed to close output file '$' : $!\n";







### Tasks to do
1. Drop records whose NCBI or HGNC or Ensembl ID is `NA`
2. Keep columns (PharmGKB, NCBI, Name, Symbol, Chr, Start, End)
3. Calaculate the length based on start and end of the chromosome
4. Arrange the columns
5. Plot the length distribution
6. Compara the numbers between chromosomes
    * data: sort by numbers from high to low
    * plot
7. Save data and plot


#!/usr/bin/perl

use warnings;
use strict;

my $dir_out    = "output_perl";
my $file_genes = "genes.tsv";
my $file_out   = "$dir_out/genes_brief.tsv";
open my $I, '<', $file_genes or die "$0 : failed to open input file '$file_genes' : $!\n";
open my $O, '>', $file_out or die "$0 : failed to open output file '$file_out' : $!\n";
select $O;
print join "\t", "PharmGKB", "NCBI", "Symbol", "Chr", "Start", "End", "Length", "Name";
print "\n";
my %number;

while (<$I>) {
    chomp;
    unless (/^Pham/) {
        my @fields = split /\t/;
        if ( $fields[1] =~ /\d/ && $fields[2] =~ /\d/ && $fields[3] =~ /\w/ ) {
            my $length = $fields[-1] - $fields[-2];
            $number{ $fields[-3] }++;
            print join "\t", @fields[ 0, 1, 5, -3, -2, -1 ], $length, $fields[4];
            print "\n";
        }
    }
}
close $I or warn "$0 : failed to close input file '$file_genes' : $!\n";
close $O or warn "$0 : failed to close output file '$file_out' : $!\n";

my $file_number = "$dir_out/genes_chr_num.tsv";
open my $ON, '>', $file_number or die "$0 : failed to open output file '$file_number' : $!\n";
select $ON;
print "Chr\tCount\n";
foreach my $key ( sort { $number{$b} <=> $number{$a} } keys %number ) {
    print "$key\t$number{$key}\n";
}
close $ON or warn "$0 : failed to close output file '$file_number' : $!\n";
```


### Tasks to do
1. Drop records whose position is missing or gene name is NULL
2. Split chromosome and position, and format chromosome to "chrN"
3. Keep records whose cases number is more than 100 and its odds ratio is great than 1
4. Discard column codes and arrange remaining columns
5. Find the top 15 genes which have the most SNPs
    1. Count the SNP number for each gene
    2. Select the top 15 genes according to SNP number
    3. Restore the SNP infomation for these genes













#!/usr/bin/perl

use warnings;
use strict;

use Text::CSV;
my $csv = Text::CSV->new( { binary => 1 } ) or die "Cannot use CSV: " . Text::CSV->error_diag();

my $dir_out  = "output_perl";
my $file_in  = "phewas.csv";
my $file_out = "$dir_out/phewas_brief.csv";
open my $I, '<:encoding(utf8)', $file_in or die "$0 : failed to open input file '$file_in' : $!\n";
open my $O, '>:encoding(utf8)', $file_out or die "$0 : failed to open output file '$' : $!\n";
my @header;
push @header, "chr", "pos", "snp", "cases", "pvalue", "ratio", "gene", "pehnotype", "gwas";
$csv->say( $O, \@header );
my %gene;

while ( my $row = $csv->getline($I) ) {
    my @fields = @$row;
    if ( $fields[0] =~ /\w\s\d/ && $fields[6] ne "NULL" ) {
        if ( $fields[3] >= 100 && $fields[5] >= 1 ) {
            my ( $chr, $pos ) = split /\s+/, $fields[0];
            $chr = "chr" . $chr;
            my $value = join "\t", $chr, $pos, $fields[1], @fields[ 3 .. 6 ], $fields[2], $fields[-1];
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
open my $G, '>:encoding(utf8)', $file_gene or die "$0 : failed to open output file '$file_gene' : $!\n";
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



