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

if(!require(janitor)){
  install.packages("janitor")
  library(janitor)
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

if(!require(srvyr)){
  install.packages("srvyr")
  library(srvyr)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(ggeffects)){
  install.packages("ggeffects")
  library(ggeffects)
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

respdata0319 <- "atusresp_0319.dat"       # Name of the downloaded ATUS0319 respondent data file
rostdata0319 <- "atusrost_0319.dat"       # Name of the downloaded ATUS0319 roster data file
actdata0319  <- "atusact_0319.dat"        # Name of the downloaded ATUS0319 activity summary data file
cpsdata0319  <- "atuscps_0319.dat"        # Name of the downloaded ATUS0319 activity CPS data file

respdata2020 <- "atusresp_2020.dat"       # Name of the downloaded ATUS2020 respondent data file
rostdata2020 <- "atusrost_2020.dat"       # Name of the downloaded ATUS2020 roster data file
actdata2020  <- "atusact_2020.dat"        # Name of the downloaded ATUS2020 activity summary data file
cpsdata2020  <- "atuscps_2020.dat"        # Name of the downloaded ATUS2020 activity CPS data file


#####################################################################################
# Set-up the Directories
#####################################################################################

projDir <- here()                                              # File path to this project's directory
dataDir0319 <- "C:/Users/Joanna/Dropbox/Data/ATUS/ATUS0319"    # Name of folder where the ATUS0319 data was downloaded
dataDir2020 <- "C:/Users/Joanna/Dropbox/Data/ATUS/ATUS2020"    # Name of folder where the ATUS2020 data was downloaded

respDir0319 <- file.path(dataDir0319, "atusresp_0319")         # Name of sub-folder where the ATUS0319 respondent file was extracted
rostDir0319 <- file.path(dataDir0319, "atusrost_0319")         # Name of sub-folder where the ATUS0319 roster file was extracted
actDir0319  <- file.path(dataDir0319, "atusact_0319")          # Name of sub-folder where the ATUS0319 activity file was extracted
cpsDir0319  <- file.path(dataDir0319, "atuscps_0319")          # Name of sub-folder where the ATUS0319 CPS file was extracted

respDir2020 <- file.path(dataDir2020, "atusresp_2020")         # Name of sub-folder where the ATUS2020 respondent file was extracted
rostDir2020 <- file.path(dataDir2020, "atusrost_2020")         # Name of sub-folder where the ATUS2020 roster file was extracted
actDir2020  <- file.path(dataDir2020, "atusact_2020")          # Name of sub-folder where the ATUS2020 activity file was extracted
cpsDir2020  <- file.path(dataDir2020, "atuscps_2020")          # Name of sub-folder where the ATUS2020 CPS file was extracted


# Steal the 2020 survey weight for 2019
respdata0320 <- "atusresp_0320.dat"                            # Name of the downloaded ATUS0320 respondent data file
dataDir0320  <- "C:/Users/Joanna/Dropbox/Data/ATUS/ATUS0320"   # Name of folder where the ATUS0320 data was downloaded
respDir0320  <- file.path(dataDir0320, "atusresp_0320")        # Name of sub-folder where the ATUS0320 respondent file was extracted

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
