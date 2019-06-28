#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

## 226
# # MYSQL CONFIG VARIABLES
# our $database = "QTLdb";
# our $user     = "zhanye";
# our $pw       = "mulinlab_zhanye";
# our $dbh =
#   DBI->connect( "DBI:mysql:$database;host=202.113.53.226", "$user", "$pw" )
#   || die "Could not connect to database: $DBI::errstr";


# # MYSQL CONFIG VARIABLES  ## 备用数据库
# our $database = "QTLdb_bak";
# our $user     = "zhanye";
# our $pw       = "mulinlab_zhanye";
# our $dbh =
#   DBI->connect( "DBI:mysql:$database;host=202.113.53.226", "$user", "$pw" )
#   || die "Could not connect to database: $DBI::errstr";



# MYSQL CONFIG VARIABLES  ## 212 temp
our $database = "QTLdb";
our $user     = "zhanye";
our $pw       = "mulinlab_zhanye";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=115.24.151.212", "$user", "$pw" )
  || die "Could not connect to database: $DBI::errstr";


#my $connection = ConnectToMySql($database);
my $connection = $dbh;


my $query = "insert into meta (id, pmid, tissue, popu, sample_size, asso_type, genome, confounding, repli, tissue_state, allele_spec, title, xqtl) 
   values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
my $statement = $connection->prepare($query);
# $statement->execute(7, 17289997,'Lymphocyte', 0, 123, 0, 0, 'aaa', 0, 'aaa\'a', 0, 'Relative impact of nucleotide and copy number variation on gene expression phenotypes', 1);
# $statement->finish(); 
# $dbh->disconnect(); 

my $fi = "/f/mulinlab/zhanye/project/QTLdb/data_meta/meta_data_result/all_qtl_meta_data_merge/14_rs_meta_data_result_mysql.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";

while (<$I>) {
  chomp;
  unless (/^ID/) {
    my @f = split/\t/;
    my $id = $f[0];
    my $pmid = $f[1];
    my $tissue = $f[2];
    my $popu = $f[3];
    my $sample_size = $f[4];
    $sample_size =~ s/^NA$/NULL/;
    if ($sample_size eq "NULL") {
      undef($sample_size);
    }    
    my $asso_type = $f[5];
    my $genome = $f[6];
    my $conf = $f[7];
    $conf =~ s/^NA$/NULL/;
    if($conf eq "NULL") {
      undef($conf);
    }
    my $rep = $f[8];
    my $tissue_state = $f[9];
    $tissue_state =~ s/^NA$/NULL/;
    if ($tissue_state eq "NULL") {
      undef($tissue_state);
    }
    my $allele_spec = $f[10];
    my $title = $f[11];
    my $xqtl = $f[12];
    #$statement->execute($id, $pmid, '$tissue', $popu, $sample_size, $asso_type, $genome, '$conf', $rep, '$tissue_state', $allele_spec, '$title', $xqtl);
    $statement->execute($id, $pmid, $tissue, $popu, $sample_size, $asso_type, $genome, $conf, $rep, $tissue_state, $allele_spec, $title, $xqtl);


  }
 
}

$statement->finish(); 
$dbh->disconnect();