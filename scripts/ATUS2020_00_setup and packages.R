#------------------------------------------------------------------------------------
# ATUS 2020 ANALYSIS
# ATUS2020_00_setup and packages.R
# Joanna R. Pepin
#------------------------------------------------------------------------------------
# setwd("C:/Users/Joanna/Dropbox/Repositories/ATUS_2020")
#####################################################################################
## Install and load required packages
#####################################################################################
# to load csv data files
if(!require(readr)){
  install.packages("readr")
  library(readr)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

# drop duplicate column names
if(!require(stringr)){
  install.packages("stringr")
  library(stringr)
}

if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
}

# To convert labels to factors
if(!require(sjlabelled)){
  install.packages("sjlabelled")
  library(sjlabelled)
}

# To generate a codebook
if(!require(sjPlot)){
  install.packages("sjPlot")
  library(sjPlot)
}

if(!require(survey)){
  install.packages("survey")
  library(survey)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(here)){
  install.packages("here")
  library(here)
}

if(!require(conflicted)){
  devtools::install_github("r-lib/conflicted")
  library(conflicted)
}

# Address any conflicts in the packages
conflict_scout() # Identify the conflicts
conflict_prefer("remove", "base")
conflict_prefer("filter", "dplyr")

#####################################################################################
# Download the data
#####################################################################################
## American Time Use Surveys
## Data can be accessed here: https://www.bls.gov/tus/data.htm
## Data import code assumes the researcher downloaded the Stata data files.
## Download and extract the American Time Use Survey-2003-2019 Microdata files
##  ATUS 2003-2019 Respondent file (zip)
##  ATUS 2003-2019 Roster file (zip)
##  ATUS 2003-2019 Activity summary file (zip) 
##  
## Download the American Time Use Survey-2020 Microdata files (available 07/23/2021)

respdata <- "atusresp_0319.dat"           # Name of the downloaded respondent data file
rostdata <- "atusrost_0319.dat"           # Name of the downloaded roster data file
actdata  <- "atusact_0319.dat"            # Name of the downloaded activity summary data file
cpsdata  <- "atuscps_0319.dat"            # Name of the downloaded activity CPS data file



#####################################################################################
# Set-up the Directories
#####################################################################################

projDir <- here()                                          # File path to this project's directory
dataDir <- "C:/Users/Joanna/Dropbox/Data/ATUS/ATUS0319"    # Name of folder where the ATUS data was downloaded

respDir <- file.path(dataDir, "atusresp_0319")             # Name of sub-folder where the respondent file was extracted
rostDir <- file.path(dataDir, "atusrost_0319")             # Name of sub-folder where the roster file was extracted
actDir  <- file.path(dataDir, "atusact_0319")              # Name of sub-folder where the activity file was extracted
cpsDir  <- file.path(dataDir, "atuscps_0319")              # Name of sub-folder where the CPS file was extracted


srcDir  <- "scripts"                              # Name of the sub-folder where we will save our source code (R scripts)
outDir  <- "output"                               # Name of the sub-folder where we will save tables/figures

## This will create sub-directory folders in the projDir if they don't exist
if (!dir.exists(here::here(srcDir))){
  dir.create(srcDir)
} else {
  print("SRC directory already exists!")
}

if (!dir.exists(here::here(outDir))){
  dir.create(outDir)
} else {
  print("Output directory already exists!")
}


message("End of ATUS2020_00_setup and packages") # Marks end of R Script
