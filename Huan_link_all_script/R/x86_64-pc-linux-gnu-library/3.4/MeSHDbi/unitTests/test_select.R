# check select method for MeSHDb class"

.MeSHDb <- setRefClass("MeSHDb", contains="AnnotationDb")

.dbconn <- RSQLite::dbConnect(
            RSQLite::SQLite(),
            paste0(
              system.file(c("inst", "DBschemas"), package="MeSHDbi"),
              "/MeSH.XXX.eg.db.sqlite"
            )
          )

obj <- .MeSHDb$new(conn=.dbconn, packageName="test")

checkEquals(length(is(obj)), 8)
