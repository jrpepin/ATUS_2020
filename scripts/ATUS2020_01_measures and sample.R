#------------------------------------------------------------------------------------
# ATUS 2020 ANALYSIS
# ATUS2020_01_measures and sample.R
# Joanna R. Pepin
#------------------------------------------------------------------------------------

# This file creates the variables for analysis and then the analytic sample.

#####################################################################################
# Prep the data for analysis
#####################################################################################

# Load the data ---------------------------------------------------------------------
col_types <- readr::cols(.default = readr::col_character()) # load all as character for appending

## Load the ATUS0319 data
atus.resp0319 <- read_csv(file.path(respDir0319, respdata0319), col_types=col_types)  
atus.rost0319 <- read_csv(file.path(rostDir0319, rostdata0319), col_types=col_types)
atus.act0319  <- read_csv(file.path(actDir0319,  actdata0319),  col_types=col_types)
atus.cps0319  <- read_csv(file.path(cpsDir0319,  cpsdata0319),  col_types=col_types)

## Load the ATUS2020 data
atus.resp2020 <- read_csv(file.path(respDir2020, respdata2020), col_types=col_types)
atus.rost2020 <- read_csv(file.path(rostDir2020, rostdata2020), col_types=col_types)
atus.act2020  <- read_csv(file.path(actDir2020,  actdata2020),  col_types=col_types)
atus.cps2020  <- read_csv(file.path(cpsDir2020,  cpsdata2020),  col_types=col_types)

### harmonize key activity variable
  ### janitor::compare_df_cols(atus.act0319, atus.act2020)
  ### rename activity column to match
atus.act2020 <- atus.act2020 %>%
  rename(TRCODEP = TRCODE)

# Combine the separated data files --------------------------------------------------

atus.resp <- bind_rows(atus.resp0319, atus.resp2020) %>% 
  readr::type_convert()

atus.rost <- bind_rows(atus.rost0319, atus.rost2020) %>% 
  readr::type_convert()

atus.act <- bind_rows(atus.act0319, atus.act2020) %>% 
  readr::type_convert()

atus.cps <- bind_rows(atus.cps0319, atus.cps2020) %>% 
  readr::type_convert()

## Clean up data objects
remove("col_types", 
       "atus.resp0319", "atus.resp2020",
       "atus.rost0319", "atus.rost2020",
       "atus.act0319",  "atus.act2020",
       "atus.cps0319",  "atus.cps2020")

# Prep the data ---------------------------------------------------------------------

## change variable case to lower
atus.resp <-  atus.resp %>% 
  rename_all(tolower)

atus.rost <-  atus.rost %>% 
  rename_all(tolower)

atus.act <-  atus.act %>% 
  rename_all(tolower)

atus.cps <-  atus.cps %>% 
  rename_all(tolower)

# ROSTER DATA -----------------------------------------------------------------------

## RESEPONDENT AGE
atus.rost$teage[atus.rost$teage < 0]   <- NA # replace missing data

atus.rost <- atus.rost %>%
  mutate(
    rage = case_when(
      terrp == 18 | terrp == 19   ~ teage,
      TRUE                        ~ -1),
    rfemale = case_when(
      (terrp == 18 | terrp == 19) & 
       tesex == 2                 ~ 1,
      TRUE                        ~ 0),
    pfemale = case_when(
      (terrp == 20 | terrp == 21) & 
       tesex == 2                 ~ 1,
      TRUE                        ~ 0
    ))
    
    
## CREATE NUMBER OF KID INDICATORS
atus.rost <- atus.rost %>%
    mutate(
      # KID UNDER 2
      kidu2 = case_when( 
        terrp == 22 & teage <2 	|  
        terrp == 27 & teage <2     ~ 1,
        TRUE                       ~ 0),
      # KID 2-5
      kid2to5 = case_when( 
        (terrp == 22 & teage >=2) & (terrp == 22 & teage<=5)	|  
        (terrp == 27 & teage >=2) & (terrp == 27 & teage<=5)  ~ 1,
        TRUE                                                  ~ 0),
      # KID 6-12
      kid6to12 = case_when( 
        (terrp == 22 & teage >=6) & (terrp == 22 & teage<=12)	|  
        (terrp == 27 & teage >=6) & (terrp == 27 & teage<=12)  ~ 1,
        TRUE                                                   ~ 0
        ))

## CREATE LIVING ARRANGEMENTS

### This takes a LONG time to run. Marking some variables out that aren't primary focuse
atus.rost <- atus.rost %>%
  mutate(
    self        = case_when(terrp   == 18 | terrp == 19 ~ 1, TRUE ~ 0),
    spouse      = case_when(terrp   == 20               ~ 1, TRUE ~ 0),
    cohab       = case_when(terrp   == 21               ~ 1, TRUE ~ 0),
    hhchild     = case_when(terrp   == 22               ~ 1, TRUE ~ 0),
    hhchildu18  = case_when(hhchild == 1  & teage <  18 ~ 1, TRUE ~ 0),
    hhchildo18  = case_when(hhchild == 1  & teage >= 18 ~ 1, TRUE ~ 0),
    hhchildu13  = case_when(hhchild == 1  & teage <  12 ~ 1, TRUE ~ 0),
    allchildu13 = case_when(teage   <  12               ~ 1, TRUE ~ 0),
#   grandchild  = case_when(terrp   == 23               ~ 1, TRUE ~ 0),
    parent      = case_when(terrp   == 24               ~ 1, TRUE ~ 0),
    sibling     = case_when(terrp   == 25               ~ 1, TRUE ~ 0),
    siblingo18  = case_when(terrp   == 25 & teage >= 18 ~ 1, TRUE ~ 0),
    otherrel    = case_when(terrp   == 26               ~ 1, TRUE ~ 0),
#   foster      = case_when(terrp   == 27               ~ 1, TRUE ~ 0),
#   roommate    = case_when(terrp   == 28               ~ 1, TRUE ~ 0),
#   boarder     = case_when(terrp   == 29               ~ 1, TRUE ~ 0),
#   nonrel      = case_when(terrp   == 30               ~ 1, TRUE ~ 0),
#   notinhh     = case_when(terrp   == 40               ~ 1, TRUE ~ 0),
    exfam       = case_when(hhchildo18 == 1 | 
                            parent     == 1 | 
                            siblingo18 == 1 | 
                            otherrel   == 1            ~ 1, TRUE ~ 0))

## NUMBER IN HOUSEHOLD
atus.rost <- atus.rost %>%
  group_by(tucaseid) %>%
  mutate(numterrp = n())

## NUMBER OF HOUSEHOLD CHILDREN
atus.rost$numberhhchild <- atus.rost$hhchild

atus.rost <- atus.rost %>%
  group_by(tucaseid) %>%
  mutate(numberhhchild = n())

## AGGREGATE DATA 

atus.rost <- atus.rost %>%
  select(tucaseid, rage, rfemale, pfemale, kidu2, kid2to5, kid6to12,
         self, spouse, cohab, hhchild, hhchildu18, hhchildo18, 
         hhchildu13, allchildu13, parent, sibling, siblingo18,
#         grandchild, otherrel, foster, roommate, boarder, nonrel, notinhh, 
         exfam, numterrp, numberhhchild) %>%
  group_by(tucaseid) %>% 
  summarise_all(list(~max(.)))


save(atus.rost,file=file.path(outDir, "atus.rost.Rda")) # saving because this takes a LONG time to run
     load(file.path(outDir, "atus.rost.Rda"))

# ACTIVITY DATA -----------------------------------------------------------------------

# Activity summary variables by person
atus.act <- atus.act %>%
    rename(activity = trcodep,
           duration = tuactdur24)
     
atus.act$activity <- as.numeric(atus.act$activity)

# Childcare
ccare <- atus.act$activity %in% 
c(030100:030400, 080100:080200, 180381)
     
# Housework
hswrk <- atus.act$activity %in% 
c(020101:030000, 080200:080300, 080700:080800, 090100:100000, 160106, 070101, 180701, 180904, 180807, 180903, 080699, 160106)
     
# Leisure
leisure <- atus.act$activity %in% 
c(120100:130000, 130100:140000, 160101, 160102, 181200:181400)
     
# Sleep
sleep <- atus.act$activity %in% 
c(010101)

# Leisure sub-types
socl <- atus.act$activity %in% 
c(120100:120200, 120200:120300, 120400:120500, 120501, 120502, 120504, 120599, 130200:130300, 130302, 130402)
     
actl   <- atus.act$activity %in% 
c(120307, 120309:120313, 130100:130200, 130301, 130401, 130499)
     
pass   <- atus.act$activity %in% 
c(120301:120306, 120308, 120399, 120503)
     
# Television
tele   <- atus.act$activity %in% 
c(120303, 120304)
     
atus.act$actcat<-NA
atus.act$actcat[ccare]   <- "child care"
atus.act$actcat[hswrk]   <- "housework"
atus.act$actcat[leisure] <- "leisure"
atus.act$actcat[sleep]   <- "sleep"
atus.act$actcat <- as.character(atus.act$actcat)
     
atus.act$leiscat<-NA
atus.act$leiscat[socl] <- "social leisure"
atus.act$leiscat[actl] <- "active leisure"
atus.act$leiscat[pass] <- "passive leisure"
atus.act$leiscat <- as.character(atus.act$leiscat)

atus.act$telecat<-NA
atus.act$telecat[tele] <- "television"
atus.act$telecat <- as.character(atus.act$telecat)

## Create summary activity variables
atus.act <- atus.act %>%
  group_by(tucaseid) %>%
  summarise (leisure  = sum(duration[actcat ==  "leisure"],    na.rm=TRUE),
             sleep    = sum(duration[actcat ==  "sleep"],      na.rm=TRUE),
             hswrk    = sum(duration[actcat ==  "housework"],  na.rm=TRUE),
             ccare    = sum(duration[actcat ==  "child care"], na.rm=TRUE)) %>%
  inner_join(atus.act, by='tucaseid')


# Leisure activity variables
atus.act <- atus.act %>%
  group_by(tucaseid) %>%
  summarise (socl     = sum(duration[leiscat ==  "social leisure"],      na.rm=TRUE),
             actl     = sum(duration[leiscat ==  "active leisure"],      na.rm=TRUE),
             pass     = sum(duration[leiscat ==  "passive leisure"],     na.rm=TRUE)) %>%
  inner_join(atus.act, by='tucaseid')

# Television variables
atus.act <- atus.act %>%
  group_by(tucaseid) %>%
  summarise (tele     = sum(duration[telecat ==  "television"],          na.rm=TRUE)) %>%
  inner_join(atus.act, by='tucaseid')

## AGGREGATE DATA 
atus.act <- atus.act %>%
  select(tucaseid, tele, socl, actl, pass, ccare, hswrk, leisure, sleep) %>%
  group_by(tucaseid) %>% 
  summarise_all(list(~max(.)))

## MERGE DATA ------------------------------------------------------------
atus.all <- atus.rost %>%
  left_join(atus.cps %>% filter(tulineno==1), by = c("tucaseid")) %>%
  left_join(atus.resp, by = c("tucaseid")) %>%
  left_join(atus.act,  by = c("tucaseid"))

## remove duplicate columns
atus.all <- atus.all %>% 
  rename_at(
    vars(ends_with(".x")),
    ~str_replace(., "\\..$","")
  ) %>% 
  select_at(
    vars(-ends_with(".y"))
  )
   

#####################################################################################
# Respondent variables
#####################################################################################

# Gender ---------------------------------------------------------------------------
atus.all  <- atus.all  %>%
  mutate(
    gender = case_when(
      rfemale == 0   ~ "Men",
      rfemale == 1   ~ "Women",
      TRUE         ~ NA_character_
    ))

atus.all$gender <- factor(atus.all$gender, levels = c("Men", "Women"))

## Partner gender
atus.all  <- atus.all  %>%
  mutate(
    spsex = case_when(
      pfemale == 0   ~ "Men",
      pfemale == 1   ~ "Women",
      TRUE         ~ NA_character_
    ))

atus.all$spsex <- factor(atus.all$spsex, levels = c("Men", "Women"))


# Age -------------------------------------------------------------------------------
atus.all <- atus.all %>%
  rename(age = rage)
summary(atus.all$age)

# Race
atus.all <- atus.all %>%
  mutate(
    raceth = case_when(
      ptdtrace   == 1 & pehspnon == 2  ~ "White",
      ptdtrace   == 2 & pehspnon == 2  ~ "Black",
      ptdtrace   == 4 & pehspnon == 2  ~ "Asian",
      pehspnon   == 1                  ~ "Hispanic",
      TRUE                             ~ "Other"
      ))

atus.all$raceth <- factor(atus.all$raceth, levels = c("White", "Black", "Hispanic", "Asian", "Other"))

# Education -------------------------------------------------------------------------
atus.all <- atus.all %>%
  mutate(
    educ = case_when(
      (peeduca >= 31 & peeduca <= 38)   ~ "Less than high school",
      (peeduca == 39)                   ~ "High school",
      (peeduca >= 40 & peeduca <= 42)   ~ "Some college",
      (peeduca >= 43 & peeduca <= 46)   ~ "BA or higher",
      TRUE                              ~  NA_character_
    ))

atus.all$educ <- factor(atus.all$educ, levels = c("Less than high school", "High school", "Some college", "BA or higher"))

# Employment -----------------------------------------------------------------------

atus.all <- atus.all %>%
  mutate(
    unemployed  = case_when(pemlr      >= 3                 ~ 1, TRUE ~ 0),
    parttime    = case_when(prhrusl    == 1 | prhrusl  == 2 | 
                            prhrusl    == 8                 ~ 1, TRUE ~ 0),
    fulltime    = case_when(prhrusl    >= 3 & prhrusl  <= 7 ~ 1, TRUE ~ 0),
    employ      = case_when(fulltime   == 1                 ~ "Fulltime",
                            parttime   == 1                 ~ "Parttime",
                            unemployed == 1                 ~ "Unemployed",
                            TRUE                            ~ NA_character_))

atus.all$employ <- factor(atus.all$employ, levels = c("Fulltime", "Parttime", "Unemployed"))


# Kid under 2 -----------------------------------------------------------------------
atus.all <- atus.all %>%
  mutate(
    kidu2 = case_when(
      kidu2 ==1 ~ "Child < 2",
      kidu2 ==0 ~ "No children < 2"
    ))

atus.all$kidu2 <- as_factor(atus.all$kidu2)

# Child under 13 -----------------------------------------------------------------------
atus.all <- atus.all %>%
  mutate(
    hhchildu13 = case_when(
      hhchildu13 ==1 ~ "Child < 13",
      hhchildu13 ==0 ~ "No children < 13"
    ))

atus.all$hhchildu13 <- as_factor(atus.all$hhchildu13)

# Number of own HH kids ------------------------------------------------------------
summary(atus.all$numberhhchild)

# Partner Presence -----------------------------------------------------------------

atus.all <- atus.all %>%
  mutate(
    spousepres = case_when(
      trsppres == 1    ~ "Married",
      trsppres == 2    ~ "Cohabiting",
      trsppres == 3    ~  "Single" 
    ))

atus.all$spousepres <- factor(atus.all$spousepres, levels = c("Married", "Cohabiting", "Single"))

# Marital Status.all -------------------------------------------------------------------
## The information on the atus.all-CPS file was collected 2 to 5 months before the atus.all interview.

atus.all <- atus.all %>%
  mutate(
    marst = case_when(
      pemaritl  == 1    ~ "Married - spouse present",
      pemaritl  == 2    ~ "Married - spouse absent",
      pemaritl  == 3    ~ "Widowed",
      pemaritl  == 4    ~ "Divorced",
      pemaritl  == 5    ~ "Separated",
      pemaritl  == 6    ~ "Never married",
      
    ))

atus.all$marst <- factor(atus.all$marst, levels = c("Married - spouse present", "Married - spouse absent", 
                                            "Widowed", "Divorced", "Separated", "Never married"))


# Relationship Status.all ---------------------------------------------------------------
## Use this variable -- combine marital status.all and partner presence at time of atus.all interview

atus.all <- atus.all %>%
  mutate(
    relate = case_when(
      spousepres  == "Cohabiting"               ~ "Cohabiting",
      marst       == "Never married"            & 
      spousepres  == "Single"                   ~ "Never married",
      spousepres  == "Married"                  ~ "Married",
      TRUE                                      ~ "Divorced/Separated/Widowed"
      ))
      
atus.all$relate <- factor(atus.all$relate, levels = c("Married", "Cohabiting", 
                                            "Never married", "Divorced/Separated/Widowed"))

# Same-sex partners -----------------------------------------------------------------
atus.all <- atus.all %>%
  mutate(
    samesex = case_when(
      (spsex == "Men"   & gender == "Men")   |
      (spsex == "Women" & gender == "Women") ~ "Same sex partners",
      (spsex == "Men"   & gender == "Women") |
      (spsex == "Women" & gender == "Men")   ~ "Different sex partners",
      TRUE                                ~  NA_character_ 
    ))

atus.all$samesex <- factor(atus.all$samesex, levels = c("Different sex partners", "Same sex partners"))


# Extended Family Member ------------------------------------------------------------
atus.all <- atus.all %>%
  mutate(
    exfam = case_when(
      exfam ==1 ~ "Extra adults",
      exfam ==0 ~ "No extra adults"
      ))
    
atus.all$exfam <- factor(atus.all$exfam, levels = c("No extra adults", "Extra adults"))


# Weekend --------------------------------------------------------------------------

atus.all  <- atus.all  %>%
  mutate(
    weekend = case_when(
      tudiaryday == 1   | 
        tudiaryday == 7   ~ "Weekend",
      TRUE              ~ "Weekday"
    ))

atus.all$weekend <- factor(atus.all$weekend, levels = c("Weekday", "Weekend"))

# Survey weights ---------------------------------------------------------------------
atus.all  <- atus.all  %>%
  mutate(
    svyweight = case_when(
      tuyear != 2020   ~ tufnwgtp,
      tuyear == 2020   ~ tu20fwgt
    ))

# Year & Month -----------------------------------------------------------------------
## pandemic time use data range: May 10th through December 31st.
### 01/2020 - 04/2020 -- 2019
### 05/2020 - 12/2020 -- 2020

atus.all <- atus.all %>%
  mutate(year = case_when(
    tuyear != 2020 ~ tuyear,
    tuyear == 2020 & tumonth <  5 ~ 2019,
    tuyear == 2020 & tumonth >= 5 ~ 2020
  ))

#####################################################################################
# SELECT VARIABLES
#####################################################################################

atus0320 <- atus.all %>%
  select(tucaseid, year, svyweight,
         tele, socl, actl, pass, 
         ccare, hswrk, leisure, sleep,
         weekend, exfam, samesex, relate, 
         kidu2, hhchildu13, numberhhchild,
         employ, educ, raceth, age, gender)

save(atus0320,file=file.path(outDir, "atus0320.Rda"))
load(file.path(outDir, "atus0320.Rda"))


# Sample selection
# atus <- filter(atus, sex == "Women") # women
# atus <- filter(atus, spsex == "Male" | spsex == "NIU") # Different sex couples or singles
# atus <- filter(atus, raceth != "Asian" & raceth != "Other") # white, black, and Hispanic

parents <- filter(atus0320, numberhhchild >=1) # parents
parents <- filter(parents, hhchildu13 == "Child < 13") # mothers of kids younger than 13
parents <- filter(parents, age >= 18 & age <=54) # prime working age

## Clean up data objects
remove("atus.resp", 
       "atus.rost", 
       "atus.act", 
       "atus.cps")

