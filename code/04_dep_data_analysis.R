## Load libraries
#source("../code/01_dep_load_libraries.R")

## Read in data files
#source("../code/02_dep_read_data.R")

## Load tidy date
#source("../code/04_dep_tidy_data")

## Perform regressions and modeling

## Perform regressions and modeling


#####################################################################
# BASE MODEL & GRAPH: Bivariate OLS regresssing median earnings     #
# (MEDEARN10) on index (INDEX)                                      #
#####################################################################

model_base <- lm(MEDEARN10 ~ INDEX, data = standardized_var)
effect_plot(model_base, pred = "INDEX", plot.points = TRUE)

####################################################################
# MODEL 1 & 2: Bivariate OLS regressing median earnings (MEDEARN10)#
# on index (INDEX) prior to September 1, 2015
####################################################################

model_01 <- lm(MEDEARN10 )
# 

####################################################################
# MODEL 1: Multivariate OLS regressing median earnings 
