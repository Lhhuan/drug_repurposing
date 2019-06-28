#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

#mysql config cariables
our $database = "OncoRepo";
our $user     = "huan";
our $pw       = "mulinlab_huan";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=202.113.53.211", "$user", "$pw" )  #连接数据库
  || die "Could not connect to database: $DBI::errstr";

##connect to mysql 
# my $connection = $dbh;

# my $dir = "/f/mulinlab/zhanye/project/QTLdb/data_refgene";
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/normal_four_source_gene_role.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    for (my $i=0;$i<6;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
    unless(defined $f[$i]){
    $f[$i] = "NONE";
    }
unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
}
    unless(/^symbol/){
        my $symbol =$f[0];
        my $Role_in_cancer = $f[3];
        my $source = $f[4];
        my $ENSG_ID = $f[5];
        $ENSG_ID =~ s/NONE|NULL/NA/g; 
        if ($ENSG_ID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($ENSG_ID) 
        }

    $sth = $dbh -> prepare("insert into Cancer_gene_role (symbol,Role_in_cancer,Source,ENSG_ID) 
                               values (?, ?, ?, ?)");
    $sth -> execute($symbol,$Role_in_cancer,$source,$ENSG_ID); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
