################################################################################
# This script demonstrates:
# 1. Loading and exploring the dune dataset.
# 2. Performing Detrended Correspondence Analysis (DCA) with decorana.
# 3. Calculating the lengths of the first four axes and determining the
#    proportion and percentage of variability explained by each.
# 4. Visualizing the DCA ordination.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load the vegan package (uncomment installation if needed)
#install.packages("vegan")
library(vegan)

# Load the 'dune' dataset which contains species abundance data across plots
data(dune)

# Display a summary and the first few rows of the dataset
print("Summary of the dune dataset:")
print(summary(dune))
head(dune)

# Uncomment the following line if using RStudio to view the full dataset
#View(dune)

#### BLOCK 2: Performing Detrended Correspondence Analysis (DCA) ####

# Use decorana to perform DCA on the dune dataset
dune_dca <- decorana(dune)
print("Results of Detrended Correspondence Analysis (DCA):")
print(dune_dca)

#### BLOCK 3: Calculating Axis Lengths and Variability ####

# Define the lengths of the first four DCA axes as provided by the analysis output
axis1_length <- 3.7004
axis2_length <- 3.1166
axis3_length <- 1.30055
axis4_length <- 1.47888

# Calculate the total length by summing all four axes
total_length <- axis1_length + axis2_length + axis3_length + axis4_length
print(paste("Total axis length:", total_length))

# Calculate the proportion of the total variability explained by each axis
prop_axis1 <- axis1_length / total_length
prop_axis2 <- axis2_length / total_length
prop_axis3 <- axis3_length / total_length
prop_axis4 <- axis4_length / total_length

# Convert these proportions to percentages
perc_axis1 <- prop_axis1 * 100
perc_axis2 <- prop_axis2 * 100
perc_axis3 <- prop_axis3 * 100
perc_axis4 <- prop_axis4 * 100

# Print the percentage contributions of each axis
print(paste("Axis 1 explains", round(perc_axis1, 1), "% of variability"))
print(paste("Axis 2 explains", round(perc_axis2, 1), "% of variability"))
print(paste("Axis 3 explains", round(perc_axis3, 1), "% of variability"))
print(paste("Axis 4 explains", round(perc_axis4, 1), "% of variability"))

# Calculate the total variability explained by the first two axes
total_variability_first_two <- perc_axis1 + perc_axis2
print(paste("The first two axes explain", round(total_variability_first_two, 1), "% of the total variability"))

#### BLOCK 4: Visualization ####

# Plot the DCA ordination to visualize species and plot relationships
plot(dune_dca, main = "DCA Ordination of Dune Species Data")

