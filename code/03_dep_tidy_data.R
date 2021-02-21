## Load libraries
source("../code/01_dep_load_libraries.R")

## Read in data files
source("../code/02_dep_read_data.R")

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
                      by = "SCHNAME", all.x = TRUE)