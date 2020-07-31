# Run RAxML in parallel.

# This script runs RAxML on a folder of sequence alignments and outputs phylogenetic trees
# in the folder it is called from.

# NOTE: Make sure this script is called from within the folder you want the output saved to!

# NOTE: There is a problem with this script. RAxML will not run if it sees RAxML output files
# in the folder it is supposed to save to. That means that if this script is run on windfall and
# booted off, RAxML will not finish any of the phylogenies it was currently working on when
# it was booted off windfall. The simplest solution to this problem would be to set RAxML to
# overwrite its own output files, but currently there does not appear any way to set RAxML to
# do this. Another possible fix would be to set a check in this script for RAxML output files
# before calling RAxML, and to remove those output files.

# Load necessary packages.
library(parallel)

# Global variables. The RAxML settings and size requirements are here. See the comment after
# each variable for a description of each of these settings.
pfam.col <- "PfamUID" # Name of the PfamUID column in the Pfam summary data.
pfam.dir <- "/extra/ljkosinski/Alignments/Pfam300/" # Directory of all the pfam.fasta files.
seqs.col <- "Sequences" # Name of the run time column in the Pfam summary data.
sites.col <- "Sites" # Name of the sites columnin the Pfam summary data.
raxml.cmd <- "/home/u31/ljkosinski/bin/standard-RAxML/raxmlHPC-AVX" # location of the RAxML command.
raxml.model <- "PROTGAMMAJTT" # The model to be used by RAxML with -m.
raxml.alg <- "a" # The algorithm RAxML will use with -f.
raxml.seed <- "555" # Random seed used by RAxML with -x and -p.
raxml.boot <- "100" # Number of bootstrap replicates with -N.
out.folder <- "" # Output folder location for RAxML to save files in.
out.pfam.summary.name <- "/extra/ljkosinski/Alignments/pfam_summary_update_9-13-19_seqs_201-300.tsv" # Name of the updated pfam summary file to save.
max.seqs <- 300 # Used for subsetting the data. Running RAxML on everything will take way too long!
#max.sites <- 100 # Used for subsetting the data.
min.seqs <- 200 # Used for subsetting the data.
#min.sites <- 10 # Used for subsetting the data.

# Load Pfam summary data, which will be updated with run times.
# Note that there are two options here. One is a tsv file, and the other is an R data space.
# Use whichever has the most up-to-date Pfam summary.
#pfam.summary <- read.table(file = "/extra/ljkosinski/Alignments/pfam_summary.tsv",
#                           header = T, sep = "\t")
load("/extra/ljkosinski/Scripts/RateShift/pfam_summary_9-13-19.RData")

# RAxML call function. Print commands are useful for debugging, but should be commented out
# before running on a large data set to save time.
raxml.call <- function(pfam, pfam.table = pfam.summary){
  pfam.fasta <- paste(pfam.dir, pfam, ".fasta", sep = "")
  #print(pfam.fasta)
  pfam.out <- paste(out.folder, pfam, sep = "")
  #print(pfam.out)
  raxml.run <- paste(raxml.cmd, "-f", raxml.alg, "-s", pfam.fasta,
                     "-n", pfam.out, "-m", raxml.model, "-p",
                     raxml.seed, "-x", raxml.seed, "-N", raxml.boot)
  #print(paste(raxml.cmd, "-f", raxml.alg, "-s", pfam.fasta,
  #                   "-n", pfam.out, "-m", raxml.model, "-p",
  #                   raxml.seed, "-x", raxml.seed, "-N", raxml.boot))
  system(raxml.run)
}

# Subset the data. This command ensures RAxML is only run on the alignments that meet the
# are in the directory. The commented out text is if you want to run files that meet size
# requirements (just make sure all of these are in the directory you're pulling from.

# The following three lines are for getting the PFAM IDs from the directory you want.
# Comment these out if you are using size requirements instead.
library(stringr)
files.dir <- list.files(path = pfam.dir, pattern = "PF")
pfam.ids.dir <- str_match(string = files.dir, pattern = "PF[0-9]+")

pfam.subset <- pfam.summary[
  # The following two lines are if you are subsetting based on size requirements.
  #pfam.summary[, seqs.col] > min.seqs & pfam.summary[, seqs.col] <= max.seqs
  #& pfam.summary[, sites.col] > min.sites & pfam.summary[, sites.col] <= max.sites
  pfam.col %in% pfam.ids.dir
  ,
  pfam.col]
#print(pfam.subset)

# Set random seed for reproducible results.
set.seed(25)

# Run via parallel processing while making a new data frame of times.
# This script calls RAxML using the settings set at the beginning of the script and
# outputs a data frame of run times.
pfam.times <- mclapply(pfam.subset, function(pfam){
  
  PfamUID <- pfam
  CPU_time <- system.time(raxml.call(pfam))
  total_CPU_time <- CPU_time[[1]] + CPU_time[[2]] + CPU_time[[4]] + CPU_time[[5]]
  #print(PfamUID)
  #print(CPU_time)
  #print(total_CPU_time)
  Sequences <- pfam.summary[pfam.summary[, pfam.col] == pfam, seqs.col]
  #print(Sequences)
  Sites <- pfam.summary[pfam.summary[, pfam.col] == pfam, sites.col]
  #print(Sites)

  pfam.df <- data.frame(
    "PfamUID" = PfamUID,
    "Sequenes" = Sequences,
    "Sites" = Sites,
    "CPU_time" = total_CPU_time
  )
  return(pfam.df)
},
mc.cores = 28)

pfam.times <- do.call(rbind, pfam.times)


write.table(pfam.times, file = out.pfam.summary.name, quote = F, sep = "\t")
