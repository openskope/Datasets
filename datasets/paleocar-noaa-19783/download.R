# Script for estimating the
# maize dry-farming niche reported in Bocinsky et al. 2016:
# Bocinsky, R. K., Rush, J., Kintigh, K. W., and Kohler, T. A. (2016). 
# Exploration and exploitation in the macrohistory of the pre-Hispanic 
# Pueblo Southwest. Science Advances, 2:e1501532.
# Raw GDD and precipitation estimates are available from NOAA:
# https://www.ncdc.noaa.gov/paleo-search/study/19783
# 
# Paleocar models and CAR scores are archived with Zenodo:
# https://doi.org/10.5281/zenodo.1193807

# install.packages("FedData")
# install.packages("magrittr")
# install.packages("tidyverse")
# install.packages("httr")
# install.packages("XML")
# devtools::install_github("bocinsky/paleocar")

library(FedData)
library(magrittr)
library(tidyverse)
library(paleocar)

# Set the niche parameters
## The niche for each year is taken to be 
## water-year precipitation >= 30cm and 
## growing-season GDD >= 1800 (1000 GDD in centigrade)
min_precip <- 300
min_gdd <- 1800

# Set a directory for output
output_dir <- "./data/"

dir.create(output_dir,
           showWarnings = FALSE,
           recursive = TRUE)


#### Getting the Precipitation and GDD Estimates ####
# Download the precipitation and temperature reconstruction data
url <- "http://www1.ncdc.noaa.gov/pub/data/paleo/treering/reconstructions/northamerica/usa/bocinsky2016/"
req <- httr::GET(url)
files <- XML::readHTMLTable(rawToChar(req$content), stringsAsFactors = FALSE)[[1]]$Name
files <- files[grep("nc4", files)]

tiles <- stringr::str_c(url, files) %>%
  purrr::map_chr(FedData::download_data,
                        destdir = output_dir,
                        nc = TRUE)
  
#### Getting the Maize Niche Estimates ####
# Calculate the maize niche tiles
tiles %>%
  basename() %>%
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
      raster::writeRaster(stringr::str_c(output_dir,
                                         loc,"_","NICHE.nc"),
                          datatype = "LOG1S",
                          varname = "Niche",
                          varunit = "logical",
                          longname = "Logical niche inclusion: '1' if in the niche, '0' otherwise.",
                          zname = "Year AD",
                          zunit = "calendar years since 0000-01-01",
                          overwrite = T)
   
    return(stringr::str_c(output_dir,
                          loc,"_","NICHE.nc"))
    
  })


#### Getting the Precipitation and GDD Uncertainty Estimates ####
c("PPT_models.zip",
          "GDD_models.zip") %>%
  stringr::str_c("https://zenodo.org/record/1193807/files/",.) %>%
  purrr::map_chr(FedData::download_data,
                 destdir = output_dir,
                 nc = TRUE) %T>%
  purrr::walk(unzip,
              exdir = output_dir) %>%
  stringr::str_replace_all("\\.zip","") %>%
  purrr::map(list.files,
             full.names = TRUE) %>%
  unlist() %>%
  purrr::map(function(x){
    
    var <- x %>%
      basename() %>%
      stringr::str_replace_all("\\_.*","")
    
    loc <- x %>%
      basename() %>%
      stringr::str_replace_all(".*\\_","") %>%
      stringr::str_replace_all("\\..*","")
    
    out.file <- stringr::str_c(output_dir,"/",
                               loc,"_",
                               var,"_",
                               "UNCERTAINTY.nc")
    
    cat(x, "\n")
    
    if(file.exists(out.file))
      return(out.file)
    
    out <- x %>%
      readr::read_rds() %>%
      paleocar::uncertainty_paleocar_models() %>%
      round()
    
    out %>%
      raster::writeRaster(out.file,
                          datatype=ifelse(max(out[], na.rm = T) < 127, 'INT1S', 'INT2S'),
                          varname = stringr::str_c(var,
                                                   " Uncertainty"),
                          varunit = ifelse(var == "GDD", "GDD", "mm"),
                          longname = ifelse(var == "GDD", "Fahrenheit Growing Degree Days", "millimeters of precipitation"),
                          zname = "Year AD",
                          zunit = "calendar years since 0000-01-01",
                          overwrite = T)

    
  })

