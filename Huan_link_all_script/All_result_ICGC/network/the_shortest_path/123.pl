#!usr/bin/perl-w 
use strict;
use Statistics::R;

my $R_code=<<"RCODE";
y1=c(67.63,68.20,69.23,67.90,66.90,66.10,69.21,66.20,64.90,67.20,63.30,65.00,64.10,64.60,62.20)
y2=c(rep(1,7),rep(2,8))
d=data.frame(income=y1,area=factor(y2))
attach(d)
print('Mann-Whitney检验:')
print(wilcox.test(income~area,data=d))
print('双样本Kolmogorov-Smirnov检验:')
print(ks.test(income[area==1],income[area==2]))
detach(d)
RCODE

my $R = Statistics::R->new( log_dir => 'D:/R/tem', tmp_dir => 'D:/R/tem' );

#$R->error;
$R->startR;
$R->send($R_code);
my $ret = $R->read;
print $ret, "\n";

$R->stopR();



#   my $a=1;
#   my $R = Statistics::R->new();  
#   $R->startR;
#   $R->send(qq`x=c(1,2,3,4,6) \n y=mean(x) \n z=$a+y \n print(z)`) ;  
#   my $ret = $R->read;
#   print $ret,"\n";  #输出R的处理结果
#   $R->stopR();
#   $ret=~s/\[\d\]\s+(\d+)/$1/g;
#   my $b=$ret+2;
#   print $b;#输出最终结果
