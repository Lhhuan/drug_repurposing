use strict;
use warnings;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

my %hash;
my $allrs = "HumanOmni2-5-8-v1-2-A-b151-rsIDs.txt";
open my $R , '<' , $allrs or die "$0 : failed to open input file '$allrs' : $!\n";
while (<$R>) {
    chomp;
    my @f =split/\t/;
    my $rsid = $f[0];
    $hash{$rsid} = 1;
}



# MYSQL CONFIG VARIABLES  ## 212 
our $database = "QTLdb";
our $user     = "zhanye";
our $pw       = "mulinlab_zhanye";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=115.24.151.212", "$user", "$pw" )
  || die "Could not connect to database: $DBI::errstr";


my $fi = "/f/mulinlab/zhanye/project/QTLdb/WGS/metaid.txt";
open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";


my $sth;
my $state;
while (<$I>) {
    chomp;
    my @f = split/\t/;
    my $metaid = $f[0];
    my $state = $dbh -> prepare ("SELECT qtl.*, snp.* FROM QTLdb.qtl left join snp on snp.id = qtl.snpid where metaid = ?");
    $state -> execute ($metaid);
    while (my @rows = $state -> fetchrow_array()) {
        my $rsid = $rows[17];
        my $snpid = $rows[1];
        unless (exists $hash{$rsid}) {
            print "$rsid\t0\n";
            $sth = $dbh -> prepare("update QTLdb.qtl set keep = 1 where metaid =? and snpid = ?");
            $sth -> execute ($metaid,$snpid);            
        }        
    }
}

$sth -> finish();
#$state -> finish();
$dbh -> disconnect();