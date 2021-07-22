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
  group_by(year, gender) %>%
  summarize(predicted = survey_mean(hswrk, na.rm = TRUE, vartype = "ci"))

## Graph it
hswrk_fig <- hswrkavg %>%
  ggplot(aes(year, predicted, color = gender, label = gender)) +
  geom_line() +
  geom_point() +
  geom_dl(method = list("last.points", hjust = -.3, vjust = 1, cex = 1, fontface = "bold")) +
  scale_x_continuous(limits = c(2003, 2022), breaks = c(2005, 2010, 2015, 2020)) +
  scale_y_continuous(limits = c(50, 175)) +
theme_minimal(14) +
theme( legend.position   = "none",
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      plot.margin        = unit(c(1.5,1.5,2,1.5),"cm")) +
  labs( x        = " ", 
        y        = " ", 
        fill     = " ",
        title    = "Daily minutes of housework increased during 2020",
        subtitle = "Due to COVID-19 pandemic, 2020 data range: May 10th - December 31st",
        caption  = "American Time Use Surveys 2003-2020 | Joanna Pepin") 


hswrk_fig

ggsave(filename = file.path(outDir, "hswrk_fig.png"), hswrk_fig, width=9, height=6, units="in", dpi=300)


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


