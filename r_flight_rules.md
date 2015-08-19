# R Flight Rules


<!-- MarkdownTOC depth=3 autolink=true bracket=round -->

- [Data Profiling](#data-profiling)
	- [Quality](#quality)
		- [Completeness](#completeness)
- [Data munging](#data-munging)
	- [Subset of data frame](#subset-of-data-frame)
		- [Keeping/dropping columns by name](#keepingdropping-columns-by-name)
		- [Work on a subset of data frame using regular expression](#work-on-a-subset-of-data-frame-using-regular-expression)
	- [Arrange data frame columns](#arrange-data-frame-columns)
		- [Re-odering columns without specfying all of them](#re-odering-columns-without-specfying-all-of-them)

<!-- /MarkdownTOC -->

# Data Profiling
## Quality
### Completeness
percentage of elements properly populated e.g. testing for NULLs and empty strings where not appropriate


```r
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
```

```
##   fname lname age empty_string space_string missing_0 missing_1 missing_2
## 1   Bob  Dole  32                     hello         1         1         1
## 2 Sally   Doe  24        hello        world         2        NA        NA
## 3  John   Doe  28        world                      3         6        NA
## 4  Jane Smith  25                                   4         7         9
##   missing_3
## 1         1
## 2        NA
## 3        NA
## 4        NA
```


```r
# Count missing data across columns
apply(is.na(df), 2, sum)
```

```
##        fname        lname          age empty_string space_string
##            0            0            0            0            0
##    missing_0    missing_1    missing_2    missing_3
##            0            1            2            3
```

```r
# count missing data across rows
apply(is.na(df), 1, sum)
```

```
## [1] 0 3 2 1
```


```r
# na.omit() returns the object with listwise deletion of missing values.
na.omit(df)
```

```
##   fname lname age empty_string space_string missing_0 missing_1 missing_2
## 1   Bob  Dole  32                     hello         1         1         1
##   missing_3
## 1         1
```

```r
# complete.cases() returns a logical vector indicating which cases are complete.
df[complete.cases(df), ]
```

```
##   fname lname age empty_string space_string missing_0 missing_1 missing_2
## 1   Bob  Dole  32                     hello         1         1         1
##   missing_3
## 1         1
```


```r
# Inverted -- rows that have missing values
df[!complete.cases(df), ]
```

```
##   fname lname age empty_string space_string missing_0 missing_1 missing_2
## 2 Sally   Doe  24        hello        world         2        NA        NA
## 3  John   Doe  28        world                      3         6        NA
## 4  Jane Smith  25                                   4         7         9
##   missing_3
## 2        NA
## 3        NA
## 4        NA
```


```r
# frequency table of columns, counting NA values
lapply(X = df, FUN = table, useNA = 'always')
```

```
## $fname
##
##   Bob  Jane  John Sally  <NA>
##     1     1     1     1     0
##
## $lname
##
##   Doe  Dole Smith  <NA>
##     2     1     1     0
##
## $age
##
##   24   25   28   32 <NA>
##    1    1    1    1    0
##
## $empty_string
##
##       hello world  <NA>
##     2     1     1     0
##
## $space_string
##
##       hello world  <NA>
##     2     1     1     0
##
## $missing_0
##
##    1    2    3    4 <NA>
##    1    1    1    1    0
##
## $missing_1
##
##    1    6    7 <NA>
##    1    1    1    1
##
## $missing_2
##
##    1    9 <NA>
##    1    1    2
##
## $missing_3
##
##    1 <NA>
##    1    3
```

```r
# getting just the unique values from the columns
lapply(X = df, FUN = unique)
```

```
## $fname
## [1] "Bob"   "Sally" "John"  "Jane"
##
## $lname
## [1] "Dole"  "Doe"   "Smith"
##
## $age
## [1] 32 24 28 25
##
## $empty_string
## [1] ""      "hello" "world"
##
## $space_string
## [1] "hello" "world" " "
##
## $missing_0
## [1] 1 2 3 4
##
## $missing_1
## [1]  1 NA  6  7
##
## $missing_2
## [1]  1 NA  9
##
## $missing_3
## [1]  1 NA
```


```r
# get freq counts into a list where each element in a list is a dataframe
lapply(X = df, FUN = function(x){aggregate(data.frame(count = x), list(value = x), length)})
```

```
## $fname
##   value count
## 1   Bob     1
## 2  Jane     1
## 3  John     1
## 4 Sally     1
##
## $lname
##   value count
## 1   Doe     2
## 2  Dole     1
## 3 Smith     1
##
## $age
##   value count
## 1    24     1
## 2    25     1
## 3    28     1
## 4    32     1
##
## $empty_string
##   value count
## 1           2
## 2 hello     1
## 3 world     1
##
## $space_string
##   value count
## 1           2
## 2 hello     1
## 3 world     1
##
## $missing_0
##   value count
## 1     1     1
## 2     2     1
## 3     3     1
## 4     4     1
##
## $missing_1
##   value count
## 1     1     1
## 2     6     1
## 3     7     1
##
## $missing_2
##   value count
## 1     1     1
## 2     9     1
##
## $missing_3
##   value count
## 1     1     1
```

### Consistencty

```r
# generate sample dataframe
fname <- c('Bob', 'Sally', 'John', 'Jane')
g1 <- c('M', 'F', 'M', 'F')
g2 <- c('M', 'F', 'M', 'F')
g3 <- c('M', 'F', 'M', 'F')
g4 <- c('F', 'F', 'M', 'M')

df <- data.frame(fname, g1, g2, g3, g4, stringsAsFactors = FALSE)
df
```

```
##   fname g1 g2 g3 g4
## 1   Bob  M  M  M  F
## 2 Sally  F  F  F  F
## 3  John  M  M  M  M
## 4  Jane  F  F  F  M
```


```r
# looks for a pattern that begins with "g" followed by 1 other characters
columns <- grep(pattern = "g.?", x = names(df))

# use the columns that match the pattern to subset the data
all_g <- df[, columns]

# compares if the first element is the same across the entire row
all_same <- apply(X = all_g, MARGIN = 1, function(x){all(x[1] == x)})

# return rows where values are not the same across
different <- all_g[!all_same, ]

# number of different obervations
nrow(different)
```

```
## [1] 2
```


# Data munging
## Subset of data frame
### Keeping/dropping columns by name
Taken from [here](http://stackoverflow.com/questions/5234117/how-to-drop-columns-by-name-in-a-data-frame) and [here](http://stackoverflow.com/questions/4605206/drop-columns-r-data-frame)

```r
# Creating the data frame
fname <- c('Bob', 'Sally', 'John', 'Jane')
lname <- c('Dole', 'Doe', 'Doe', 'Smith')
age <- c(32, 24, 28, 25)
df <- data.frame(fname, lname, age)
df
```

```
##   fname lname age
## 1   Bob  Dole  32
## 2 Sally   Doe  24
## 3  John   Doe  28
## 4  Jane Smith  25
```


```r
# keeping columns by name
keep <- c('fname', 'age')
df[, names(df) %in% keep]
```

```
##   fname age
## 1   Bob  32
## 2 Sally  24
## 3  John  28
## 4  Jane  25
```


```r
# dropping columns by name
drop <- c('lname')
df[, !(names(df) %in% drop)]
```

```
##   fname age
## 1   Bob  32
## 2 Sally  24
## 3  John  28
## 4  Jane  25
```

### Work on a subset of data frame using regular expression
Sometimes you want to do some kind of calculation or munge on a aubset of a data frame.  For example, survey data might be coded q1a - q1k and you want to average the values, sum the values, look at the values, etc...


```r
# Create a data frame
q13 <- c(1:5)
q14a <- c(2:6)
q14b <- c(3:7)
q14c <- c(4:8)
q14z <- c(5:9)
df <- data.frame(q13, q14a, q14b, q14c, q14z)
df
```

```
##   q13 q14a q14b q14c q14z
## 1   1    2    3    4    5
## 2   2    3    4    5    6
## 3   3    4    5    6    7
## 4   4    5    6    7    8
## 5   5    6    7    8    9
```


```r
# regular expresstion for only sum q14a - q14c, do not include q14z
q14pattern <- '^q14[a-cA-C]'

# search the column names for a pattern match, return vector of column indices
q14columns <- grep(pattern = q14pattern, x = names(df))

# do something with the subset data, here I am summing the rows
df$q14.sum <- rowSums(x = df[, q14columns])
df
```

```
##   q13 q14a q14b q14c q14z q14.sum
## 1   1    2    3    4    5       9
## 2   2    3    4    5    6      12
## 3   3    4    5    6    7      15
## 4   4    5    6    7    8      18
## 5   5    6    7    8    9      21
```

We can also do a similar process to only look at the q14 variables

```r
q14patternAll <- '^q14'
q14columnsAll <- grep(pattern = q14patternAll, x = names(df))
head(df[, q14columnsAll], n = 2)
```

```
##   q14a q14b q14c q14z q14.sum
## 1    2    3    4    5       9
## 2    3    4    5    6      12
```

## Arrange data frame columns
### Re-odering columns without specfying all of them
When working with datasets with many columns, sometimes you just want to have
the key row identification variables together and in the beginning.  For example
if you are dealing with patient data, you may want the `id`, `dob`, and `gender`
as the first 3 rows, respectively, and not in arbitrary column positions in the data

To arrange columns by specfying all of them and/or just a subset, please see the
[cookbook](http://www.cookbook-r.com/Manipulating_data/Reordering_the_columns_in_a_data_frame/)
link and the
[dplyr vignette on `select()`](http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)

```r
# Create a dataframe example
df <- as.data.frame(matrix(c(1:20), ncol=10))
names(df)[c(3, 5, 7)] <- c("gender", "id", "dob")
df
```

```
##   V1 V2 gender V4 id V6 dob V8 V9 V10
## 1  1  3      5  7  9 11  13 15 17  19
## 2  2  4      6  8 10 12  14 16 18  20
```


```r
# we want to bring "id", "dob", and "gender" to the beginning, and keep
# everything else the way it is
toBeginning <- c("id", "dob", "gender")
df <- cbind(df[, toBeginning],
            df[, !names(df) %in% toBeginning])
df
```

```
##   id dob gender V1 V2 V4 V6 V8 V9 V10
## 1  9  13      5  1  3  7 11 15 17  19
## 2 10  14      6  2  4  8 12 16 18  20
```
