################################################################
# Test caching for matrix inverse

# setwd("")
rm(list = ls())

source("cachematrix.R")

# mx <- matrix(1:4, 2, 2)
mx <- matrix(sample(10, 100, replace = TRUE), 10, 10)
mx

mx.1 <- makeCacheMatrix(mx)

mx.inv <- cacheSolve(mx.1)
mx.inv

round((mx %*% mx.inv),3)

mx1
ls(environment(mx.1$getinverse))
get("x", environment(mx.1$getinverse))
get("inv", environment(mx.1$getinverse))




##################################################################
# Test caching for vector mean

rm(list = ls())


source("cachevector.R")


a <- makeVector(1:30)

a
environment(a)
environment(a$set)
ls(environment(a$set))
get("x", environment(a$get))
get("m", environment(a$get))



cachemean(a)

ls(environment(a$set))
get("x", environment(a$get))
get("m", environment(a$get))






##################################################################
# Another caching example: counter


createCounter <- function(x) { function(i) { value <<- value+i} }

counter <- createCounter(2)

counter
ls(environment(counter))
get("value", environment(counter))

# This SEEMS todemonstrates that 2 is 
#  - passed on to "value" in the outer function and
#  - then passed to "i" in the inner function.
# At the end 2 gets stored in the environment of
# the inner funtion as "value"
#
# HOWEVER: Let's see what happens when I replace
# "x" with "increm"

rm(list = ls())

createCounter <- function(increm) { function(i) { value <<- value+i} }

counter <- createCounter(3)

counter
ls(environment(counter))
get("increm", environment(counter))

# The only variable in the environment of "counter"
# is "increm" and NOT "value".
# This shows that function(i) was not even executed.
# Instead the outer function "automatically" saved the
# variable "increm" and assigned 3 to it.


a <- counter(0)
a
get("value", environment(counter))

counter(3)
a
get("value", environment(counter))

a <- counter(0)
a
get("value", environment(counter))

