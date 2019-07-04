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
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
my $sth;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    for (my $i=0;$i<5;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NA";
        }
        unless($f[$i]=~/\w/){$f[$i]="NA"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless(/^project/){
        my $project =$f[0];
        my $cancer_ID =$f[1];
        my $project_full_name =$f[2];
        my $project_full_name_from_project =$f[3];
        my $oncotree_term_detail =$f[4];
        my $oncotree_ID_detail =$f[5];
        my $oncotree_term_main_tissue =$f[6];
        my $oncotree_ID_main_tissue =$f[7];
        $sth = $dbh -> prepare("insert into Project_oncotree (project,cancer_ID,project_full_name,project_full_name_from_project,oncotree_term_detail,
        oncotree_ID_detail,oncotree_term_main_tissue,oncotree_ID_main_tissue) 
                                values (?, ?, ?, ?, ?, ?, ?, ?)");
        $sth -> execute($project,$cancer_ID,$project_full_name,$project_full_name_from_project,$oncotree_term_detail,$oncotree_ID_detail,
        $oncotree_term_main_tissue,$oncotree_ID_main_tissue); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
