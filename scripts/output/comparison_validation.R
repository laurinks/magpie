# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: Creates an validation pdf out of several runs
# comparison script: TRUE
# ---------------------------------------------------------------

library(mip)
library(magpie4)
library(gms)

############################# BASIC CONFIGURATION #############################
if(!exists("source_include")) {
  outputdir    <-"."
}
hist    <- "input/validation.mif"
file    <- paste0("comparison_validation_",format(Sys.time(), "%Y%H%M%S"),".pdf")
###############################################################################

x <- NULL; i <- 1
for(outputdir in outputdirs) {
  config <- file.path(outputdir,"config.yml")
  if(file.exists(config)) {
    cfg <- gms::loadConfig(config)
    title <- cfg$title
  } else {
    title <- paste0("run",i)
  }
  gdx <- paste0(outputdir_x, "/fulldata.gdx")
  if(!is.null(x)) {
    scenarios <- getNames(x,dim=2)
    if(title %in% scenarios) {
      title <- tail(make.unique(c(scenarios,title),sep=""),n=1)
    }
  }
  tmp <- getReport(gdx, scenario=sub(".","_",title,fixed = TRUE))
  x <- mbind(x,tmp)
  i <- i+1
}

validationpdf(x=x, hist=hist, file = file, style="comparison")
