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
my $fi = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/pathogenicity_SV_CNV/v4/output/all_pathogenicity_sv_snv_oncotree.vcf";
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
    unless(/^POS/){
        my $POS =$f[0];
        my $Score =$f[1];
        my $Project =$f[2];
        my $ID =$f[3];
        my $Source =$f[4];
        my $occurance =$f[5];
        if ($Source =~/Deletion/){
            my @t= split/\;/,$POS;
            my $chr = $t[0];
            my $start = $t[1];
            my $end =$t[2];
            # my $start2= $f[3];
            # my $end2 = $f[4];
            $sth = $dbh -> prepare("insert into Pathogenicity_snv_Deletion (sv_id,chr,start_pos,end_pos,project,occurance,CADD_score) 
                                    values (?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($ID,$chr,$start,$end,$Project,$occurance,$Score); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
