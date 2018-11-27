 my $fi_snp_disease ="step2_result_index_pos_disease";
 my $fi_snp_vep ="index-1E-5-vep-missed";

 open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
 open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

 my @f;
while(<$fh_snp_vep>)
{
    chomp;  
  push @f,$_;
}

  while(<$fh_snp_disease>)
 {
    chomp; 
    unless(/^INDEX/){    
         my @f1 = split /\t/;
         my $index = $f1[0];
         my $chrom = $f1[1];
         my $pos = $f1[2];
         my $ref = $f1[4];
         my $alt = $f1[5];
         foreach my $f(@f) {
             if($index eq $f ){
                # print $index ."\n"
                 print $chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n"
             }
          }
    }
 }