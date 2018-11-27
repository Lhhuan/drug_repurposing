# check select method for MeSHDb class"

my.keys    <- c("D000001")
my.columns <- c(
  "MESHID", "MESHTERM", "CATEGORY",
  "SYNONYM", "QUALIFIERID", "QUALIFIER" 
)
my.keytype <- c("MESHID", "CATEGORY", "QUALIFIERID")

results <- select(MeSH.db,
  keys    = my.keys,
  columns = my.columns,
  keytype = my.keytype
)

checkEquals(ncol(results), 6)
checkEquals(nrow(results), 135)
