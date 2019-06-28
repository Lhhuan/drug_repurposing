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
        $f[$i] = "NA";
        }
        unless($f[$i]=~/\w/){$f[$i]="NA"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless(/^Drug_chembl_id_Drug_claim_primary_name/){

        # my $ENSG_ID =$f[14];
        my $Indication_ID = $f[16];
        # my $Drug_type = $f[17];
        my $DOID = $f[18];
        $DOID =~ s/"//g;
        my $DO_term =$f[19];
        $DO_term =~ s/"//g;
        my $HPO_ID =$f[20];
        $HPO_ID =~ s/"//g;
        my $HPO_term =$f[21];
        $HPO_term =~ s/"//g;
        my $indication_OncoTree_term_detail =$f[22];
        $indication_OncoTree_term_detail =~ s/"//g;
        my $indication_OncoTree_IDs_detail =$f[23];
        $indication_OncoTree_IDs_detail =~ s/"//g;
        my $indication_OncoTree_main_term =$f[24];
        $indication_OncoTree_main_term =~ s/"//g;
        my $indication_OncoTree_main_ID =$f[25];
        $indication_OncoTree_main_ID =~ s/"//g;
        # my $drug_target_score =$f[26];
        # my $PACTIVITY_median = $f[27];
        my $k = "$Indication_ID\t$DOID\t$DO_term\t$HPO_ID\t$HPO_term\t$indication_OncoTree_term_detail\t$indication_OncoTree_IDs_detail\t$indication_OncoTree_main_term\t$indication_OncoTree_main_ID";
        # print "$k\n";
        unless(exists $hash1{$k}){ #去重
            $hash1{$k} =1;
            if ($DOID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($DOID) 
            }
            if ($DO_term eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($DO_term) 
            }
            if ($HPO_ID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($HPO_ID)
            }
            if ($HPO_term eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($HPO_term) 
            }
            if ($indication_OncoTree_term_detail eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($indication_OncoTree_term_detail) 
            }
            if ($indication_OncoTree_IDs_detail eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($indication_OncoTree_IDs_detail) 
            }
            if ($indication_OncoTree_main_term eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($indication_OncoTree_main_term) 
            }
            if ($indication_OncoTree_main_ID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($indication_OncoTree_main_ID) 
            }
            $sth = $dbh -> prepare("insert into Drug_indication_map_information (Indication_ID,DOID,DO_term,
            HPO_ID,HPO_term,indication_OncoTree_term_detail,indication_OncoTree_IDs_detail,indication_OncoTree_main_term,indication_OncoTree_main_ID) 
                                    values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($Indication_ID,$DOID,$DO_term,$HPO_ID,$HPO_term,$indication_OncoTree_term_detail,$indication_OncoTree_IDs_detail,$indication_OncoTree_main_term,$indication_OncoTree_main_ID); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
