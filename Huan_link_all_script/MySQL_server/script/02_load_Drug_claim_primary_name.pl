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
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score_bioactivities.txt";
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
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){
        my $Drug_chembl_id_Drug_claim_primary_name =$f[0];
        my $Drug_claim_primary_name = $f[4];
        $Drug_claim_primary_name =~ s/NONE|NULL/NA/g;
        my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$Drug_claim_primary_name";
        unless(exists $hash1{$k}){ #去重
            $hash1{$k} =1;
            if ($Drug_claim_primary_name eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Drug_claim_primary_name) 
            }

        $sth = $dbh -> prepare("insert into Drug_claim_primary_name (Unique_drug_name,Drug_claim_primary_name) 
                                values (?, ?)");
        $sth -> execute($Drug_chembl_id_Drug_claim_primary_name,$Drug_claim_primary_name); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
