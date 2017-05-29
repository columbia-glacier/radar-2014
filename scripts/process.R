# ---- Install missing dependencies ----

packages <- c("magrittr", "raster", "R.matlab")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
library(magrittr)

# ---- Direction ----
# Convert the matrix of angles provided as a MATLAB .mat file to a GeoTIFF.

# Load a speed raster as reference
files <- file.path("sources", "GeoTIFFs") %>%
  list.files("\\.tif$", full.names = TRUE)
ref <- files[1] %>%
  raster::raster()
# Convert angle matrix to GeoTIFF
alpha <- file.path("sources", "Alpha_TrueFlowAngles-v6.mat") %>%
  R.matlab::readMat() %$%
  AlphaCorr %>%
  extract2(1) %>%
  raster::raster(xmn = 475363.476512225, xmx = 513078.476512225, ymn = 6769286.58090395, ymx = 6798441.58090395,
    crs = "+proj=utm +zone=6 +datum=WGS84 +units=m +no_defs") %>%
  raster::flip("y") %>%
  raster::resample(ref) %>%
  multiply_by(pi) %>%
  divide_by(180)
# Write to file
outfile <- file.path("data", "direction.tif")
raster::writeRaster(alpha, outfile, datatype = "FLT4S", progress = "text")

# ---- Speed ----
# Rename speed rasters by their time endpoints and write to smaller files.

# Extract mid times from filenames
mid_times <- files %>%
  gsub("^.*_([0-9]{8})_([0-9]{4}).*$", "\\1\\2", .) %>%
  as.POSIXct(tz = "UTC", format = "%Y%m%d%H%M")
# Generate new filenames from endpoints
dt <- 15 * 60 # seconds
outfiles <- paste0(
  file.path("data", "speed_"),
  format(mid_times - (dt / 2), "%Y%m%d%H%M"), "_", 
  format(mid_times + (dt / 2), "%Y%m%d%H%M"), ".tif"
)
# Write to file
files %>%
  raster::stack() %>%
  raster::writeRaster(outfiles, bylayer = TRUE, datatype = "FLT4S", progress = "text")
