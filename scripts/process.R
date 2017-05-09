library(magrittr)

# Write velocity magnitude rasters
files <- "sources/GeoTIFFs/" %>%
  list.files("*.tif$", full.names = TRUE)
mid_times <- files %>%
  gsub("^.*_([0-9]{8})_([0-9]{4}).*$", "\\1\\2", .) %>%
  as.POSIXct(tz = "UTC", format = "%Y%m%d%H%M")
outfiles <- paste0("data/speed_", format(mid_times, "%Y%m%d%H%M"), ".tif")
files %>%
  raster::stack() %>%
  raster::writeRaster(outfiles, bylayer = TRUE, datatype = "FLT4S", progress = "text")

# Write velocity direction raster
V <- files[1] %>%
  raster::raster()
alpha <- "sources/Alpha_TrueFlowAngles-v6.mat" %>%
  R.matlab::readMat() %$%
  AlphaCorr %>%
  extract2(1) %>%
  raster::raster(xmn = 475363.476512225, xmx = 513078.476512225, ymn = 6769286.58090395, ymx = 6798441.58090395, crs = "+proj=utm +zone=6 +datum=WGS84 +units=m +no_defs") %>%
  raster::flip("y") %>%
  raster::resample(V) %>%
  multiply_by(pi) %>%
  divide_by(180)
raster::writeRaster(alpha, "data/direction.tif", datatype = "FLT4S", progress = "text")

# Write mean speed (time range) raster
files <- "sources/GeoTIFFs/" %>%
  list.files("*.tif$", full.names = TRUE)
mid_times <- files %>%
  gsub("^.*_([0-9]{8})_([0-9]{4}).*$", "\\1\\2", .) %>%
  as.POSIXct(tz = "UTC", format = "%Y%m%d%H%M")
time_range <- c("201410121900", "201410122000") %>%
  as.POSIXct(tz = "UTC", format = "%Y%m%d%H%M")
V_mean <- files[mid_times > min(time_range) & mid_times < max(time_range)] %>%
  raster::stack() %>%
  raster::calc(mean)
outfile <- paste0("data/speed_", format(min(time_range), "%Y%m%d%H%M"), "_", format(max(time_range), "%Y%m%d%H%M"), ".tif")
raster::writeRaster(V_mean, outfile, datatype = "FLT4S", progress = "text")