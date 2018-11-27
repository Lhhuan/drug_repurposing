### R code from vignette source 'DO.db.Rnw'

###################################################
### code chunk number 1: DO.db.Rnw:48-50
###################################################
library(DO.db)
help(DO.db)


###################################################
### code chunk number 2: DO.db.Rnw:58-65
###################################################
FirstTenDOBimap <- DOTERM[1:10] ##grab thet ten
class(FirstTenDOBimap)
xx <- as.list(FirstTenDOBimap)
DOID(xx[[2]])
        Term(xx[[2]])
        Synonym(xx[[2]])
        Secondary(xx[[2]])


###################################################
### code chunk number 3: DO.db.Rnw:82-87
###################################################
xx <- as.list(DOANCESTOR)
# Remove DO IDs that do not have any ancestor
xx <- xx[!is.na(xx)] 
# Display the first 4 DOID's ancestor
xx[1:4]


###################################################
### code chunk number 4: DO.db.Rnw:98-103
###################################################
xx <- as.list(DOPARENTS)
# Remove DO IDs that do not have any ancestor
xx <- xx[!is.na(xx)] 
# Display the first 4 DOID's ancestor
xx[1:4]


###################################################
### code chunk number 5: DO.db.Rnw:117-122
###################################################
xx <- as.list(DOOFFSPRING)
# Remove DO IDs that do not have any ancestor
xx <- xx[!is.na(xx)] 
# Display the first 4 DOID's ancestor
xx[1]


###################################################
### code chunk number 6: DO.db.Rnw:135-140
###################################################
xx <- as.list(DOCHILDREN)
# Remove DO IDs that do not have any ancestor
xx <- xx[!is.na(xx)] 
# Display the first 4 DOID's ancestor
xx[1]


###################################################
### code chunk number 7: DO.db.Rnw:147-148
###################################################
DO_dbschema()


###################################################
### code chunk number 8: DO.db.Rnw:153-155
###################################################
DOMAPCOUNTS



