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
my $fi = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt";
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
    unless(/^Mutation_ID/){
        my $Mutaton_ID =$f[0];
        my $ENSG_ID =$f[1];
        my $Map_to_gene_level =$f[2];
        my $entrezgene =$f[3];
        my $project =$f[4];
        my $cancer_specific_affected_donors =$f[5];
        if ($entrezgene eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($entrezgene) 
        }
        $sth = $dbh -> prepare("insert into Pathogenicity_snv_indel_map_to_gene_project (Mutation_ID,ENSG_ID,Map_to_gene_level,entrezgene,project,cancer_specific_affected_donors) 
                                values (?, ?, ?, ?, ?, ?)");
        $sth -> execute($Mutaton_ID,$ENSG_ID,$Map_to_gene_level,$entrezgene,$project,$cancer_specific_affected_donors); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
