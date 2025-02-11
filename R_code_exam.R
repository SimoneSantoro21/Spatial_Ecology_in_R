################################################################################
#
# This script demonstrates a workflow for analyzing changes in vegetation
# following a fire event. The analysis includes:
#   1. Data import and visualization (false-color composites)
#   2. Unsupervised classification (k-means clustering)
#   3. Normalized Difference Vegetation Index calculation and Change detection
#   4. Time series analysis for monitoring Forest Recovery
#
################################################################################


#### BLOCK I: Environment Setup and Data Import ####

# --- Install and Load Required Packages ---

# Install necessary libraries if not already installed
# install.packages(c("terra", "raster", "patchwork", "ggplot2", "devtools"))
# library(devtools) # Load the devtools package to download packages from Github
# devtools::install_github("ducciorocchini/imageRy", force = TRUE) # Install the imageRy package from Github

# --- Set Working Directory ---

# Set the working directory (adjust the path for your system)
setwd("C:/Users/User/Spatial_Ecology_in_R")
current_path <- getwd()
cat("Working directory set to:", current_path, "\n")


# --- Load Required Libraries ---

# Load required packages
# (Ensure these packages are installed; install using install.packages() if needed)
library(terra)
library(ggplot2)
library(patchwork)
library(raster)
library(imageRy)


# --- Import Pre-Fire and Post-Fire Satellite Images ---

# Define file paths for pre-fire and post-fire images
pre_fire_path  <- "data/2017-07-28/2017-07-28-00_00_2017-07-28-23_59_Sentinel-2_L2A_False_Color.tiff"
post_fire_path <- "data/2017-08-07/2017-08-07-00_00_2017-08-07-23_59_Sentinel-2_L2A_False_Color.tiff"

# Import the images as raster objects
pre_fire  <- rast(pre_fire_path)
post_fire <- rast(post_fire_path)


# --- Print Image Summaries ---

# Print a summary of the imported images
print("Pre-Fire Image Summary:")
print(pre_fire)
print("Post-Fire Image Summary:")
print(post_fire)


# --- Visualization of False-Color Composites ---

# Display the false-color composites using the default band order:
# Assumes: Band 1 = NIR, Band 2 = Red, Band 3 = Green
par(mfrow = c(1, 2))
plotRGB(pre_fire, r = 1, g = 2, b = 3, main = "Pre-Fire 28-07-2017")
plotRGB(post_fire, r = 1, g = 2, b = 3, main = "Post-Fire 07-08-2017")



#### BLOCK II: Unsupervised Image Classification ####

# --- K-Means Clustering for Land Cover Classification ---

# Perform K-Means clustering with 3 clusters on both pre-fire and post-fire images
pre_fire_cl  <- im.classify(pre_fire, num_clusters = 3)  # Cluster 3 = Forest
post_fire_cl <- im.classify(post_fire, num_clusters = 3)  # Cluster 2 = Forest


# --- Visualization of Classified Images ---

# Plot the classified land cover maps for pre-fire and post-fire conditions
par(mfrow = c(1, 2))
plot(pre_fire_cl, main = "Pre-Fire Classification")
plot(post_fire_cl, main = "Post-Fire Classification")


# --- Compute Class Frequencies ---

# Retrieve the frequency of each class in the classified images
pre_fire_freq <- freq(pre_fire_cl)
pre_fire_freq

post_fire_freq <- freq(post_fire_cl)
post_fire_freq


# --- Compute Percentage of Forest Cover ---

# Calculate the percentage of each class relative to the total number of pixels
pre_fire_percentage <- pre_fire_freq * 100 / ncell(pre_fire_cl) 
pre_fire_percentage  # Expected Forest Cover ~72.8%

post_fire_percentage <- post_fire_freq * 100 / ncell(post_fire_cl)
post_fire_percentage # Expected Forest Cover ~57%


# --- Create Summary Table ---

# Define land cover classes
class <- c("Forest", "Other")

# Define forest cover percentages before and after the fire
pre_fire_res  <- c(72.8, 27.2)
post_fire_res <- c(57.5, 42.5)

# Create a data frame summarizing pre-fire and post-fire results
tabout <- data.frame(class, pre_fire_res, post_fire_res)
tabout


# --- Visualization of Forest Cover Change ---

# Create bar plots to visualize forest cover percentages before and after the fire
p1 <- ggplot(tabout, aes(x = class, y = pre_fire_res, color = class)) + 
  geom_bar(stat = "identity", fill = "white") + ylim(c(0, 100)) + 
  ggtitle("Pre-Fire Forest Cover")

p2 <- ggplot(tabout, aes(x = class, y = post_fire_res, color = class)) + 
  geom_bar(stat = "identity", fill = "white") + ylim(c(0, 100)) + 
  ggtitle("Post-Fire Forest Cover")

# Display the two plots
p1 / p2



#### BLOCK III: Normalized Difference Vegetation Index ####

# --- Computation ---

# Compute the Normalized Difference Vegetation Index (NDVI)
# NDVI = (NIR - Red) / (NIR + Red)
ndvi_pre  <- (pre_fire[[1]] - pre_fire[[2]]) / (pre_fire[[1]] + pre_fire[[2]])
ndvi_post <- (post_fire[[1]] - post_fire[[2]]) / (post_fire[[1]] + post_fire[[2]])


# --- Visualization of Raster Maps ---

# Set up a multi-panel plotting layout for the vegetation indices maps.
# We include NDVI both pre-fire and post-fire.
par(mfrow = c(1, 2))
plot(ndvi_pre,  main = "NDVI - Pre-Fire")
plot(ndvi_post, main = "NDVI - Post-Fire")


# --- Density Plots ---

# Extract pixel values from the NDVI rasters
ndvi_pre_vals  <- values(ndvi_pre)
ndvi_post_vals <- values(ndvi_post)

# Remove NA values from the extracted vectors
ndvi_pre_vals  <- ndvi_pre_vals[!is.na(ndvi_pre_vals)]
ndvi_post_vals <- ndvi_post_vals[!is.na(ndvi_post_vals)]

# Density plot for NDVI
dev.off()
plot(density(ndvi_pre_vals), main = "Density Plot of NDVI", 
     xlab = "NDVI", col = "blue", lwd = 2)
lines(density(ndvi_post_vals), col = "red", lwd = 2)
legend("topleft", legend = c("Pre-Fire", "Post-Fire"), 
       col = c("blue", "red"), lwd = 2)


# --- Quantitative Summary: Compute and Print Mean Values ---

mean_ndvi_pre  <- as.numeric(global(ndvi_pre, mean, na.rm = TRUE))
mean_ndvi_post <- as.numeric(global(ndvi_post, mean, na.rm = TRUE))

cat("Mean NDVI Pre-Fire:", mean_ndvi_pre, "\n")
cat("Mean NDVI Post-Fire:", mean_ndvi_post, "\n")


# --- Vegetation Percentage and NDVI Change Analysis ---

# Calculate the percentage of vegetated area based on an NDVI threshold (> 0.4)
# For vegetation, we assume that NDVI > 0.4 indicates vegetated pixels.
vegetated_pre  <- sum(values(ndvi_pre) > 0.4, na.rm = TRUE) / ncell(ndvi_pre) * 100
vegetated_post <- sum(values(ndvi_post) > 0.4, na.rm = TRUE) / ncell(ndvi_post) * 100

# Print the vegetated area percentages for pre-fire and post-fire conditions
cat("Percentage of Vegetated Area Pre-Fire:", vegetated_pre, "%\n")
cat("Percentage of Vegetated Area Post-Fire:", vegetated_post, "%\n")

# Calculate the NDVI difference and quantify reduction
# Compute NDVI difference: (Post-Fire NDVI - Pre-Fire NDVI)
ndvi_diff <- ndvi_post - ndvi_pre

# Calculate the percentage of pixels where NDVI has reduced (i.e., NDVI difference < 0)
ndvi_reduction <- sum(ndvi_diff[] < 0, na.rm = TRUE) / ncell(ndvi_diff) * 100
cat("Percentage of pixels with NDVI reduction:", ndvi_reduction, "%\n")

# Plot the spatial distribution of NDVI differences and a histogram of the differences
par(mfrow = c(1, 2))  # Create a plotting area with 1 row and 2 columns

# Plot the NDVI difference map
plot(ndvi_diff, main = "NDVI Difference (Post-Fire - Pre-Fire)")

# Plot a histogram of NDVI differences
hist(ndvi_diff, main = "Histogram of NDVI Differences", 
     xlab = "NDVI Difference", col = "lightblue")



#### BLOCK IV: Time Series Analysis for Forest Recovery ####

# --- Define Time Series Parameters ---

# Define the years for which images are available
years <- 2017:2024
dates <- c("-08-07", "-08-02", "-08-02", "-08-06", "-08-06", "-08-06", "-08-06", "-08-05")

# Initialize vectors to store metrics for each year
mean_ndvi_vec         <- numeric(length(years))
forest_cover_perc_vec <- numeric(length(years))


# --- Compute NDVI and Forest Cover Percentage for Each Year ---

# Loop over each year, load the image, compute NDVI and forest cover percentage
for(i in seq_along(years)){
  year <- years[i]
  date <- dates[i]
  
  # Construct the file path (adjust if your naming convention is different)
  file_path <- paste0("data", "/", year, date, "-00_00_", year, date, "-23_59_Sentinel-2_L2A_False_Color.tiff")
  
  # Load the image as a SpatRaster
  img <- rast(file_path)
  
  # Compute NDVI assuming band 1 = NIR and band 2 = Red
  ndvi_img <- (img[[1]] - img[[2]]) / (img[[1]] + img[[2]])
  
  # Compute Mean NDVI
  # global() returns a data frame, so extract the first element
  mean_ndvi <- as.numeric(global(ndvi_img, "mean", na.rm = TRUE)[[1]])
  mean_ndvi_vec[i] <- mean_ndvi
  
  
  # Compute Forest Cover Percentage
  #   - Define forest pixels as those with NDVI > 0.4
  #   - Use the valid (non-NA) pixels as denominator
  ndvi_vals <- values(ndvi_img)
  valid_idx <- !is.na(ndvi_vals)
  forest_pixels <- sum(ndvi_vals[valid_idx] > 0.4)
  total_valid  <- sum(valid_idx)
  
  forest_cover_perc <- (forest_pixels / total_valid) * 100
  forest_cover_perc_vec[i] <- forest_cover_perc
  
  # Print a summary message for each year
  cat("Year:", year, 
      "- Mean NDVI:", round(mean_ndvi, 3), 
      "- Forest Cover (%):", round(forest_cover_perc, 1), "\n")
}


# --- Create Data Frame for Time Series Analysis ---

# Combine the results into a data frame for visualization and analysis
ts_data <- data.frame(
  Year = years,
  Mean_NDVI = mean_ndvi_vec,
  Forest_Cover_Percentage = forest_cover_perc_vec
)


# --- Time Series Plots ---

# Plot time series for Mean NDVI
p_ndvi <- ggplot(ts_data, aes(x = Year, y = Mean_NDVI)) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "darkgreen", size = 3) +
  ggtitle("Time Series of Mean NDVI") +
  xlab("Year") +
  ylab("Mean NDVI") +
  theme_minimal()

# Plot time series for Forest Cover Percentage
p_forest <- ggplot(ts_data, aes(x = Year, y = Forest_Cover_Percentage)) +
  geom_line(color = "forestgreen", size = 1.2) +
  geom_point(color = "forestgreen", size = 3) +
  ggtitle("Time Series of Forest Cover Percentage") +
  xlab("Year") +
  ylab("Forest Cover (%)") +
  theme_minimal()

# Combine the two plots side by side
p_ndvi + p_forest

# Also printing the data frame to inspect the numeric trends
print(ts_data)
