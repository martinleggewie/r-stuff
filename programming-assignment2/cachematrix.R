## This file contains my solution to the programming assignment 2 of the
## "R Programming" course offered via Coursera. The goal of this assignment was
## to demonstrate the lexical scoping nature of R.

## For the programming assignment, the task was to implement two functions. The 
## first function "makeCacheMatrix" returns a special type of matrix which
## offers functions to set and read a given matrix as well as such getter and
## setter for the inverse of that given matrix.

## The second function "cacheSolve" calculates the inverse of a matrix created
## by the "makeCacheMatrix" and stores the result in this "makeCacheMatrix"
## matrix as well. But: "cacheSolve" only executes the inverse calculation if
## the "makeCacheMatrix" matrix not yet contains a cached value. Otherwise, if
## the cache is already set, "cacheMatrix" only returns this cached matrix.

## Lexical scoping is demonstrated by the way how the matrix and its inverse
## is stored inside the "makeCacheMatrix" function. We have to use the special
## <<- operator because otherwise it would not be possible to change anything
## inside a function which is itself defined in another function.

## One word about the way I have named the variables and functions inside the
## two functions: I tried to apply the Google R nameing conventions here, check
## https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml

## 2015-02-17, Martin Leggewie


## function "makeCacheMatrix"

## Creates a special version of a given matrix which stores not only this matrix
## but also provides a storage for its inverse. (To be honest: You can store
## just any kind of matrix there, it does not have necessarily be the inverse of
## the given matrix. But in this example the second function "cacheSolve" is the
## only client of that storage, and since this second function calculates the
## inverse (if not already done before) and stores the result in that storage,
## this storage just happens to really contain the inverse of the given matrix.)

makeCacheMatrix <- function(x = matrix()) {
  # storage for the (elsewhere) calculated inverse of the given matrix x.
  inversed <- NULL
  
  # setter for the internally stored matrix
  setX <- function(new.x) {
    x <<- new.x
    inversed <<- NULL
  }
  
  # getter for the internally stored matrix
  getX <- function() {
    x
  }
  
  # setter for the (elsewhere) calculated inverse of matrix x
  setInversed <- function(new.inversed) {
    inversed <<- new.inversed
  }
  
  # getter for the (elsewhere) calculated inverse of matrix x
  getInversed <- function() {
    inversed
  }
  
  # return the result as a list with named functions. Otherwise you cannot use
  # the quite handy "variable$functionName()" to directly call variable's
  # elements as a function.
  list(
    setX = setX,
    getX = getX,
    setInversed = setInversed,
    getInversed = getInversed
  )
}


## function "cacheSolve"

## Expects a matrix created by "makeCacheMatrix" and returns the inverse of the
## internally contained matrix. Since "makeCacheMatrixed" matrices also contain
## a cache storage for their corresponding inversed matrix, this function first
## checks if the cache already contains an inversed matrix. If yes, it just
## returns this inversed matrix and reports this with a small message. In case
## the cache is empty, this function calculates the inverse and stores it in the
## cache for later use.
cacheSolve <- function(x, ...) {
  # Get the possibly cached inversed from the given matrix x.
  inversed <- x$getInversed()
  if(!is.null(inversed)) {
    # Ok, the inversed was already calculated before. We don't have to do
    # anything here but reporting this to the caller.
    message("getting cached data")
  } else {
    # What a pity: The inversed was not yet calculated. So we have to do the
    # hard work ourselves and store the result in the given matrix x.
    internal.x <- x$getX()
    inversed <- solve(internal.x)
    x$setInversed(inversed)
  }
  
  # return the inversed matrix as a result.
  inversed
}
