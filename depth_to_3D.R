# Load necessary libraries
install.packages("OpenImageR", dependencies = TRUE)
install.packages("rgl", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)

library(OpenImageR)
library(rgl)
library(ggplot2)

# Function to load the depth map
load_depth_map <- function(depth_path) {
  if (!file.exists(depth_path)) {
    stop("File not found: ", depth_path)
  }
  
  depth_map <- readImage(depth_path)
  if (is.null(depth_map) || length(depth_map) == 0) {
    stop("Invalid depth map: ", depth_path)
  }
  
  if (length(dim(depth_map)) == 3) {
    depth_map <- rowMeans(depth_map, dims = 2)  # Convert to grayscale
  }
  
  return(depth_map)
}

# Function to convert depth map to 3D point cloud
depth_to_point_cloud <- function(depth, focal_length, image_size) {
  if (is.null(depth) || any(is.na(depth))) {
    stop("Invalid depth map data")
  }
  
  h <- image_size[1]
  w <- image_size[2]
  fx <- fy <- focal_length
  cx <- w / 2
  cy <- h / 2
  
  xy_grid <- expand.grid(x = seq_len(w), y = seq_len(h))
  depth_values <- as.vector(depth)
  
  X <- (xy_grid$x - cx) * depth_values / fx
  Y <- (xy_grid$y - cy) * depth_values / fy
  Z <- depth_values
  
  point_cloud <- na.omit(cbind(X, Y, Z))
  
  return(point_cloud)
}

# Function to visualize the 3D point cloud
visualize_point_cloud <- function(point_cloud) {
  if (nrow(point_cloud) == 0) {
    stop("No valid points to visualize")
  }
  
  plot3d(point_cloud[,1], point_cloud[,2], point_cloud[,3], 
         col = "blue", size = 1, xlab = "X", ylab = "Y", zlab = "Z")
}

# Main function
main <- function(depth_path, focal_length) {
  print("Loading depth map...")
  depth_map <- load_depth_map(depth_path)
  print(paste("Depth map loaded with size:", paste(dim(depth_map), collapse = "x")))
  
  print("Generating 3D Point Cloud...")
  point_cloud <- depth_to_point_cloud(depth_map, focal_length, dim(depth_map))
  print("3D Point Cloud generated.")
  
  visualize_point_cloud(point_cloud)
}

# Execute with example depth map path and focal length
depth_path <- "data/example_depth.png"
focal_length <- 500

main(depth_path, focal_length)
