# This script demonstrates essential R concepts:
# 1. Creating objects (variables)
# 2. Using the assignment operator (<-)
# 3. Adding comments to explain code
# 4. Writing and using functions
# 5. Working with arrays (vectors) and basic plotting

# --- Basic Arithmetic Operations ---
# Perform a simple arithmetic operation and print the result directly
5 + 8  # This computes the sum of 5 and 8

# --- Creating Objects and Using Assignment ---
# Assign the result of an operation to an object called 'alpha'
alpha <- 5 + 8    
alpha             # Display the value of alpha

# Assign another operation result to an object called 'beta'
beta <- 12 - 3    
beta              # Display the value of beta

# Further arithmetic operations
alpha * beta      # Product of alpha and beta
(alpha + beta)^2  # Square of the sum of alpha and beta

# --- Working with Arrays (Vectors) ---
# Create vectors to represent temperature readings at different times of day
temps_morning <- c(15, 17.5, 16, 18, 19)   # Morning temperatures in °C
temps_afternoon <- c(20, 22, 23.5, 24, 24)   # Afternoon temperatures in °C

# Display the temperature vectors
temps_morning
temps_afternoon

# --- Plotting the Data ---
# Plot morning vs. afternoon temperatures with customized symbols and colors
plot(temps_morning, temps_afternoon, 
     main = "Morning vs. Afternoon Temperatures",
     xlab = "Morning Temperature (°C)", 
     ylab = "Afternoon Temperature (°C)",
     pch = 16,      # Use solid circle markers
     col = "blue",  # Set marker color to blue
     cex = 1.5)     # Increase marker size

# --- Creating and Using a Custom Function ---
# Define a function to calculate the temperature increase from morning to afternoon
temp_difference <- function(morning, afternoon) {
  # Compute the difference (afternoon temperature minus morning temperature)
  diff <- afternoon - morning
  return(diff)
}

# Use the function to compute the temperature differences for our vectors
temperature_diff <- temp_difference(temps_morning, temps_afternoon)
temperature_diff  # Display the differences

# Compute and print the average temperature increase
average_increase <- mean(temperature_diff)
cat("Average temperature increase from morning to afternoon:", average_increase, "°C\n")