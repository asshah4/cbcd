#!/usr/bin/env Rscript

# Model parameters
nsims  <- 1e3
n      <- 1e4
ncores <- 8L

# Function to simulate pi
simpi <- function(i) {
	  
	  p <- matrix(runif(n*2, -1, 1), ncol = 2)
  mean(sqrt(rowSums(p^2)) <= 1) * 4
	  
}

# Setting up slurmR
library(slurmR) # This also loads the parallel package
opts_slurmR$set_opts(partition="cpu-t3")

# Making the cluster, and exporting the variables
cl <- makeSlurmCluster(ncores)

# Approximation
clusterExport(cl, c("n", "simpi"))
ans <- parSapply(cl, 1:nsims, simpi)

# Closing connection
stopCluster(cl)

message("Pi: ", mean(ans))

saveRDS(ans, "03-parsapply-slurmr.rds")
