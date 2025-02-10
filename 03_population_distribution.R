################################################################################
# This script demonstrates:
# 1. Loading a species occurrence shapefile from the sdm package.
# 2. Separating presence (Occurrence == 1) and absence (Occurrence == 0) records.
# 3. Visualizing the data using different plot layouts.
# 4. Overlaying covariate (elevation) information with custom color schemes.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load required libraries (install if necessary)
# install.packages("sdm")
# install.packages("terra")
library(sdm)
library(terra)

# Locate the species shapefile provided by the sdm package
species_file <- system.file("external/species.shp", package = "sdm")
# Display the file path (for reference)
print(species_file)

# Read the shapefile into a spatial vector object using terra's vect() function
species_points <- vect(species_file)
print(species_points)  # Display summary of the data

# Inspect the occurrence attribute that indicates presence (1) or absence (0)
species_points$Occurrence

#### BLOCK 2: Basic Plotting and Data Subsetting ####

# Plot the full species dataset
plot(species_points, main = "All Species Occurrence Records")

# Extract and plot presence records (Occurrence equals 1)
presence_points <- species_points[species_points$Occurrence == 1]
plot(presence_points, main = "Presence Records")

# --- Comparative Multiframe Plots ---

# Plot the complete dataset and the presence subset side by side
par(mfrow = c(1, 2))
plot(species_points, main = "All Species Records")
plot(presence_points, main = "Presence Records")
dev.off()  # Reset plot layout

# Extract and plot absence records (Occurrence equals 0)
absence_points <- species_points[species_points$Occurrence == 0]
plot(absence_points, main = "Absence Records")

# Plot presence and absence records side by side (horizontal layout)
par(mfrow = c(1, 2))
plot(presence_points, main = "Presence")
plot(absence_points, main = "Absence")
dev.off()  # Reset plot layout

# Plot presence and absence records in a vertical (stacked) layout
par(mfrow = c(2, 1))
plot(presence_points, main = "Presence (Top)")
plot(absence_points, main = "Absence (Bottom)")
dev.off()  # Reset plot layout

# Overlay plot: Display presences in blue and absences in red on one figure
plot(presence_points, col = "blue", pch = 19, cex = 2,
     main = "Overlay: Presences (Blue) and Absences (Red)")
points(absence_points, col = "red", pch = 19, cex = 2)

#### BLOCK 3: Covariate Analysis with Elevation ####

# Locate the elevation raster (ASCII grid) provided by the sdm package
elevation_file <- system.file("external/elevation.asc", package = "sdm")
print(elevation_file)

# Load the elevation data as a raster object using terra's rast() function
elevation_raster <- rast(elevation_file)

# Customize the elevation map colors using a colorRampPalette
elev_colors <- colorRampPalette(c("green", "hotpink", "mediumpurple"))(100)
plot(elevation_raster, col = elev_colors, main = "Elevation Map with Custom Colors")

# Overlay presence points on the elevation map to see their spatial relation
points(presence_points, pch = 19, col = "black", cex = 1.5)

# Reset plotting parameters
dev.off()
