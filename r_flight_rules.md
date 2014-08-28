# R Flight Rules


<!-- toc -->

* [Data munging](#data-munging)
  * [Subsetting](#subsetting)
    * [Keeping/dropping columns by name](#keepingdropping-columns-by-name)

<!-- toc stop -->


# Data munging

## Subsetting
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

