## Read in data

# read in Most Recent Cohorts Scorecard
recent_cohorts <- read_csv("../Lab3_Rawdata/Most+Recent+Cohorts+(Scorecard+Elements).csv")

# read in ID Name Link and rename UNITID, OPEID, SCHNAME from unitid, opeid, and schname, respectively.
id_name_link <- read_csv("../Lab3_Rawdata/id_name_link.csv") %>%
  rename(UNITID = unitid) %>%
  rename(OPEID = opeid)%>%
  rename(SCHNAME = schname) %>%
  distinct(SCHNAME, .keep_all = TRUE)

# get the list of "trends_up_to" .csv files
file_list <- list.files(path = "../Lab3_Rawdata/", 
                        pattern = "trends_up_to_", 
                        full.names = TRUE)
file_list # verify a list of 12 files

process_file <- function(filename){
  paste('../Lab3_Rawdata/', filename, sep = '')
  
}

compile_data <- file_list %>%
  map(process_file)%>%
  map(read_csv) %>%
  bind_rows()
