create_folders <- function(path){
  bnames = unname(sapply(list_files_number(path), basename))
  times = unique(gsub('[^0-9]', '', bnames))
  months = unique(substr(times, 1, 6))
  folders = paste0(substr(months, 1, 4), '/', substr(months, 5, 6))
  sapply(file.path(path, folders), function(x) dir.create(x, recursive = T))
  
}