## #############################################################################
## SURVEY
##
## Downloads the Class Survey data and creates data sets to manage it.
##
## #############################################################################


## INIT ========================================================================
library(dplyr)
library(googlesheets)
library(lubridate)
library(tidyr)
library(tibble)

## DOWNLOAD ====================================================================
gs_ls()  ## authenticates using httpuv
survey <- gs_title("Intro to Data: Class Survey (Responses)")
survey <- gs_read(survey)

## COLUMN NAMES  -------------------------------------------
column_names <- names(survey)

names <- c("time_stamp",
           "initials",
           "dob",
           "gender",
           "home_state",
           "school_year",
           "degree",
           "career",
           "like_math",
           "good_counter",
           "algebra_quiz",
           "ever_analyzed",
           "tools",
           "why_course",
           "what_worries",
           "world_series",
           "why_questions")

## Use this to make sure your column names line up.
## ALWAYS QA your work!
## data.frame(column_names, names)

names(survey) <- names

## COLUMN FORMATS ------------------------------------------
survey$dob           <- mdy(survey$dob)
survey$age           <- round((today() - survey$dob)/365.25,0)
survey$gender        <- factor(survey$gender, levels = c("Female",
                                                         "Male",
                                                         "Non-binary",
                                                         "Prefer not to say"))
survey$school_year   <- factor(survey$school_year, levels = c(1,2,3,4,5,6,7,8,9,10))
survey$degree        <- factor(survey$degree, levels = c("Biomedical Technology",
                                                         "Clinical Laboratory Sciences",
                                                         "Microbiology",
                                                         "Pharmaceutical Sciences",
                                                         "Public Health",
                                                         "Pre-Med",
                                                         "Pre-PA",
                                                         "Other"))
survey$career        <- factor(survey$career, levels = c("That's possible?",
                                                         "No",
                                                         "Maybe",
                                                         "Yes",
                                                         "Already have the job."))
survey$like_math     <- factor(survey$like_math, levels = c("No",
                                                            "Yes",
                                                            "How do I drop this course?"))
survey$good_counter  <- factor(survey$good_counter, levels = c("No",
                                                               "Yes",
                                                               "Are you kidding? That's a question?"))
survey$algebra_quiz  <- factor(survey$algebra_quiz, levels = c("0","1","2","3","4","5","6","?"))
survey$ever_analyzed <- factor(survey$ever_analyzed, levels = c("What is data?",
                                                                "No",
                                                                "Maybe?",
                                                                "Kinda",
                                                                "Yes",
                                                                "Daily"))
survey$why_questions <- factor(survey$good_counter, levels = c("No",
                                                                  "Yes"))


## TRANSFORM -----------------------------------------------

survey$tools <- gsub("Database/SQL (Any)", "Database/SQL", survey$tools)
survey$tools <- gsub("Excel (Or: Google Sheets, LibreOffice Calc, etc.)", "Excel", survey$tools)
survey$tools <- gsub("SPSS (Or: PSPP)", "SPSS", survey$tools)

tools <-
    survey %>%
    select(time_stamp, initials, tools) %>%
    transform(tools=strsplit(tools, split=",")) %>%
    unnest(tools) %>%
    select(time_stamp, initials, ans=tools) %>%
    distinct()

tools$ans <- factor(tools$ans, levels=c("Database/SQL",
                                        "Excel",
                                        "JMP",
                                        "Julia",
                                        "KNIME",
                                        "Maple",
                                        "Mathematica",
                                        "Matlab",
                                        "Orange",
                                        "Python",
                                        "R",
                                        "Rapid Miner",
                                        "SAS",
                                        "SPSS",
                                        "Tableau",
                                        "Other"))


## SAVE ========================================================================
save(list = c("column_names", "survey", "tools"), file = 'data/survey.rda')
