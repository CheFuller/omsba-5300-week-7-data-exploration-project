## Load libraries
#source("../code/01_dep_load_libraries.R")

## Read in data files
#source("../code/02_dep_read_data.R")

## Load tidy date
#source("../code/04_dep_tidy_data")

## Perform regressions and modeling

#####################################################################
# BASE MODEL: Bivariate OLS regresssing median earnings             #
# (MEDEARN10) on standardized index (SD_INDEX)                      #                  
#####################################################################

model_base <- lm(MEDEARN10 ~ SD_INDEX, data = standardized_var)

ggplot(data = model_base, aes(x = SD_INDEX, y = MEDEARN10)) + 
geom_smooth() + 
labs(x = "Standardized Index", y = "Median Earnings",
     title = "Student Interest vs. Median  Earnings of Grads (Base Model)")

####################################################################
# MODEL 1 & 2: Bivariate OLS regressing median earnings (MEDEARN10)#
# on standardized index (INDEX) prior to September 1, 2015         #
####################################################################

model_01 <- lm(MEDEARN10 ~ SD_INDEX, data = pre_sep2015)
model_02 <- lm(MEDEARN10 ~ SD_INDEX, data = post_sep2015) 
export_summs(model_01, model_02)


ggplot(data = model_01, aes(x = SD_INDEX, y = MEDEARN10)) +
  geom_smooth() + 
  labs(x = "Standardized Index", y = "Median Earnings",
       title = "Student Interest vs. Median  Earnings of Grads (Model 1: Before Sept 2015)")

ggplot(data = model_02, aes(x = SD_INDEX, y = MEDEARN10)) +
  geom_smooth() + 
  labs(x = "Standardized Index", y = "Median Earnings",
       title = "Student Interest vs. Median  Earnings of Grads (Model 2: After Sept 2015)")

########################################################################
# MODEL 3 & 4: Multivariate OLS regressing median earnings (MEDEARN10) #
# on standardized index (SD)INDEX) with controls on CONTROL, HIGHEARN, #
# and DATE as well as a polynomial term on HIGHEARN for both high      #
# earnings and low earnings before September 2015, respectively        #
########################################################################

# After performing the base models regressing median earnings on standardized index,
# the graphs had indicated that the graphs were nonlinear. Although nonlinear, between 
# pre_sept15 regression (model_01) and post_sept15 (model_02), model_01 looked better than model_02.
# Therefore, I had decided to use model_01 and expand on it by adding multiple controls 
# (i.e. CONTROL, HIGHEARN, and DATE) and a polynomial term to figure out how the variables may effect
# the MEDEARN10 and if high earnings (HIGHEARN) follows a polynomial. Hopefully, improving the regression model.
# improve the regression on model_01.

model_03 <- lm(MEDEARN10 ~ SD_INDEX + CONTROL + HIGHEARN + I(HIGHEARN^2) + DATE, data = highearn_presept2015)
model_04 <- lm(MEDEARN10 ~ SD_INDEX + CONTROL + HIGHEARN + I(HIGHEARN^2) + DATE, data = lowearn_presept2015)
export_summs(model_03, model_04)

# The average median earning for graduates who graduated from all colleges before September 1, 2015
# was $43,519.98. With a one unit increase in keywords indexed before September 1, 2015, there is an __ increase of student interest of 
# 

ggplot(data = model_03, aes(x = SD_INDEX, y = MEDEARN10)) +
  geom_smooth() + 
  labs(x = "Standardized Index", y = "High Earnings",
       title = "Student Interest vs. High  Earnings of Grads (Model 3: Before Sept 2015)")

ggplot(data = model_04, aes(x = SD_INDEX, y = MEDEARN10)) +
  geom_smooth() + 
  labs(x = "Standardized Index", y = "Low Earnings",
       title = "Student Interest vs. Low  Earnings of Grads (Model 4: Before Sept 2015)")

