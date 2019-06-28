#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

#mysql config cariables
our $database = "gene";
our $usr      = "jianhua";
our $pw       = "jianhua";
our $dbh = 
    DBI->connect("DBI:mysql:$database;host=115.24.151.233","$usr","$pw")
    ||die "Could not connect to database : $DBI::errstr";

##connect to mysql 
# my $connection = $dbh;

my $dir = "/f/mulinlab/zhanye/project/QTLdb/data_refgene";
my $fi = "$dir/mysql_refgene.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    my $gene = $f[0];
    my $chr = $f[1];
    if ($chr =~ /X/) {
        $chr = "23";
    }
    elsif ($chr =~ /Y/) {
        $chr = "24";
    }
    my $start = $f[2];
    my $end = $f[3];
    my $strand = $f[4];

    $sth = $dbh -> prepare("insert into gene (gene,chr,start,end,strand) 
                               values (?, ?, ?, ?, ?)");
    $sth -> execute($gene,$chr,$start,$end,$strand);
}
$sth -> finish();
$dbh->disconnect();

