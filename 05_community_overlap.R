################################################################################
# This script demonstrates:
# 1. Loading and inspecting the kerinci dataset.
# 2. Transforming time data into circular coordinates (radians).
# 3. Extracting and plotting activity time densities for tiger and macaque.
# 4. Visualizing the temporal overlap between tiger and macaque activity.
# 5. Summarizing species-specific data.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load the overlap package (install if needed)
#install.packages("overlap")
library(overlap)

# Load the kerinci dataset from the overlap package
data(kerinci)

# Display the first six rows of the kerinci dataset for an initial look
cat("First six rows of the kerinci dataset:\n")
head(kerinci)

# Print the full dataset and a summary of its attributes
print(kerinci)
summary(kerinci)

#### BLOCK 2: Transforming Time Data ####

# Transform the time data to circular (radian) values for proper temporal analysis.
# Multiplying by 2*pi converts the time from a fractional day to radians.
kerinci$TimeCircular <- kerinci$Time * 2 * pi

#### BLOCK 3: Tiger Data Analysis ####

# Extract records for the 'tiger' species
tiger_data <- kerinci[kerinci$Sps == "tiger", ]
# Extract the circular time values for tigers
tiger_time <- tiger_data$TimeCircular

# Plot the density of tiger activity times
densityPlot(tiger_time, main = "Density Plot: Tiger Activity Times")

#### BLOCK 4: Macaque Data Analysis ####

# Extract records for the 'macaque' species and assign them to a new object
macaque_data <- kerinci[kerinci$Sps == "macaque", ]
# Extract the circular time values for macaques
macaque_time <- macaque_data$TimeCircular

# Plot the density of macaque activity times
densityPlot(macaque_time, main = "Density Plot: Macaque Activity Times")

#### BLOCK 5: Temporal Overlap Visualization ####

# Plot the overlap between tiger and macaque activity times
overlapPlot(tiger_time, macaque_time, main = "Temporal Overlap: Tiger vs. Macaque")

#### BLOCK 6: Additional Data Summaries ####

# Summarize the macaque data to check its structure and statistics
cat("Summary of Macaque Data:\n")
summary(macaque_data)

# Extract records for all species other than macaque
non_macaque_data <- kerinci[kerinci$Sps != "macaque", ]
cat("Summary of Non-Macaque Data:\n")
summary(non_macaque_data)
