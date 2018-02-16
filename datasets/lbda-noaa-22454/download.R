library(FedData)
library(magrittr)

dir.create("./data/",
           showWarnings = FALSE,
           recursive = TRUE)

"https://www1.ncdc.noaa.gov/pub/data/paleo/drought/LBDP-v2/lbda-v2_kddm_pmdi_2017.nc" %>%
  FedData::download_data(destdir = "./data")
