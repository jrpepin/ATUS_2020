#------------------------------------------------------------------------------------
# ATUS 2020 ANALYSIS
# ATUS2020_02_analyses & figures.R
# Joanna R. Pepin
#------------------------------------------------------------------------------------

# This file analyzes the date and creates descriptive figures.

#####################################################################################
# WEIGHTED AVERAGES
#####################################################################################

# Housework ------------------------------------------------------------------------

## Weighted data
hswrk_svy <- atus0320 %>% 
  as_survey_design(id = tucaseid,
                   weights = svyweight)

## Create weighted yearly averages
hswrkavg <- hswrk_svy %>%
  group_by(year, relate) %>%
  summarize(predicted = survey_mean(hswrk, na.rm = TRUE, vartype = "ci"))

## Graph it
hswrkavg %>%
  ggplot(aes(year, predicted, color = relate)) +
  geom_line() +
  geom_point() +
  theme_minimal()


#####################################################################################
# LINEAR MODELS
#####################################################################################

# Housework ------------------------------------------------------------------------

## Run linear model
lm_hswrk <- lm(hswrk  ~ relate + year + weekend, data = atus0320, weight=svyweight)

## Created predicted averages
phswrk   <- ggeffect(lm_hswrk, terms = c("year", "relate"))

## Graph it
phswrk %>%
  ggplot(aes(x, predicted, color = group)) +
  geom_line() +
  theme_minimal()


