#将all_gwas_summary_v1.txt和mapin的do merge 起来
#!/usr/bin/perl
use warnings;
use strict;
use utf8;
my $f1 ="./uni_ID_all_indication_outside_of_reproduction.txt";
my $f2 = "./summary_mapin/do/3PO1KDF.id-id.mapin";
my $f3 = "./summary_mapin/do/ID-term.txt";
my $f4 = "./all_gwas_summary_v1.txt";
my $fo1 = "./all_gwas_summary_v2.txt";  
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "File_name_Downloaded\tTrait name\tConsortium/first_author/database\tSample_size\tPMID\tPublish_year\tEthnicity\tSub_population\tFolder_name_local\tFile_name_local\tFile_ID_local\tDocumentation_file\(file_name/website\)\tNotes\tGenome_Reference\tDo_ID\tDo_Term\tHPO_ID\tHPO_Term\n";
select $O1;
print "$title"; 
# select $O1;
# print "ID\tindication\tHPO_ID\tHPO_term\n";
# select $O2;
# print "ID\tindication\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
   chomp;
   my @f = split/\t/;
   my $ID = $f[0];
   my $indication = $f[1]; 
   $hash1{$ID} = $indication;
}

while(<$I2>)
{
   chomp;
   my @f = split/\t/;
   for (my $i=0;$i<3;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
   }
   unless($f[1] eq "NONE"){
       my $indiacation_id = $f[0];
       my $term_id = $f[1];
       my @term = split /\|/,$f[1];
       $hash2{$indiacation_id} = \@term;
      # print "$hash2{$indiacation_id}\n";
   }
}

while(<$I3>)
{
   chomp;
   my @f = split/\t/;
   my $ID = $f[0];
   my $term = $f[1];
   $hash3{$ID} = $term;

}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    unless(/^File_name/){
         my $Trait = $f[1];
         my $k = join("\t",@f[0..13]);
         push @{$hash4{$Trait}},$k;
         #print $O1 "$k\n";
    }
}


 foreach my $key1(sort keys %hash1){
       if(exists $hash2{$key1}){ 
            my $indication = $hash1{$key1};
            my @term = @{$hash2{$key1}};
            foreach my $term_id(@term){
                if(exists $hash3{$term_id}){ 
                    my $term = $hash3{$term_id};
                    #print $O1 "$key1\t$indication\t$term_id\t$term\n";
                    my $v = "$term_id\t$term";
                    push @{$hash5{$indication}},$v;
                }
            }
        }   
 }

my @id;
my @term;
foreach my $key4( keys %hash4){
    if(exists $hash5{$key4}){ 
        my @v4=@{$hash4{$key4}};
        my @v5= @{$hash5{$key4}};
        foreach my $v4(@v4){
            foreach my $v5(@v5){
                my @fi= split/\t/,$v5;
                push  @{$hash6{$v4}},$fi[0];
                push  @{$hash7{$v4}},$fi[1];
            }
            
            my @id = @{$hash6{$v4}};
            my @term = @{$hash7{$v4}};
            my $ids = join("|", @id); #使一行对应多个trait的disease，do或者hpo后也在一行中。
            my $terms = join("|",@term);
                 print $O1 "$v4\t$ids\t$terms\n";
        }
    }
    else{
        my @v4=@{$hash4{$key4}};
        foreach my $v4(@v4){
            print $O1 "$v4\tNA\tNA\n";
        }
    }
}





close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";