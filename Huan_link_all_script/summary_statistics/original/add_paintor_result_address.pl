#基于summary_cancer_revise_paintor_note.txt 把ukbb的paintor 结果填充，得文件summary_cancer_revise_paintor_note_address.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
use Parallel::ForkManager; #多线程并行

# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目


my $f1 ="./summary_cancer_revise_paintor_note.txt";
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my $fo1 ="./summary_cancer_revise_paintor_note_address.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
 my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

select $O1;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
   if (/^File_name/){
       print "$_\tpaintor_result_local\n";
   }
   else{
       if($f[10] !~ /UKBB_biobank/){
           print "$_\tNA\n";
       }
       else{
           print "$_\tUKBB_biobank/fine_mapping/paintor/Cancer/$f[-1]/fine_mapping_output_result\n";
       }
   }
}
