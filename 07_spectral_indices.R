################################################################################
# This script demonstrates:
# 1. Loading remote sensing images from two time periods.
# 2. Visualizing various RGB composites for each image.
# 3. Arranging multiframe comparisons with different band configurations.
# 4. Computing spectral indices: Difference Vegetation Index (DVI) and
#    Normalized Difference Vegetation Index (NDVI).
# 5. Visualizing indices with custom color palettes.
################################################################################

#### BLOCK 1: Setup and Data Import ####

# Load required packages (uncomment installation commands if needed)
# install.packages("terra")
# install.packages("devtools")
# devtools::install_github("ducciorocchini/imageRy")
library(imageRy)
library(terra)

# List available files/data in the imageRy package (for reference)
im.list()

# Import remote sensing images:
# m2006: Modern image from 2006
# m1992: Ancient image from 1992
image2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
image1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")

#### BLOCK 2: RGB Composite Visualizations ####

# Band assignment for these images:
#   Band 1 = NIR
#   Band 2 = Red
#   Band 3 = Green

# Display various RGB composites for the 2006 image:
im.plotRGB(image2006, r = 1, g = 2, b = 3)  # Composite: NIR, Red, Green
im.plotRGB(image2006, r = 3, g = 2, b = 1)  # Composite: Green, Red, NIR
im.plotRGB(image2006, r = 3, g = 1, b = 2)  # Composite: Green, NIR, Red

# Visualize a natural color composite for the 1992 image:
im.plotRGB(image1992, r = 1, g = 2, b = 3)

#### BLOCK 3: Multiframe Comparisons ####

# Compare the natural color composites of 1992 and 2006 side by side
par(mfrow = c(1, 2))
im.plotRGB(image1992, r = 1, g = 2, b = 3)
im.plotRGB(image2006, r = 1, g = 2, b = 3)
dev.off()  # Reset plotting layout

# Create a multiframe with 6 images (3 rows x 2 columns) where each row uses a
# different band as the primary component:
par(mfrow = c(3, 2))
# First row: use configuration with r = 1 (NIR as primary)
im.plotRGB(image1992, r = 1, g = 2, b = 3)
im.plotRGB(image2006, r = 1, g = 2, b = 3)
# Second row: swap bands: r = 2 (Red as primary)
im.plotRGB(image1992, r = 2, g = 1, b = 3)
im.plotRGB(image2006, r = 2, g = 1, b = 3)
# Third row: swap bands: r = 3 (Green as primary)
im.plotRGB(image1992, r = 3, g = 2, b = 1)
im.plotRGB(image2006, r = 3, g = 2, b = 1)
dev.off() 

#### BLOCK 4: Spectral Indices Calculation ####

# Compute the Difference Vegetation Index (DVI) for each image.
# DVI is calculated as NIR minus Red.
dvi1992 <- image1992[[1]] - image1992[[2]]
dvi2006 <- image2006[[1]] - image2006[[2]]

# Define a custom color palette for visualizing vegetation indices.
veg_palette <- colorRampPalette(c("darkblue", "yellow", "red", "black"))(100)

# Plot DVI for 1992 and 2006 individually.
plot(dvi1992, col = veg_palette, main = "DVI - 1992")
plot(dvi2006, col = veg_palette, main = "DVI - 2006")

# Compare DVI side by side.
par(mfrow = c(1, 2))
plot(dvi1992, col = veg_palette, main = "DVI - 1992")
plot(dvi2006, col = veg_palette, main = "DVI - 2006")
dev.off()

# Compute the Normalized Difference Vegetation Index (NDVI) for each image.
# NDVI = (NIR - Red) / (NIR + Red)
ndvi1992 <- dvi1992 / (image1992[[1]] + image1992[[2]])
ndvi2006 <- dvi2006 / (image2006[[1]] + image2006[[2]])

# Plot NDVI with the custom vegetation palette.
plot(ndvi1992, col = veg_palette, main = "NDVI - 1992")
plot(ndvi2006, col = veg_palette, main = "NDVI - 2006")

# Also display NDVI using the default palette.
plot(ndvi1992, main = "NDVI - 1992 (Default Palette)")
plot(ndvi2006, main = "NDVI - 2006 (Default Palette)")
