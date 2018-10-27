## Short and naive test cases for my solution "cachematrix.R".

## 2015-02-17, Martin Leggewie

source('cachematrix.R')

# prepare test data
test.x <- matrix(data = 1:4, nrow = 2, ncol = 2)
test.inversed <- solve(test.x)

# test step 1: makeCacheMatix a new matrix and check its contents
m <- makeCacheMatrix(matrix(data = 1:4, nrow = 2, ncol = 2))
m$getX() == test.x
is.null(m$getInversed())

# test step 2: now call cacheSolve on m and check if m now contains the
# inverse. This inverse has to be indentical to prepared test.inversed 
cacheSolve(m)
m$getX() == test.x
!is.null(m$getInversed())
m$getInversed() == test.inversed

# test step 3: call cacheSolve on m again. This time we should see the 
# "getting cached data" message since the inverse should have not been
# calculated again but instead directly read from the internally cached value.
cacheSolve(m)
m$getX() == test.x
!is.null(m$getInversed())
m$getInversed() == test.inversed
