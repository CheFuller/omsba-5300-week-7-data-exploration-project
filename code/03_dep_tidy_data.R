## Load libraries
#source("../code/01_dep_load_libraries.R")

## Read in data files
#source("../code/02_dep_read_data.R")

## Start performing tidy data

# First, we'll create a new dataframe for the id name scorecards and call it 
# scorecd_id_name. We'll accomplish this by merging the recent_cohorts and 
# id_name_link dataframes together by both unit ID (UNITID) and ope ID (OPEID).

scorecd_id_name <- merge(x = id_name_link, y = recent_cohorts,
                        by = c("UNITID", "OPEID"), all.x = TRUE)

# Next, create another data frame for the college scorecard through merging 
# the scorecd_id_name dataframe with our compile_data dataframe by 
# school name (SCHNAME). This will give us a more comprehensive spreadsheet 
# to work with.

coll_scorecd <- merge(x = scorecd_id_name, y = compile_data,
                      by = "SCHNAME", all.x = TRUE) %>% na.omit()

# Now that we have our college scorecard (coll_scorecd) let's clean it up some
# more by mutating and selecting specific variables to make it easier for modeling

# Isolate the first ten characters of the MONTHORWEEK variable to make it easier
# to work with the date (DATE) associated with each observation

coll_scorecd_bs <- coll_scorecd %>%
  rename(MEDEARN10 = 'MD_EARN_WNE_P10-REPORTED-EARNINGS') %>%
  filter(PREDDEG == 3) %>%
  filter(MEDEARN10 != 'NULL') %>%
  filter(MEDEARN10 != 'PrivacySuppressed') %>%                                 # filter out any cells with NULL and PrivacySuppressed
  mutate(MEDEARN10 = as.numeric(MEDEARN10))%>%
  mutate(DATE = substr(MONTHORWEEK, 1, 10)) %>%
  mutate(DATE = as.Date(DATE))

coll_scorecd_bs <- coll_scorecd_bs %>%
  select('UNITID', 'OPEID', 'SCHNAME', 'PREDDEG', 'CONTROL',
         'LOCALE', 'KEYWORD', 'KEYNUM', 'MONTHORWEEK', 'INDEX',
         'WOMENONLY', 'MENONLY', 'HBCU', 'MEDEARN10')

# MEDIAN: Calculate value for median of all median earnings of graduates 10 years after
# graduation for each college (MEDEARN10) to define threshold for high-earnings 
# vs. low-earnings

median_earning <- median(coll_scorecd_bs$MEDEARN10)                            # median threshold is $41,800

# STANDARDIZED VARIABLES: To better make a direct comparison for this analysis, let's convert our independent 
# variable (INDEX) and dependent variable (MEANEARN10) to measures of standard deviations from their means, 
# creating a new data frame which groups them by their key number (KEYNUM)then summarizes them.

standardized_var <- coll_scorecd_bs %>%
  mutate(SD_INDEX = (INDEX - mean(INDEX))/sd(INDEX))%>%                        # create new variable for standardizing independent variable, INDEX
  group_by(KEYNUM) %>%
  summarise(KEYNUM, SCHNAME, KEYWORD, SD_INDEX, INDEX, CONTROL,
            MONTHORWEEK, MEDEARN10)

  
# Add high earnings (HIGHEARN) binary variable to standardized_var data frame. 
# For all median earnings above threshold HIGHEARN = 1, else HIGHEARN = 0. 

standardized_var$HIGHEARN <- ifelse(standardized_var$MEDEARN10 >= median_earning, 1, 0)     #dummy variable


# Data frame to look at data prior to September 1, 2015
pre_sep2015 <- standardized_var %>%
  mutate(DATE = substr(MONTHORWEEK, 1, 10)) %>%
  mutate(DATE = as.Date(DATE)) %>%
  filter(DATE < '2015-09-01')


# Data frame to look at data starting September 1, 2015 and after
post_sep2015 <- standardized_var %>%
  mutate(DATE = substr(MONTHORWEEK, 1, 10)) %>%
  mutate(DATE = as.Date(DATE)) %>%
  filter(DATE >= '2015-09-01')

# Create data frames for both high and low earnings before Sept 2015
model_presept15 <- standardized_var
model_presept15 <- model_presept15 %>%
  mutate(DATE = substr(MONTHORWEEK, 1, 10)) %>%
  mutate(DATE = as.Date(DATE))

model_presept15$pre_sept15 <- ifelse(model_presept15$DATE >= '2015-09-01', 1, 0)

highearn_presept2015 <- pre_sept15 %>%
  filter(HIGHEARN == 1) %>%
  filter(AfterS15 == 1)

lowearn_presept2015 <- pre_sept15 %>%
  filter(High_Earn == 0) %>%
  filter(AfterS15 == 1)