## Read in data

# read in Most Recent Cohorts Scorecard
recent_cohorts <- read_csv("../Lab3_Rawdata/Most+Recent+Cohorts+(Scorecard+Elements).csv") %>%
  rename_with(toupper)                               # Capitalize all recent_cohorts variable names

# read in ID Name Link and rename UNITID, OPEID, SCHNAME from unitid, opeid, and schname, respectively.
id_name_link <- read_csv("../Lab3_Rawdata/id_name_link.csv") %>%
  rename_with(toupper) %>%                           # Capitalize all compile_data variable names
  distinct(SCHNAME, .keep_all = TRUE)

# get the list of "trends_up_to" .csv files
file_list <- list.files(path = "../Lab3_Rawdata/", 
                        pattern = "trends_up_to_", 
                        full.names = TRUE)
file_list # verify a list of 12 files

process_file <- function(filename){
  # this function reads in the list of "trends_up_to_" files
  paste('../Lab3_Rawdata/', filename, sep = '')
  
}

compile_data <- file_list %>%
  map(process_file)%>%                              # process "trends_up_to_" files
  map(read_csv) %>%                                 # read in file contents
  bind_rows() %>%
  rename_with(toupper)                              # Capitalize all compile_data variable names
