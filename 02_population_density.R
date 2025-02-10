################################################################################
# This script demonstrates how to work with spatial point data by:
# 1. Loading and exploring the 'bei' and 'bei.extra' datasets.
# 2. Adjusting plot parameters (point size, symbol type).
# 3. Extracting and visualizing elevation data.
# 4. Converting point data into a continuous density surface.
# 5. Customizing plot layouts and color palettes.
################################################################################


#### BLOCK 1: Setup and Data Loading ####

# Load the spatstat package (install if needed)
# install.packages("spatstat")
library(spatstat)

# The 'bei' dataset contains point pattern data (see:
# https://CRAN.R-project.org/package=spatstat for data description)
# Assign the 'bei' dataset to a new variable for clarity.
points_data <- bei  
print(points_data)  # Display the dataset summary


#### BLOCK 2: Basic Plotting of Point Data ####

# Default plot of the point pattern
plot(points_data, main = "Default Plot of bei Data")

# Adjust point size using 'cex' (here, points are reduced in size)
plot(points_data, cex = 0.2, main = "bei Data with Reduced Point Size")

# Change the point symbol to solid circles using 'pch'
plot(points_data, cex = 0.2, pch = 19, main = "bei Data with Solid Circle Points")


#### BLOCK 3: Exploring the Additional Dataset ####

# 'bei.extra' contains extra attributes; inspect and plot its content
print(bei.extra)
plot(bei.extra, main = "Overview of bei.extra Dataset")

# Extract elevation data from bei.extra
elev_data <- bei.extra$elev
plot(elev_data, main = "Elevation Data Extracted from bei.extra")

# Alternative extraction of elevation data using double brackets
elev_data_alt <- bei.extra[[1]]
plot(elev_data_alt, main = "Elevation Data (Alternative Extraction)")


#### BLOCK 4: Creating a Continuous Density Surface ####

# Convert the point pattern into a continuous density map
density_surface <- density(points_data)
plot(density_surface, main = "Density Map from bei Data")
# Overlay the original points for reference
points(points_data, cex = 0.2)


#### BLOCK 5: Comparative Layouts for Multiple Maps ####

# Arrange two plots side by side: elevation and density maps
par(mfrow = c(1, 2))
plot(elev_data_alt, main = "Elevation Data")
plot(density_surface, main = "Density Surface")
# Reset layout to default (clearing the multi-frame)
dev.off()

# Arrange plots one above the other (vertical layout)
par(mfrow = c(2, 1))
plot(elev_data_alt, main = "Elevation Data (Top)")
plot(density_surface, main = "Density Surface (Bottom)")
# Clear the multi-frame settings again
dev.off()

#### BLOCK 6: Customizing Color Palettes ####

# Create custom color palettes using colorRampPalette
# Example 1: Warm color palette (red to yellow)
warm_palette <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(density_surface, col = warm_palette, main = "Density Map with Warm Palette")

# Example 2: A cooler, pastel-inspired palette
cool_palette <- colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
plot(density_surface, col = cool_palette, main = "Density Map with Cool Palette")

#### BLOCK 7: Side-by-Side Comparison of Color Palettes ####

# Compare two different color palettes side by side
par(mfrow = c(1, 2))

# Left plot with the cool pastel palette
plot(density_surface, col = cool_palette, main = "Cool Palette")

# Right plot with a green-themed palette
green_palette <- colorRampPalette(c("green4", "green3", "green2", "green1", "green"))(100)
plot(density_surface, col = green_palette, main = "Green-Themed Palette")

dev.off()
