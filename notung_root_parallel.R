# Notung root parallel.

# NOTE: This script does not actually call Notung. Instead, it makes a batch file
# to be used when calling Notung. This script needs to be updated to call Notung so
# Notung does not need to be called manually.

# Just need to make a batch file for rooting. No parallel call in R is needed!
# First line needs to be the species tree, and then the next lines need to be
# the correct RAxML tree to root.
todays.date <- "10-7-19"
folder.name <- "Pfam300"
output.name <- paste("/extra/ljkosinski/Rooted/raxml_", folder.name, "_", todays.date, ".batch", sep = "")
species.tree <- "/extra/ljkosinski/Trees/SpeciesTree.nwk" # Location of the species tree.
raxml.trees.folder <- paste("/extra/ljkosinski/Trees/", folder.name, "/JTT_G/", sep = "") # Location of the RAxML domain trees.

# Get RAxML files from directory.
raxml.files <- list.files(raxml.trees.folder)

# Get domain trees with branch weights.
raxml.trees <- raxml.files[grep("bipartitions\\.", raxml.files)]
raxml.trees <- paste(raxml.trees.folder, raxml.trees, sep = "")

# Make batch list.
raxml.batch <- c(species.tree, raxml.trees)

# Write batch list to file.
write(raxml.batch, file = output.name, sep = "\n")
