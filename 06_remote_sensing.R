################################################################################
# This script demonstrates:
# 1. Loading Sentinel-2 band data using the terra and imageRy packages.
# 2. Visualizing individual bands with a custom grayscale palette.
# 3. Arranging multiple band plots in a multiframe layout.
# 4. Creating a raster stack from the imported bands.
# 5. Visualizing individual layers with custom color palettes.
# 6. Generating natural and false color RGB composites.
################################################################################

#### BLOCK 1: Setup and Data Import ####

# Load required packages

library(terra)      # For raster data handling
library(imageRy)    # For remote sensing image processing functions

# List available images/data from the imageRy package (for reference)
im.list()

# Import Sentinel-2 bands from the Dolomites dataset.
# Band details:
#   Band 2: Blue
#   Band 3: Green
#   Band 4: Red
#   Band 8: Near Infrared (NIR)
blue_band  <- im.import("sentinel.dolomites.b2.tif")
green_band <- im.import("sentinel.dolomites.b3.tif")
red_band   <- im.import("sentinel.dolomites.b4.tif")
nir_band   <- im.import("sentinel.dolomites.b8.tif")

# Define a grayscale color palette for initial visualization
gray_palette <- colorRampPalette(c("black", "grey", "light grey"))(100)

#### BLOCK 2: Individual Band Visualization (Grayscale) ####

# Plot the Blue band
plot(blue_band, col = gray_palette, main = "Sentinel-2: Blue Band")

# Plot the Green band
plot(green_band, col = gray_palette, main = "Sentinel-2: Green Band")

# Plot the Red band
plot(red_band, col = gray_palette, main = "Sentinel-2: Red Band")

# Plot the NIR band
plot(nir_band, col = gray_palette, main = "Sentinel-2: NIR Band")

#### BLOCK 3: Multiframe Layout of Bands ####

# Arrange a 2x2 plotting layout to compare all bands using the grayscale palette
par(mfrow = c(2, 2))
plot(blue_band,  col = gray_palette, main = "Blue")
plot(green_band, col = gray_palette, main = "Green")
plot(red_band,   col = gray_palette, main = "Red")
plot(nir_band,   col = gray_palette, main = "NIR")
dev.off()  # Reset plotting parameters

#### BLOCK 4: Creating a Raster Stack ####

# Combine the bands into a single raster stack.
# Note: The order is preserved as: Blue (1), Green (2), Red (3), NIR (4)
sentinel_stack <- c(blue_band, green_band, red_band, nir_band)

# Visualize the entire stack using the grayscale palette.
plot(sentinel_stack, col = gray_palette, main = "Sentinel Stack (Grayscale)")

# Plot individual layers from the stack: Blue (first) and NIR (fourth)
dev.off()  # Reset layout
plot(sentinel_stack[[1]], col = gray_palette, main = "Stack Layer 1: Blue")
plot(sentinel_stack[[4]], col = gray_palette, main = "Stack Layer 4: NIR")

#### BLOCK 5: Visualization with Custom Color Palettes ####

dev.off()

# Define custom color palettes for each band
blue_palette  <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
green_palette <- colorRampPalette(c("dark green", "green", "light green"))(100)
red_palette   <- colorRampPalette(c("dark red", "red", "pink"))(100)
nir_palette   <- colorRampPalette(c("brown", "orange", "yellow"))(100)

# Arrange a 2x2 multiframe to display each band with its custom color scheme
par(mfrow = c(2, 2))
plot(blue_band,  col = blue_palette,  main = "Blue Band")
plot(green_band, col = green_palette, main = "Green Band")
plot(red_band,   col = red_palette,   main = "Red Band")
plot(nir_band,   col = nir_palette,   main = "NIR Band")
  

#### BLOCK 6: RGB Composite Visualization ####

dev.off()

# Generate RGB composites using the sentinel stack.
# Note on band order in sentinel_stack:
#   [[1]] = Blue, [[2]] = Green, [[3]] = Red, [[4]] = NIR

# Natural color composite: Red (band 3), Green (band 2), Blue (band 1)
im.plotRGB(sentinel_stack, r = 3, g = 2, b = 1)
title("Natural Color Composite")

# False color composite 1: NIR (band 4), Red (band 3), Green (band 2)
im.plotRGB(sentinel_stack, r = 4, g = 3, b = 2)
title("False Color Composite 1")

# False color composite 2: Red (band 3), NIR (band 4), Green (band 2)
im.plotRGB(sentinel_stack, r = 3, g = 4, b = 2)
title("False Color Composite 2")

# False color composite 3: Red (band 3), Green (band 2), NIR (band 4)
im.plotRGB(sentinel_stack, r = 3, g = 2, b = 4)
title("False Color Composite 3")

