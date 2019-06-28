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
my %hash1;
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/drug_indication_type.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    for (my $i=0;$i<6;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NA";
        }
        unless($f[$i]=~/\w/){$f[$i]="NA"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){

        # my $ENSG_ID =$f[14];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_type = $f[1];
        my $indication_type = $f[2];
        $sth = $dbh -> prepare("insert into Drug_indication_type (Unique_drug_name,drug_type,indication_type) 
                                values (?, ?, ?)");
        $sth -> execute($Drug_chembl_id_Drug_claim_primary_name,$Drug_type,$indication_type); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
