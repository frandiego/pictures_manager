# devtools::install_github("JoshOBrien/exiftoolr")
# exiftoolr::install_exiftool()
# install.packages('furrr')
rm(list = ls())
library(future)
library(furr)

source('code.R')
INPUT_PATH = '~/Desktop/NEW'
OUTPUT_PATH = '~/Desktop/ITALY'


move_files <- function(input, output, n_cores=10){
  plan(multisession, workers = n_cores)
  ls = list_files(input)
  dates = furrr::future_map(ls, original_exif_date)
  sizes = furrr::future_map(ls, ~sprintf("%010d", file.info(.)[['size']]))
  names = furrr::future_map2(dates, sizes, 
                             function(x,y){paste0(gsub(':| ','-',x), '-', y)})
  extensions = unlist(sapply(strsplit(basename(ls), '\\.'), 
                             function(x) tail(x,1)))
  basenames = paste0(unlist(names),'.' ,extensions)
  outputfiles = file.path(output, basenames)
  furrr::future_walk2(ls, outputfiles, 
                      function(x,y){file.rename(x,y)})
  
  
}
move_files(INPUT_PATH, OUTPUT_PATH)
