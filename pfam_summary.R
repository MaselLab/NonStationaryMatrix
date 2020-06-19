#Pfam summary file.

# This script is design to summarize the Pfam alignments in terms of alignment length
# (number of sites) and number of sequences. These summary data are then used by 
# the runtime_pfams.R script to estimate run time (along with the run time for each
# sequence from the raxml_parallel.R script).

# Load libraries.
library(plyr)
library(stringr)

# Load data.
align.data <- read.table("~/not_backed_up/alignments/Pfam_alignments_all_5-12-19.tsv", header = T,
                         sep = "\t")

# Number of sequences
pfam.seq.counts <- table(align.data[,2])

# Function for counting the number of sites in each alignment.
count.sites <- function(dataset,
                        pfamid.col = "PfamUID",
                        alignment.col = "AlignedPeptide"){
  alignment.summary <- ddply(dataset[, c(pfamid.col, alignment.col)], ~ PfamUID, summarise,
                             sites = mean(str_length(AlignedPeptide)))
  return(alignment.summary)
}

# Count number of sites.
num.sites <- count.sites(align.data)

# Begin building the summary.
pfam.summary <- data.frame(
  "PfamUID" = num.sites$PfamUID,
  "Sequences" = rep(NA, length(num.sites$PfamUID)),
  "Sites" = num.sites$sites
)

# Add in the number of sequences to the summary file.
for (i in 1:length(pfam.summary$PfamUID)) {
  pfam.summary[i, "Sequences"] <- pfam.seq.counts[pfam.summary$PfamUID[i]]
}

# save summary data. Un-comment the "write.table" line if you need to save the summary
# output from here.
#write.table(pfam.summary, file = "~/not_backed_up/alignments/pfam_summary.tsv", sep = "\t", quote = F, eol = "\n")
save.image("~/bin/Scripts/RScripts/pfam_summary.RData")