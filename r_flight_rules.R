#' ---
#' title: "R Flight Rules"
#' output:
#'   html_document:
#'     keep_md: yes
#'     number_sections: yes
#'     toc: yes
#' ---
#' <!-- toc -->
## ----echo=FALSE----------------------------------------------------------
library(knitr)

#' 
#' # Data Profiling
#' ## Quality
#' ### Completeness
#' percentage of elements properly populated e.g. testing for NULLs and empty strings where not appropriate
#' 
## ------------------------------------------------------------------------
# Creating the data frame
fname <- c('Bob', 'Sally', 'John', 'Jane')
lname <- c('Dole', 'Doe', 'Doe', 'Smith')
age <- c(32, 24, 28, 25)
empty_string <- c('', 'hello', 'world', '')
space_string <- c('hello', 'world', ' ', ' ')
missing_0 <- c(1, 2, 3, 4)
missing_1 <- c(1, NA, 6, 7)
missing_2 <- c(1, NA, NA, 9)
missing_3 <- c(1, NA, NA, NA)
df <- data.frame(fname, lname, age, empty_string, space_string,
                 missing_0, missing_1, missing_2, missing_3, stringsAsFactors = FALSE)
df

#' 
## ------------------------------------------------------------------------
# Count missing data across columns
apply(is.na(df), 2, sum)

# count missing data across rows
apply(is.na(df), 1, sum)

#' 
## ------------------------------------------------------------------------
# na.omit() returns the object with listwise deletion of missing values.
na.omit(df)

# complete.cases() returns a logical vector indicating which cases are complete.
df[complete.cases(df), ]

#' 
## ------------------------------------------------------------------------
# Inverted -- rows that have missing values
df[!complete.cases(df), ]

#' 
## ------------------------------------------------------------------------
# frequency table of columns, counting NA values
lapply(X = df, FUN = table, useNA = 'always')

# getting just the unique values from the columns
lapply(X = df, FUN = unique)

#' 
## ------------------------------------------------------------------------
# get freq counts into a list where each element in a list is a dataframe
lapply(X = df, FUN = function(x){aggregate(data.frame(count = x), list(value = x), length)})

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
#' ## Arrange data frame columns
#' ### Re-odering columns without specfying all of them
#' When working with datasets with many columns, sometimes you just want to have
#' the key row identification variables together and in the beginning.  For example
#' if you are dealing with patient data, you may want the `id`, `dob`, and `gender`
#' as the first 3 rows, respectively, and not in arbitrary column positions in the data
#' 
#' To arrange columns by specfying all of them and/or just a subset, please see the
#' [cookbook](http://www.cookbook-r.com/Manipulating_data/Reordering_the_columns_in_a_data_frame/)
#' link and the 
#' [dplyr vignette on `select()`](http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)
## ------------------------------------------------------------------------
# Create a dataframe example
df <- as.data.frame(matrix(c(1:20), ncol=10))
names(df)[c(3, 5, 7)] <- c("gender", "id", "dob")
df

#' 
## ------------------------------------------------------------------------
# we want to bring "id", "dob", and "gender" to the beginning, and keep
# everything else the way it is
toBeginning <- c("id", "dob", "gender")
df <- cbind(df[, toBeginning],
            df[, !names(df) %in% toBeginning])
df

#' 
#' 
## ---- echo=FALSE, results='hide', message=FALSE, warning=FALSE-----------
# generate .R from .Rmd withought using a Makefile
purl("r_flight_rules.Rmd", output = "r_flight_rules.R", documentation = 2)

#' 
