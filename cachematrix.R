# The two functions below - makeCacheMatrix and cacheSolve - work in conjuction
# to calculate the inverse of a matrix. makeCacheMatrix stores (i.e. caches) a
# matrix and the inverse and provides a set of functions to set and retrieve
# these two variables. cacheSolve does the actual math to calculate the matrix
# inverse. In addition, it checks the cache and retrieves the inverse if it
# already exists.
# 
# Here is a typical way of using these two functions together:
#     mx <- matrix(sample(10, 100, replace = TRUE), 10, 10) --- define a matrix
#     mx.1 <- makeCacheMatrix(mx)  --- pass mx to the first function
#     mx.inv <- cacheSolve(mx.1)   --- calculate or retrieve cached inverse
# 
# 
# 
# 
# MakeCacheMatrix: This function 
#   1. caches two variables, a matrix 'x' and its inverse 'inv',
#   2. provides four functions (let's call them caching functions'); two of them
#   to set and retieve the orignal matrix and another pair to set and retrieve
#   the inverse matrix.
# 
# The cached varibles 'x' and 'inv' are stored in the enclosing environment of
# the four caching functions. This way the variable values are preserved even
# after exiting the caching functions. In order to save 'x' and 'inv' into the
# enclosing environment the two functions 'set' and 'setinvers' use the special
# assignment operator '<<-'.
#
# Another important point is to recognize that the four caching functions are
# placed inside the function makeCacheMatrix. Due to the lexical scoping in R,
# the enclosing environment of the four caching functions is the environment
# that is active when they are created, which is the evaluation environment of
# makeCacheMatrix. This is imporant for understanding of what happens when
# makeCacheMatrix gets invoked.
#
# When we call makeCacheMatrix and pass a matrix to it, the matrix gets assigned
# to the value 'x' and written to the evaluation environment (in line 1 of the
# fuction); next in line 2 'inv' (which is the cache for the matrix invers) is
# set to NULL. The rest of the makeCacheMatrix is to define the four caching
# functions (which don't get evaluated at this point) and to wrap them into a
# list. Since 'x' and 'inv' already exist when the four caching functions get
# created, 'x' and 'inv' become attributes of their enclosing environment.


makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    set <- function(y) {
        x <<- y
        inv <<- NULL
    }
    get <- function() x
    setinverse <- function(inverse) inv <<- inverse
    getinverse <- function() inv
    list(set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse)
}


# The main purpose of the cacheSolve function is to calculate an inverse matrix
# or retrieve it in case it already exists in the cache.
# 
# The cacheSolve function requires as an input the output of makeCacheMatrix
# (that is a list of function closures see use example above).
# 
# The first step in the function body is to retrieve the cached value for the
# inverse matrix 'inv' using the getinverse funtion. If 'inv' is not NULL, the
# cached inverse is returned.
# 
# If 'inv' is NULL the original matrix is retrieved and assigned to the variable
# 'data'. Next the inverse matrix gets calculated (using the function solve) and
# saved back into the cache using setinverse. Finally, the inverse matrix is
# returned.



cacheSolve <- function(x, ...) {
    inv <- x$getinverse()
    if(!is.null(inv)) {
        message("retriEving cached inverse")
        return(inv)
    }
    data <- x$get()
    inverse <- solve(data, ...)
    x$setinverse(inverse)
    inverse
}
