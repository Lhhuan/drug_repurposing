use Text::NSP::Measures::2D::Fisher::left;
 
my $npp = 60; my $n1p = 20; my $np1 = 20;  my $n11 = 10;
 
$left_value = calculateStatistic( n11=>$n11,
                                    n1p=>$n1p,
                                    np1=>$np1,
                                    npp=>$npp);
 
if( ($errorCode = getErrorCode()))
{
  print STDERR $errorCode." - ".getErrorMessage();
}
else
{
  print getStatisticName."value for bigram is ".$left_value;
}