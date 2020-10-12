#!/usr/local/bin/Rscript
library(plumber)

# sourcing predict.R
source("predict.R")

# Setup scoring function
serve <- function() {
    app <- plumb(file='plumber.R', dir=".")
    app$run(host='0.0.0.0', port=8080)
}

# Run at start-up
args <- commandArgs()
if (any(grepl('serve', args))) {
    serve()
}