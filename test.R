a=1:5
b=6:10

sum(a,b,x,y,z)
# ls lets you look at all objects in memory
ls()

# for the measurement vectors example in Udemy course on tidyverse;

set.seed(123)

measurement.a = c(rnorm(20), 22, rnorm(10), 54, rnorm(10))

measurement.b = c(rnorm(19, 5), NA, rnorm(10, 5), NA, rnorm(11, 5))

# missing value imputation from udemy course:
### Missing Data Handling



# Use FlowerPicks csv - remove ID column

summary(FlowerPicks)



# Vector with complete cases

compcases <- complete.cases(FlowerPicks) == T
# SN - this is an in-memory vector that classifies cases into complete and incomplete with true and false




# Per default R ignores missing data - na.action argument

boxplot(Score ~ Player,
        
        FlowerPicks)



lm(data = FlowerPicks, formula = Score ~ Time)
#SN - lm function is a linear model that also has built in na.action argument




# Using na.omit to remove al rows with an NA

cleandata <- na.omit(FlowerPicks)

summary(cleandata)

# Data lost several rows - only 5475 observations



# zoo for column wise operations
#SN- zoo was not isntalled, so call the install function to install it first before opening the library
install.packages("zoo")
library(zoo)

x = na.locf(FlowerPicks$Score)

summary(x)


## Machine Learning for NA removal
#SN - install mice package
install.packages("mice")

library(mice)

# Distribution of the missing values

md.pattern(FlowerPicks)

# 1 row has 2 NAs



# Using the mice function

install.packages("randomForest")
install.packages("lattices")
mymice <- mice(FlowerPicks, m = 10,
               
               method = "rf")



# The result has class mids

class(mymice)
#SN - this will diplay log information about the table mymice



# Display the calculated data

mymice$imp$Score
# this displays the 10 different imputed value options for each row with a missing value on variable score




# Fill the NAs

mymicecomplete <- complete(mymice, 5)

summary(mymicecomplete)



# Analysis with m variations of the dataset

lmfit <- with(mymice, lm(Score ~ Time))

# SN - the above creates 10 versions of the model since we have 10 version in the dataset mymice


# Pooling the results

summary(pool(lmfit))

#using pool function we can extract mean of the 10 values



## Outlier Detection: simple method for outlier calculation with ESD



# [mean - t * SD, mean + t * SD]

x = c(rnorm(10), 150); x
#SN - here we are creating a dataset with 10 random numbers and are plugging the 11th number (150) as an outlier

t = 3

m = mean(x)

s = sd(x)

b1 = m - s*t; b1 
b2 = m + s*t; b2

y = ifelse(x >= b1 & x <= b2, 0, 1); y  

plot(x, col=y+2)
#SN - providing a different color for y)

# simple boxplot

boxplot(x)

boxplot.stats(x)

# package outliers
install.packages("outliers")
library(outliers)

dixon.test(x)

grubbs.test(x, type = 11, two.sided = T) # type 11 for 2 sides, opossite

### advanced techniques for multivariate data
install.packages("mvoutlier")

library(mvoutlier)

elements = data.frame(Hg = moss$Hg, Fe = moss$Fe,  Al = moss$Al, Ni = moss$Ni) 
head(elements)

myout = sign1(elements[,1:4], qqcrit = 0.975); myout

myout = pcout(elements[,1:4])
head(myout)

plot(moss$Fe, moss$Al, col=myout$wfinal01+2)


