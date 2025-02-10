################################################################################
# This script demonstrates:
# 1. Loading and classifying images using the imageRy package.
# 2. Performing classification on images of the Sun and Mato Grosso region.
# 3. Analyzing land cover changes through pixel frequency tables.
# 4. Visualizing results using ggplot2 and patchwork for side-by-side comparisons.
################################################################################

#### BLOCK 1: Setup and Data Loading ####

# Load required libraries (install if necessary)
library(terra)
library(imageRy)
library(ggplot2)
#install.packages("patchwork")
library(patchwork)

# List all available images in the working directory
im.list()

#### BLOCK 2: Image Classification - Solar Image ####

# Import the Sun image
sun_image <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# Perform classification into three clusters (brightest, medium, and least bright regions)
sun_classified <- im.classify(sun_image, num_clusters = 3)

# Display the classified image
plot(sun_classified, main = "Classified Solar Image (3 Clusters)")

#### BLOCK 3: Mato Grosso Classification ####

# Import Mato Grosso images from 1992 and 2006
mato_1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
mato_2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

# Classify the 1992 image into two clusters
mato_1992_classified <- im.classify(mato_1992, num_clusters = 2)

# Classify the 2006 image into two clusters
mato_2006_classified <- im.classify(mato_2006, num_clusters = 2)

# Display both classified images side by side
par(mfrow = c(1, 2))
plot(mato_1992_classified, main = "Mato Grosso - 1992 (2 Clusters)")
plot(mato_2006_classified, main = "Mato Grosso - 2006 (2 Clusters)")
dev.off()  # Reset plot layout

#### BLOCK 4: Pixel Frequency Analysis ####

# Compute and display pixel frequency for 1992
freq_1992 <- freq(mato_1992_classified)
total_pixels_1992 <- ncell(mato_1992_classified)
percent_1992 <- freq_1992 * 100 / total_pixels_1992
print(percent_1992)  # Display percentage table

# Compute and display pixel frequency for 2006
freq_2006 <- freq(mato_2006_classified)
total_pixels_2006 <- ncell(mato_2006_classified)
percent_2006 <- freq_2006 * 100 / total_pixels_2006
print(percent_2006)  # Display percentage table

#### BLOCK 5: Dataframe Creation for Land Cover Change ####

# Define the class labels
land_cover_class <- c("Forest", "Human")

# Store classification results for 1992 and 2006
cover_1992 <- c(83, 17)  # Forest (83%), Human-related areas & water (17%)
cover_2006 <- c(45, 55)  # Forest (45%), Human-related areas & water (55%)

# Create a structured dataframe
land_cover_table <- data.frame(land_cover_class, cover_1992, cover_2006)
print(land_cover_table)  # Display the table

#### BLOCK 6: Visualization with Bar Charts ####

# Generate bar plots for land cover distribution
plot_1992 <- ggplot(land_cover_table, aes(x = land_cover_class, y = cover_1992, fill = land_cover_class)) +
  geom_bar(stat = "identity", color = "black") + 
  ylim(c(0, 100)) +
  ggtitle("Land Cover - 1992")

plot_2006 <- ggplot(land_cover_table, aes(x = land_cover_class, y = cover_2006, fill = land_cover_class)) +
  geom_bar(stat = "identity", color = "black") + 
  ylim(c(0, 100)) +
  ggtitle("Land Cover - 2006")

# Arrange the plots using patchwork
plot_1992 + plot_2006  # Display side by side
plot_1992 / plot_2006  # Display stacked layout
