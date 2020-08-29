# Exponentiation
2^5
# Modulo
28%%6

# Decimal values like 4.5 are called numerics.
# Natural numbers like 4 are called integers. Integers are also numerics.
# Boolean values (TRUE or FALSE) are called logical.
# Text (or string) values are called characters.

# Check class
class(data)


# Vector
#-------------------------------------------------------
vector <- c(TRUE, FALSE, TRUE)
# Name Vector 1
names(vector) <- c("A", "B", "C")
# Name Vector 2
alphabet <- c("A", "B", "C")
names(vector) <- alphabet

# Add Vectors
c(1, 2, 3) + c(4, 5, 6) # == c(5, 7, 9)
total <- sum(vector)

# Comparison
total_1 > vtotal_2

# Select several elements from a vector
selections <- vector[c(2,3,4)]
selections <- vector[2:4]
selections <- vector[c("B", "C", "D")]
# Select the elements that are positive
selections <- vector > 0 
vector[selections]

# Vectors Calculations / Comparisons
mean(vector)
selections <- vector > 0 # select the elements that are positive
vector[selections]


# Matrix
#--------------------------------------------------------
matrix(1:9, byrow = TRUE, nrow = 3)  # fill by the rows

matrix(1:9, byrow = FALSE, nrow = 3) # fill by the columns

a <- c(1, 2)
b <- c(3, 4)
c <- c(5, 6)
vecma <- c(a, b, c)
matrix <- matrix(vecma, byrow = TRUE, nrow = 3)

# Name
name1 <- c("A", "B")
name2 <- c("a", "b", "c")
colnames(matrix) <- name1
rownames(matrix) <- name2

# Calculation
rowsum <- rowSums(matrix)
colsum <- colSums(matrix)
2 * matrix        # multiplies each element
matrix / matrix   # correspond elements

# Bind
big_matrix <- cbind(matrix1, matrix2, vector1) # add new columns
big_matrix <- rbind(matrix1, matrix2, vector1) # add new rows


# Factor
#-----------------------------------------------------
# categorical variables (limited numbers)
sex_vector <- c("Male", "Female", "Female", "Male", "Male")
# Convert sex_vector to a factor
factor_sex_vector <- factor(sex_vector)

# Order
temperature_vector <- c("High", "Low", "High","Low", "Medium")
factor_temperature_vector <- factor(temperature_vector, order = TRUE, levels = c("Low", "Medium", "High"))
# order = TRUE: S -> L

# Change Name
survey_vector <- c("M", "F", "F", "M", "M")
levels(factor_survey_vector) <- c("Female", "Male")


# Data Frame
#------------------------------------------------------
# Overview
head(df)
str(df) 
# The total number of observations; The total number of variables
# A full list of the variables names; The data type of each variable; The first observations

# Build a dataframe
name <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)
planets_df <- data.frame(name, type, diameter, rotation, rings)

# Subset
df[1:3, 2:4]
df[1,]
df[,1]
df[1:3,"A"]
df$A[1:3]
# TF_vector: T/F
df[TF_vector,]
# With Conditions
subset(df, subset = A < 1)

# Sort
# Use order() to create positions
positions <-  order(planets_df$diameter)
# Use positions to sort planets_df
planets_df[positions, ]


# List (A place to save things)
#-----------------------------------------------------
# Gather a variety of objects, objects can be matrices, vectors, data frames, even other lists
my_vector <- 1:10
my_matrix <- matrix(1:9, ncol = 3)
my_df <- mtcars[1:10,]
# Construct list with these different elements:
my_list <- list(my_vector, my_matrix, my_df)

# The variables mov, act and rev are available (not a sheet, with different rows and cols)
shining_list <- list(moviename = mov, actors = act, reviews = rev)

# Name
names(my_list) <- c("vec", "mat", "df")

# Subset
shining_list[["reviews"]]
shining_list$reviews





