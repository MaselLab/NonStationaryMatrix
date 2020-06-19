# Run TreeFix in parallel. Similar to the raxml_parallel.R script, but runs TreeFix
# in parallel instead. Note that this script is run on ROOTED trees. RAxML does NOT
# output rooted trees; Notung needs to be run on the RAxML output in order to root the
# trees.

# Note: TreeFix is extremely annoying because it tries to guess at what the file
# names are supposed to be, rather than just letting you set those names. That is
# why there are settings for things like "name.start" because TreeFix will scan
# directories looking for files starting with particularly strings, and if it doesn't
# find them, it won't run.

# TreeFix also needs to be run from the correct directory. See my pbs scripts for
# what that directory is.

# Load necessary packages.
library(parallel)
library(stringr)

# Global variables. Comments are added to clarify what each variable is supposed to be.
working.dir <- "/extra/ljkosinski/Rooted/Pfam300/JTT_G/Reconciled/" # Working directory.
pfam.col <- "PfamUID" # Name of the PfamUID column in the Pfam summary data.
pfam.dir <- "/extra/ljkosinski/Alignments/Pfam300/" # Directory of all the pfam.fasta files.
raxml.dir <- "/extra/ljkosinski/Rooted/Pfam300/JTT_G/" # Directory with all the rooted RAxML trees.
name.start <- "RAxML_bipartitions" # The start of each RAxML tree, before the Pfam name. E.g. "RAxML_bipartitions.PF12345.rooting.0" would have "RAxML_bipartitions" as its name.start.
seqs.col <- "Sequences" # Name of the run time column in the Pfam summary data.
sites.col <- "Sites" # Name of the sites columnin the Pfam summary data.
treefix.cmd <- "treefix" # Self explanatory.
raxml.model <- "PROTGAMMAJTT" # The RAxML model to be used by treefix with -m.
treefix.seed <- "555" # Random seed used by TreeFix with -x.
#treefix.boot <- "100" # Number of bootstrap replicates with -b.
smap <- "/home/u31/ljkosinski/bin/treefix-1.1.10/Pfam.smap" # Location of the species tree domain tree mapping file. This file is a mapping from the species tree to the domain tree, and is required for TreeFix to run.
species.tree <- "/home/u31/ljkosinski/bin/treefix-1.1.10/SpeciesTree.nwk" #Location of the species tree.
out.pfam.summary.name <- "/extra/ljkosinski/Rooted/pfam_summary_treefix_10-7-19_seqs201-300.tsv" # Name of the updated pfam summary file to save.

# Change directory to working directory. This sets the directory to whatever directory
# you are running TreeFix from.
setwd(working.dir)

# Load Pfam summary data, which will be updated with run times.
load("/extra/ljkosinski/Scripts/RateShift/pfam_summary_9-13-19.RData")

# Function for making TreeFix alignment files, because it can't just read a fasta file.
fasta.folder <- list.files(pfam.dir) # Directory with all the fasta files.
raxml.folder <- list.files(raxml.dir) # Directory with all the rooted RAxML trees.

# Function to convert all alignment files into something TreeFix can read.
rename.move.alignment <- function(tree.name, new.dir){
  pfam.current <- str_match(tree.name, "PF[0-9]{5}")[1,1]
  print(pfam.current)
  pfam.fasta.current <- paste(pfam.dir, pfam.current, ".fasta", sep = "")
  print(pfam.fasta.current)
  pfam.renamed <- paste(name.start, pfam.current, "fasta.align", sep = ".")
  print(pfam.renamed)
  pfam.renamed.newdir <- paste(new.dir, pfam.renamed, sep = "")
  print(pfam.renamed.newdir)
  file.copy(pfam.fasta.current, pfam.renamed.newdir)
}

# TreeFix call function. Uses the settings designated above to call TreeFix.
treefix.call <- function(alignment.file){
  pfam <- str_match(alignment.file, "PF[0-9]{5}")[1,1]
  pfam.log <- paste(pfam, ".log", sep = "")
  pfam.align <- paste(".", pfam, ".fasta.align", sep = "")
  model.string <- paste("\"-m ", raxml.model, "\"", sep = "")
  alignment.dir <- alignment.file
  old.tree <- paste(".", pfam, ".rooting.0", sep = "")
  treefix.run <- paste(treefix.cmd, "-s", species.tree, "-S", smap, "-A", pfam.align,
                       "-o", old.tree, "-n .reconciled",
                       "-l", pfam.log,
                       "-e", model.string,
                       "-x", treefix.seed,
                       #"-b", treefix.boot,
                       "-V 1", alignment.dir)
  # Change to the right directory.
  dir.name <- paste(working.dir, pfam, "_treefix/", sep = "")
  change.dir <- paste("cd", dir.name)
  full.command <- paste(change.dir, "&&", treefix.run)
  system(full.command)
}

# Set seed.
set.seed(25)

# Make appropriate output folders and files for TreeFix.
new.raxml.folder <- rep(NA, length(raxml.folder))
for (i in 1:length(raxml.folder)) {
  PfamUID <- str_match(raxml.folder[i], "PF[0-9]{5}")[1,1]
  dir.name <- paste(working.dir, PfamUID, "_treefix/", sep = "")
  unlink(dir.name, recursive = T)
  dir.create(dir.name)
  raxml.tree <- paste(raxml.dir, raxml.folder[i], sep = "")
  file.copy(raxml.tree, dir.name)
  rename.move.alignment(raxml.tree, dir.name)
  new.raxml.tree <- paste(dir.name, raxml.folder[i], sep = "")
  new.raxml.folder[i] <- new.raxml.tree
}

# Run via parallel processing while making a new data frame of times.
pfam.times <- mclapply(new.raxml.folder, function(tree.rooted){
  print(tree.rooted)
  PfamUID <- str_match(tree.rooted, "PF[0-9]{5}")[1,1]
  print(PfamUID)
  # Call TreeFix and calculate run time.
  CPU_time <- system.time(treefix.call(tree.rooted))
  total_CPU_time <- CPU_time[[1]] + CPU_time[[2]] + CPU_time[[4]] + CPU_time[[5]]
  Sequences <- pfam.summary[pfam.summary[, pfam.col] == PfamUID, seqs.col]
  Sites <- pfam.summary[pfam.summary[, pfam.col] == PfamUID, sites.col]
  
  pfam.df <- data.frame(
    "PfamUID" = PfamUID,
    "Sequenes" = Sequences,
    "Sites" = Sites,
    "CPU_time" = total_CPU_time
  )
  setwd(working.dir)
  return(pfam.df)
},
mc.cores = 28)

pfam.times <- do.call(rbind, pfam.times)


write.table(pfam.times, file = out.pfam.summary.name, quote = F, sep = "\t")
