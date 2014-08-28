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
#' ## Subset of data frame
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
#' ### Work on a subset of data frame using regular expression
#' Sometimes you want to do some kind of calculation or munge on a aubset of a data frame.  For example, survey data might be coded q1a - q1k and you want to average the values, sum the values, look at the values, etc...
#' 
## ------------------------------------------------------------------------
# Create a data frame
q13 <- c(1:5)
q14a <- c(2:6)
q14b <- c(3:7)
q14c <- c(4:8)
q14z <- c(5:9)
df <- data.frame(q13, q14a, q14b, q14c, q14z)
df

#' 
## ------------------------------------------------------------------------
# regular expresstion for only sum q14a - q14c, do not include q14z
q14pattern <- '^q14[a-cA-C]'

# search the column names for a pattern match, return vector of column indices
q14columns <- grep(pattern = q14pattern, x = names(df))

# do something with the subset data, here I am summing the rows
df$q14.sum <- rowSums(x = df[, q14columns])
df

#' 
#' We can also do a similar process to only look at the q14 variables
## ------------------------------------------------------------------------
q14patternAll <- '^q14'
q14columnsAll <- grep(pattern = q14patternAll, x = names(df))
head(df[, q14columnsAll], n = 2)

#' 
#' 
#' 
## ----, echo=FALSE, results='hide', message=FALSE, warning=FALSE----------
# generate .R from .Rmd withought using a Makefile
purl("r_flight_rules.Rmd", output = "r_flight_rules.R", documentation = 2)

#' 
