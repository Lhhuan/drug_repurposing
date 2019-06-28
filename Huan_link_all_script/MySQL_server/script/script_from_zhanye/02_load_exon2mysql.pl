#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

my $dir = "/f/mulinlab/zhanye/project/QTLdb/data_refgene";
# my $gene = "$dir/mysql_download_refgene.txt";
# open my $G , '<' , $gene or die "$0 : failed to open input file '$gene' : $!\n";

# my %hash;
# while (<$G>) {
#     chomp;
#     my @f = split/\t/;
#     my $id = $f[0];
#     my $gene = $f[1];
#     $hash{$gene} = $id;
# }


#mysql config cariables;
our $database = "gene";
our $usr      = "jianhua";
our $pw       = "jianhua";
our $dbh = 
    DBI->connect("DBI:mysql:$database;host=115.24.151.233","$usr","$pw")
    ||die "Could not connect to database : $DBI::errstr";

my $fi = "$dir/mysql_exon.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";

my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    my $gene = $f[0];
    my $start = $f[1];
    my $end = $f[2];
    # if (exists $hash{$gene}) {
    #     my $id = $hash{$gene};
    #     $sth =$dbh -> prepare("insert into exon (geneid,start,end)
    #                             values (?, ?, ?)");
    #     $sth -> execute($id,$start,$end);
    # }
    my $state = $dbh -> prepare ("select id from gene.gene where gene = ?");
    $state -> execute ($gene);
    while (my @rows = $state->fetchrow_array()) {
        my ($id) = @rows;
        $sth =$dbh -> prepare("insert into exon (geneid,start,end)
                                values (?, ?, ?)");   
        $sth -> execute($id,$start,$end);     
    }
}
$sth -> finish();
$dbh -> disconnect();