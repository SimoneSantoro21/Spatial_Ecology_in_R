################################################################################
# Time Series Analysis using R
#
# This script demonstrates:
# 1. Importing and visualizing multi-temporal images.
# 2. Computing differences between images for change detection.
# 3. Visualizing time series changes in an RGB composite.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load necessary libraries
library(terra)   # For raster and spatial data handling
library(imageRy) # For remote sensing image analysis

# List available images in the working directory
im.list()

# Import images for analysis
image_EN01 <- im.import("EN_01.png")  # First temporal image
image_EN13 <- im.import("EN_13.png")  # Second temporal image

#### BLOCK 2: Basic Visualization ####

# Create a side-by-side layout for comparison
par(mfrow = c(1, 2))
plot(image_EN01, main = "EN_01 Image")  # Plot first image
plot(image_EN13, main = "EN_13 Image")  # Plot second image

dev.off()  # Reset plotting layout

#### BLOCK 3: Change Detection ####

# Compute the difference between two images (band 1)
diff_EN <- image_EN01[[1]] - image_EN13[[1]]

# Visualize the difference image
plot(diff_EN, main = "Difference Image (Band 1)")

dev.off()  # Reset plotting layout

#### BLOCK 4: Multi-Temporal Analysis (Greenland Temperature) ####

# Import all images related to Greenland temperature (2000, 2005, 2010, 2015)
greenland_images <- im.import("greenland")

# Visualize the first and last images (2000 and 2015)
par(mfrow = c(1, 2))
plot(greenland_images[[1]], main = "Greenland 2000")  # First image (2000)
plot(greenland_images[[4]], main = "Greenland 2015")  # Fourth image (2015)

dev.off()  # Reset plotting layout

# Compute the difference between 2000 and 2015 (band 1)
diff_greenland <- greenland_images[[1]] - greenland_images[[4]]

# Plot the difference map
plot(diff_greenland, main = "Temperature Difference: 2000 - 2015")

dev.off()  # Reset plotting layout

#### BLOCK 5: RGB Composite Visualization ####

# Create an RGB composite: Assign years to different color channels
im.plotRGB(greenland_images, r = 1, g = 2, b = 4)