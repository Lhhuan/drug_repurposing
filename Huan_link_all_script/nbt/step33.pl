my $fi_match ="./step3_match_targetid_indication_drug_mimnumber_disorder_uniprotid";
my $fi_mismatch ="./step3_mismatch_targetid_indication_drug_mimnumber_disorder_uniprotid";

open my $fh_match, '<', $fi_match or die "$0 : failed to open input file '$fi_match' : $!\n";
open my $fh_mismatch, '<', $fi_mismatch or die "$0 : failed to open input file '$fi_mismatch' : $!\n";



while(<$fh_match>)
{
   chomp;
    
        my @f1 = split /\t/;
        my $target = $f1[0];
        my $drug1 =$f1[2];
      
          
        
       #  print $drug1."\t".$target."\n";
}
  

  while(<$fh_mismatch>)
{
   chomp;
    
        my @f2 = split /\t/;
        my $target2 = $f2[0];
        my $drug2 =$f2[2];
      
          
        
         print $target2."\n";
}
  