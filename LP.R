library(lpSolve)

# Define the objective function coefficients
obj <- c(10, 6, 4)  # Coefficients for variables x1, x2, x3

# Define the constraint coefficients matrix
mat <- matrix(c(1, 1, 1, 2, 1, 0, 0, 1, 2), byrow = TRUE, nrow = 3)

# Define the direction of the constraints (<=)
dir <- c("<=", "<=", "<=")

# Define the right-hand side of the constraints
rhs <- c(100, 80, 40)

# Set the type of each variable (continuous or integer)
types <- c("C", "C", "C")  # All variables are continuous

# Solve the linear programming problem
lp_solution <- lp("max", obj, mat, dir, rhs)
lp_solution$solution
# Print the solution
print(lp_solution)
