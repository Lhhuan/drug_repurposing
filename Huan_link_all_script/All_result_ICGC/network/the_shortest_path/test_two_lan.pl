#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use Statistics::R;
use Env qw(PATH);


my $f1 ="./test_start_end.txt";
#my $f2 ="./normal_network_num.txt";
#my $fo1 ="./normal_network_num.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
#open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

# select $O1;
# #print "id1\tid2\tscore\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_target/){
         my $start = $f[0];
         my $end = $f[1];
         my $pro=$f[2];
         push @{$hash1{$start}},$end;
     }
}

# Create a communication bridge with R and start R



# $R>library(readxl);
# $R>library(dplyr);
# $R>library(stringr);
# $R>library(igraph);





my $R_code=<<"RCODE";

input<-read.table("normal_network_num.txt",header = F)%>%as.data.frame()  #把文件读进来并转为data.frame
df <- data.frame(from=c(input$V1), to=c(input$V2), weight=c(input$V3))#把读进来的文件转化成图
g <- graph.data.frame(df) 
RCODE
foreach my $start (sort keys %hash1){
    my @ends = @{$hash1{$start}};
    foreach my $end(@ends){
        $ENV{'start'}  = $start;
        $ENV{'end'}  = $end;
        my $R_code1=<<"RCODE1";
        sv <- get.shortest.paths(g,start,end,weights=NULL,output="vpath")
        RCODE1
        my $output_value = $R->get('sv');
        print "$output_value\n";
    }

}
my $R = Statistics::R->new();
$R->startR;
$R->send($R_code);
my $ret = $R->read;
print $ret, "\n";

$R->stopR();






# while(<$I2>)
# {
#     chomp;
#     my @f= split /\t/;
#          my $start1 = $f[0];
#          my $end1 = $f[1];
#          my $pro=$f[2];
#          $ENV{'st'}  = $start1;
#          $ENV{'e'}  = $end1;
#          $ENV{'p'}  = $pro;

        



#          $R>run(my $df <- data.frame(from=c($start1), to=c($end1), weight=c($pro)));
#          $R>run(my $g <- graph.data.frame($df));

#          foreach my $start (sort keys %hash1){
#             my @ends = @{$hash1{$start}};
#             foreach my $end(@ends){
#                 $ENV{'start'}  = $start;
#                 $ENV{'end'}  = $end;
#                 $R>run(sv <- get.shortest.paths($g,$start,$end,weights=NULL,output="vpath"));
#                 my $output_value = $R->get('sv');
#                 print "$output_value\n";
#            }

#         }
# }