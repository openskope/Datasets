# Script for estimating the
# maize dry-farming niche reported in Bocinsky et al. 2016:
# Bocinsky, R. K., Rush, J., Kintigh, K. W., and Kohler, T. A. (2016). 
# Exploration and exploitation in the macrohistory of the pre-Hispanic 
# Pueblo Southwest. Science Advances, 2:e1501532.
# Raw GDD and precipitation estimates are available from NOAA:
# https://www.ncdc.noaa.gov/cdo/f?p=519:1:0::::P1_STUDY_ID:19783

library(FedData)
library(magrittr)
library(tidyverse)

dir.create("./data/",
           showWarnings = FALSE,
           recursive = TRUE)

# Set the niche parameters
## The niche for each year is taken to be 
## water-year precipitation >= 30cm and 
## growing-season GDD >= 1800 (1000 GDD in centigrade)
min_precip <- 300
min_gdd <- 1800


url <- "http://www1.ncdc.noaa.gov/pub/data/paleo/treering/reconstructions/northamerica/usa/bocinsky2016/"
req <- httr::GET(url)
files <- XML::readHTMLTable(rawToChar(req$content), stringsAsFactors = FALSE)[[1]]$Name
files <- files[grep("nc4", files)]

tiles <- purrr::map_chr(stringr::str_c(url, files),
            FedData::download_data,
            destdir = "./data/paleocar",
            nc = TRUE)

tiles %>%
  stringr::str_extract_all("[0-9]+.*") %>%
  stringr::str_replace_all("\\_.*","") %>%
  unique() %>%
  purrr::map_chr(function(loc){
      
    ppt <- raster::brick(tiles %>%
                           stringr::str_subset(
                             stringr::str_c(loc,"_","PPT")
                           )) %>%
      raster::readAll()  %>%
      magrittr::is_weakly_greater_than(min_precip)
    
    gdd <- raster::brick(tiles %>%
                           stringr::str_subset(
                             stringr::str_c(loc,"_","GDD")
                           )) %>%
      raster::readAll()  %>%
      magrittr::is_weakly_greater_than(min_gdd)
    
    
    out <- (ppt * gdd)
    
    out %<>%
      raster::setValues(out[] %>% as.logical())
    
    raster::dataType(out) <- "LOG1S"
    
    out %>%
     raster::writeRaster(stringr::str_c("./data/",
                                        loc,"_","NICHE.nc"),
                         varname = "Niche",
                         varunit = "logical",
                         longname = "Logical niche inclusion: '1' if in the niche, '0' otherwise.",
                         zname = "Year AD",
                         zunit = "Years",
                        overwrite = T)
    
    file.rename(stringr::str_c("./data/",
                               loc,"_","NICHE.nc"),
                stringr::str_c("./data/",
                               loc,"_","NICHE.nc4"))
    
    stringr::str_c("gdal_translate -of netCDF ",
                   "-co COMPRESS=DEFLATE ",
                   "-co ZLEVEL=9 ",
                   # "-co FORMAT=NC4 ",
                   "./data/", loc, "_", "NICHE.nc4 ",
                   "./data/", loc, "_", "NICHE.nc") %>%
      system()
    
    unlink(stringr::str_c("./data/",
                          loc,"_","NICHE.nc4"))
    
    return(stringr::str_c("./data/",
                          loc,"_","NICHE.nc"))
    
  })
