#------------------------------------------------------------------------------------
# ATUS 2020 ANALYSIS
# ATUS2020_02_analyses & figures.R
# Joanna R. Pepin
#------------------------------------------------------------------------------------

# This file analyzes the date and creates descriptive figures.

# Specific chores  ------------------------------------------------------------------------

## Weighted data
### using only 2019 and 2020 data from May - December due to survey weights
atus1920 <- parents %>% ## only people living with a child younger than 13 years old
  filter(!is.na(yeardum))

atus1920_svy <- atus1920 %>% 
  as_survey_design(id = tucaseid,
                   weights = tu20fwgt)


## Create weighted yearly averages
laundry <- atus1920_svy %>%
  filter(yeardum == 2019 | yeardum == 2020) %>%
  group_by(yeardum, gender) %>%
  summarize(minutes = survey_mean(laundry, na.rm = TRUE, vartype = "ci"))

dishes <- atus1920_svy %>%
  filter(yeardum == 2019 | yeardum == 2020) %>%
  group_by(yeardum, gender) %>%
  summarize(minutes = survey_mean(dishes, na.rm = TRUE, vartype = "ci"))

grocery <- atus1920_svy %>%
  filter(yeardum == 2019 | yeardum == 2020) %>%
  group_by(yeardum, gender) %>%
  summarize(minutes = survey_mean(grocery, na.rm = TRUE, vartype = "ci"))

laundry$activity <- "laundry"
dishes$activity  <- "dishes"
grocery$activity <- "grocery shopping"

hswrk <- rbind(laundry, dishes, grocery)
hswrk$yeardum <-as.character(hswrk$yeardum)


## Graph it
chores <- hswrk %>%
  ggplot(aes(gender, minutes, fill = yeardum)) +
  geom_col(width = 0.7, position   =  position_dodge(.8)) +
  facet_grid(~activity) +
  geom_errorbar(aes(ymin=minutes_low, ymax=minutes_upp), width=.2,
                position=position_dodge(.8), color="grey") +
  theme_minimal(14) +
  geom_text(. %>% filter(activity  == "dishes" & gender == "Women"), 
            mapping  = aes(label   =  yeardum, 
                           color    = yeardum,
                           y        = 19.5),
            position = position_dodge(.8),
            size     = 4,
            fontface = "bold") +
  geom_text(mapping  = aes(label=round(minutes, digits = 0)), 
            position = position_dodge(width=0.8), 
            vjust    = -.8,
            hjust    = -.35,
            color    = "#000000",
            size     = 3) +
    theme( legend.position   = "none",
         panel.grid.minor.x = element_blank(),
         panel.grid.minor.y = element_blank(),
         plot.margin        = unit(c(1.5,1.5,2,1.5),"cm"),
         strip.text.x  = element_text(face = "bold")) +
  labs( x        = " ", 
        y        = " ", 
        fill     = " ",
        title    = "Daily minutes of ________ before and during the COVID19 pandemic",
        subtitle = "Among 18-54 year old parents living with a child less than 13 years old",
        caption  = "American Time Use Surveys 2019-2020 | Joanna Pepin \nDue to COVID-19 pandemic, data range: May through December in 2019 vs. 2020") 


chores

ggsave(filename = file.path(outDir, "chores.png"), chores, width=9, height=6, units="in", dpi=300)




#####################################################################################
# LINEAR MODELS
#####################################################################################

# Housework ------------------------------------------------------------------------

## Run linear model
lm_dishes <- lm(dishes  ~ yeardum + gender + weekend, data = parents, weight=tu20fwgt)

## Created predicted averages
pdishes   <- ggeffect(lm_dishes, terms = c("yeardum", "gender"))
pdishes$yeardum <-as.character(pdishes$x)

## Graph it
pdishes %>%
  ggplot(aes(group, predicted, fill = yeardum)) +
  geom_col(width = 0.7, position   =  position_dodge(.8)) +
  theme_minimal()


#####################################################################################
# Trends over time
#####################################################################################

## Weighted data
atus0320_svy <- atus0320 %>% 
  as_survey_design(id = tucaseid,
                   weights = svyweight)

### THESE ANALYSES USE WEIGHT VARIABLES THAT ARE NOT HARMONIZED WITH 2020.
### INTERPRET WITH CAUTION

# Housework ------------------------------------------------------------------------

## Create weighted yearly averages
hswrkavg <- atus0320_svy %>%
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


# Childcare ------------------------------------------------------------------------

## Weighted data
par0320_svy <- parents %>% 
  as_survey_design(id = tucaseid,
                   weights = svyweight)


## Create weighted yearly averages
ccareavg <- par0320_svy %>%
  group_by(year, gender) %>%
  summarize(predicted = survey_mean(ccare, na.rm = TRUE, vartype = "ci"))

## Graph it
ccare_fig <- ccareavg %>%
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
        title    = "Daily minutes of childcare during 2020",
        subtitle = "Due to COVID-19 pandemic, 2020 data range: May 10th - December 31st",
        caption  = "American Time Use Surveys 2003-2020 | Joanna Pepin") 


ccare_fig

ggsave(filename = file.path(outDir, "ccare_fig.png"), ccare_fig, width=9, height=6, units="in", dpi=300)
