# #!/usr/bin/perl
# use warnings;
# use strict;

# my (%h, $filename);
# my $dirname="/anno/";

# opendir (DIR, $dirname)|| die "Error in opening dir $dirname\n";

# while (($filename=readdir(DIR))){

#          open (FILE, "/home/liuguiyou/lane6_7/ex/".$filename)|| die "can not open the file $filename\n";
#          open (OUT, ">/home/liuguiyou/lane6_7/ex/$filename.bak")|| die "can not open the $filename.bak\n";

#            while (<FILE>){
#                   print  OUT "$_";

# }
# }








#!/usr/bin/perl
use warnings;
use strict;
my ($dirname, $filename);
$dirname = "./anno/";        
opendir (DIR, $dirname ) || die "Error in opening dir $dirname\n";
 
while( ($filename = readdir(DIR))){
 if ($filename=~"maf"){
 
   open (FILE, "./anno/".$filename)|| die "can not open the file $filename\n";
 
    while (<FILE>){
      chomp;
       if (/^\w+/){
      my @f1 = split /\t/;
   
        if ($f1[122] =~ /Yes/){
       
         
          print $_."\n"
   #     }
      }
    }
  }
}
closedir(DIR);


      