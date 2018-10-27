# R commands to get answers for week 3 quiz


# Q1: In this dataset (iris), what is the mean of 'Sepal.Length' for the species virginica?
library(datasets)
data(iris)

sepal.length <- iris[iris$Species == "virginica", ][["Sepal.Length"]]
mean(sepal.length)


# Q2: What R code returns a vector of the means of the variables 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'?
library(datasets)
data(iris)

apply(iris[, 1:4], 2, mean)


# Q3: How can one calculate the average miles per gallon (mpg) by number of cylinders in the car (cyl)?
library(datasets)
data(mtcars)

with(mtcars, tapply(mpg, cyl, mean))
# or
tapply(mtcars$mpg, mtcars$cyl, mean)


# Q4: What is the absolute difference between the average horsepower of 4-cylinder cars and the average horsepower of 8-cylinder cars?
library(datasets)
data(mtcars)

average.hps <- with(mtcars, tapply(hp, cyl, mean))
abs(average.hps["4"] - average.hps["8"]) 


# Q5: If you run debug(ls), what happens when you next call the 'ls' function?
# --> Execution of 'ls' will suspend at the beginning of the function and you will be in the browser.


