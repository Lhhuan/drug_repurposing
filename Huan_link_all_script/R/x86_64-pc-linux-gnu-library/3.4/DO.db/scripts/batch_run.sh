#!/bin/bash
###################################
#Author :Jiang Li
#Email  :riverlee2008@gmail.com
#MSN    :riverlee2008@live.cn
#Address:Harbin Medical University
#TEl    :+86-13936514493
###################################

###################################
#to run the get_do_relationship.pl
echo "To run the perl code get_do_relationship.pl";
echo "And it will generate two files:";
echo "1,child2parent.txt";
echo "2,parent2offspring.txt";
echo "start at:",`date`;
perl get_do_relationship.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";


###################################
#to run the prepare_do_term.pl
echo "To run the perl code prepare_do_term.pl";
echo "And it will generate one file:";
echo "1,do_term.txt";
echo "start at:",`date`;
perl prepare_do_term.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";


###################################
#to run the prepare_do_synonym.pl
echo "To run the perl code prepare_do_synonym.pl";
echo "And it will generate one file:";
echo "1,do_synonym.txt";
echo "start at:",`date`;
perl prepare_do_synonym.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";


###################################
#to run the prepare_do_obsolete.pl
echo "To run the perl code prepare_do_obsolete.pl";
echo "And it will generate one file:";
echo "1,do_obsolete.txt";
echo "start at:",`date`;
perl prepare_do_obsolete.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";



###################################
#to run the prepare_do_offspring.pl
echo "To run the perl code prepare_do_offspring.pl";
echo "And it will generate one file:";
echo "1,do_offspring.txt";
echo "start at:",`date`;
perl prepare_do_offspring.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";



###################################
#to run the prepare_do_parents.pl
echo "To run the perl code prepare_do_parents.pl";
echo "And it will generate one file:";
echo "1,do_parents.txt";
echo "start at:",`date`;
perl prepare_do_parents.pl HumanDO.obo
echo "end at:",`date`;
echo "###################################";
echo "";



###################################
#to run the create_DO.db.pl
echo "To run the perl code create_DO.db.pl";
echo "And it will invoke R and generate the DO.sqlite database file";
echo "meanwhile it will insert the meta data into DO.sqlite"
echo "start at:",`date`;
perl create_DO.db.pl
echo "end at:",`date`;
echo "###################################";
echo "";


####################################
#to insert term data into do_term table
echo "Insert do_term.txt data into do_term table";
echo "start at:",`date`;
perl insert_data.pl do_term do_term.txt
echo "end at:",`date`;
echo "###################################";
echo "";



####################################
#to insert term data into do_obsolete table
echo "Insert do_obsolete.txt data into do_obsolete table";
echo "start at:",`date`;
perl insert_data.pl do_obsolete do_obsolete.txt
echo "end at:",`date`;
echo "###################################";
echo "";



####################################
#to insert term data into do_offspring table
echo "Insert do_offspring.txt data into do_offspring table";
echo "start at:",`date`;
perl insert_data.pl do_offspring do_offspring.txt
echo "end at:",`date`;
echo "###################################";
echo "";



####################################
#to insert term data into do_parents table
echo "Insert do_parents.txt data into do_parents table";
echo "start at:",`date`;
perl insert_data.pl do_parents do_parents.txt
echo "end at:",`date`;
echo "###################################";
echo "";




####################################
#to insert term data into do_synonym table
echo "Insert do_synonym.txt data into do_synonym table";
echo "start at:",`date`;
perl insert_data.pl do_synonym do_synonym.txt
echo "end at:",`date`;
echo "###################################";
echo "";


####################################
#to remove the template files

ls |grep -E 'txt$|R$' |grep -v 'readme' |xargs rm

