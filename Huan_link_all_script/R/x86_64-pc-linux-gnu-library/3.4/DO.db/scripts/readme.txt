########Readme File##################
#Author :Jiang Li
#Email  :riverlee2008@gamil.com
#MSN    :riverlee2008@live.cn
#Address:Harbin Medical University
#TEl    :+86-13936514493
#####################################
This file will describe how we convert the OBO format file of Disease Ontology into
neccessary files which are needed by DO.db.


1)OBO file download
You can download the latest version of Disease Ontology from 
http://diseaseontology.svn.sourceforge.net/viewvc/diseaseontology/trunk/
and meanwhile you can set the revision number to get the specific version of Disease Ontology,
for example, the data we used here is version 926 and the download url is:
http://diseaseontology.svn.sourceforge.net/viewvc/diseaseontology/trunk/HumanDO.obo?revision=926&pathrev=926


2)Construct DO.sqlite dababase file
I have wrote a shell named 'batch_run.sh' to build the DO.sqlite which invokes 
a series of perl codes(see the source of the .pl file for detail) and some of 
the .pl file need the output of other .pl file. It works well on my PC(OS:ubuntu 8.10)

To do this, type following:
chmod +x batch_run.sh
./batch_run.sh

Note:You should have perl installed and perl packages "DBI" and "DBD::SQLite" are required, and 
you also need to have R installed and R package "RSQLite" is required.


