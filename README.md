\# Depth Map to 3D Point Cloud in R

This project converts a depth map into a 3D point cloud using R.

\## Features - Load depth maps from images - Convert depth maps to 3D
point clouds - Visualize the 3D data using \`rgl\`

\## Installation Run the following command to install required packages:
\`\`\`r install.packages(c("OpenImageR", "rgl", "ggplot2"))

Note:
The output may look like a cluster of points rather than a perfect 3D shape because depth maps usually 
have noise and may not perfectly represent the true structure of objects. If you see a disordered cloud,
it indicates that the depth map quality or the focal length value may need adjustment.
