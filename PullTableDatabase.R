# Pulling a table from a MariaDB database that's too large for Navicat.
# Currently, this script is set up to pull all the Pfam alignments from the database.
# Note: this script needs to be run from Fusion, where the database is.

# Setting the working directory.
setwd("~/not_backed_up/alignments")

# Loading necessary libraries.
library(odbc)
library(RMariaDB)
library(DBI)

# Setting up the MariaDB connction. Username, password, host, and dbname (database
# name) required.
cnx <- dbConnect(
  drv = RMariaDB::MariaDB(),
  username = 'ljkosinski',
  password = '',
  host = '127.0.0.1',
  dbname = 'PFAMphylostratigraphy',
  port = 3306
)
cnx

# Storing all the alignment data.
# Selects all Pfam alignments. Note that "n = Inf" means there is no limit to the
# number of rows pulled.
alignments <- dbSendQuery(cnx, "SELECT * FROM PfamAlignments")
align.data <- dbFetch(alignments, n = Inf)

# Exporting alignment data to a not backed up folder. This will be a large file.
# Note: Fusion is not backed up anymore. It is our backup!
write.table(align.data, file = "~/not_backed_up/alignments/Pfam_alignments_all_8-26-19.tsv",
            sep = "\t")

# Disconnect from database.
dbDisconnect(cnx)
