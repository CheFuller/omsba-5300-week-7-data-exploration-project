## Read in data

# read in Most Recent Cohorts Scorecard
recent_scrcrd <- read_csv("../Lab3_Rawdata/Most+Recent+Cohorts+(Scorecard+Elements).csv")

# read in ID Name Link and rename UNITID and OPEID to unitid and opeid, respectively.
name_link <- read_csv("../Lab3_Rawdata/id_name_link.csv") %>%
  rename(UNITID = unitid) %>%
  rename(OPEID = opeid)%>%
  distinct(schname, .keep_all = TRUE)

# get the list of "trends_up_to" .csv files
file_list <- list.files(path = "../Lab3_Rawdata/", pattern = "trends_up_to_", full.names = TRUE)

process_file <- function(filename){
  paste('../Lab3_Rawdata/', filename, sep = '')
  
}

compile_data <- file_list %>%
  map(process_file)%>%
  map(read_csv) %>%
  bind_rows()