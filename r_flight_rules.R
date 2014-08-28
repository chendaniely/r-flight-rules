#' ---
#' title: "R Flight Rules"
#' output:
#'   html_document:
#'     keep_md: yes
#'     number_sections: yes
#'     toc: yes
#' ---
#' <!-- toc -->
## ----,echo=FALSE---------------------------------------------------------
library(knitr)

#' 
#' # Data munging
#' 
#' ## Subsetting
#' ### Keeping/dropping columns by name
#' Taken from [here](http://stackoverflow.com/questions/5234117/how-to-drop-columns-by-name-in-a-data-frame) and [here](http://stackoverflow.com/questions/4605206/drop-columns-r-data-frame)
## ------------------------------------------------------------------------
# Creating the data frame
fname <- c('Bob', 'Sally', 'John', 'Jane')
lname <- c('Dole', 'Doe', 'Doe', 'Smith')
age <- c(32, 24, 28, 25)
df <- data.frame(fname, lname, age)
df

#' 
## ------------------------------------------------------------------------
# keeping columns by name
keep <- c('fname', 'age')
df[, names(df) %in% keep]

#' 
## ------------------------------------------------------------------------
# dropping columns by name
drop <- c('lname')
df[, !(names(df) %in% drop)]

#' 
## ----, echo=FALSE, results='hide', message=FALSE, warning=FALSE----------
# generate .R from .Rmd withought using a Makefile
purl("r_flight_rules.Rmd", output = "r_flight_rules.R", documentation = 2)

#' 
