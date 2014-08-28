# R Flight Rules

This has been inspired by [k88hudson](https://github.com/chendaniely/git-flight-rules)

Where she quotes:

Flight rueles are a [guide for astronauts](http://www.jsc.nasa.gov/news/columbia/fr_generic.pdf) (now, people using R) about what to do when things go wrong (when you need something done).

>  *Flight Rules* are the hard-earned body of knowledge recorded in manuals that list, step-by-step, what to do if X occurs, and why. Essentially, they are extremely detailed, scenario-specific standard operating procedures. [...]

> NASA has been capturing our missteps, disasters and solutions since the early 1960s, when Mercury-era ground teams first started gathering "lessons learned" into a compendium that now lists thousands of problematic situations, from engine failure to busted hatch handles to computer glitches, and their solutions.

&mdash; Chris Hadfield, *An Astronaut's Guide to Life*.

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

