################################################################################
# This script demonstrates:
# 1. Performing Principal Component Analysis (PCA) on satellite imagery.
# 2. Extracting and visualizing PC1 with different color palettes.
# 3. Computing spatial variability using standard deviation with different window sizes.
# 4. Combining PCA and variability analysis in a multi-frame visualization.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load required libraries (install if necessary)
library(imageRy)  # For image import and manipulation
library(terra)    # For raster data processing
library(viridis)  # For creating perceptually uniform color palettes

# List all available images in the working directory
im.list()

#### BLOCK 2: Import and Initial Visualization ####

# Import Sentinel image
sentinel_image <- im.import("sentinel.png")

# Create a scatterplot matrix to visualize correlations between bands
pairs(sentinel_image, main = "Scatterplot Matrix of Sentinel Bands")

#### BLOCK 3: Principal Component Analysis (PCA) ####

# Perform PCA on the Sentinel image
sentinel_pca <- im.pca(sentinel_image)

# Extract the first principal component (PC1)
pc1 <- sentinel_pca$PC1

# Create a perceptually uniform color palette
viridis_palette <- colorRampPalette(viridis(7))(255)

# Plot PC1 with default and custom color palette
plot(pc1, main = "Principal Component 1 (PC1)")
plot(pc1, col = viridis_palette, main = "PC1 with Viridis Palette")

#### BLOCK 4: Spatial Variability Analysis using Standard Deviation ####

# Compute standard deviation for PC1 using a 3x3 moving window
pc1_sd_3x3 <- focal(pc1, matrix(1/9, 3, 3), fun = sd)
plot(pc1_sd_3x3, col = viridis_palette, main = "PC1 Standard Deviation (3x3)")

# Compute standard deviation for PC1 using a 7x7 moving window
pc1_sd_7x7 <- focal(pc1, matrix(1/49, 7, 7), fun = sd)
plot(pc1_sd_7x7, col = viridis_palette, main = "PC1 Standard Deviation (7x7)")

#### BLOCK 5: Standard Deviation Calculation on NIR Band ####

# Extract Near Infrared (NIR) band from Sentinel image
nir_band <- sentinel_image[[1]]

# Compute standard deviation for NIR using a 3x3 moving window
nir_sd_3x3 <- focal(nir_band, matrix(1/9, 3, 3), fun = sd)
plot(nir_sd_3x3, col = viridis_palette, main = "NIR Standard Deviation (3x3)")

# Compute standard deviation for NIR using a 7x7 moving window
nir_sd_7x7 <- focal(nir_band, matrix(1/49, 7, 7), fun = sd)
plot(nir_sd_7x7, col = viridis_palette, main = "NIR Standard Deviation (7x7)")

#### BLOCK 6: Multi-Frame Visualization ####

# Set up a multi-panel plot layout (2 rows, 3 columns)
par(mfrow = c(2, 3))

# Display the original Sentinel image with an RGB composite
im.plotRGB(sentinel_image, r = 2, g = 1, b = 3)  # Plot the RGB composite

# Plot computed standard deviation and PCA outputs
plot(nir_sd_3x3, col = viridis_palette)
plot(nir_sd_7x7, col = viridis_palette)
plot(pc1, col = viridis_palette)
plot(pc1_sd_3x3, col = viridis_palette)
plot(pc1_sd_7x7, col = viridis_palette)

# Reset layout
dev.off()

#### BLOCK 7: Stacking and Final Visualization ####

# Stack the standard deviation layers together
sd_stack <- c(nir_sd_3x3, nir_sd_7x7, pc1_sd_3x3, pc1_sd_7x7)

# Assign meaningful names to each layer in the stack
names(sd_stack) <- c("NIR_SD_3x3", "NIR_SD_7x7", "PC1_SD_3x3", "PC1_SD_7x7")

# Plot the stacked layers with a perceptually uniform color palette
plot(sd_stack, col = viridis_palette, main = "Stacked Standard Deviation Layers")

