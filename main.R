
# devtools::install_github("JoshOBrien/exiftoolr")
# exiftoolr::install_exiftool()

rm(list = ls())

PATH = '/Volumes/One Touch/raw'

list_files <- function(path){
  ls <- list.files(path, full.names = T, recursive = T) 
  ls[file.exists(ls)]
}

created_time_filename <- function(file){
  file_info = file.info(file)
  created_time = min(file_info$mtime, file_info$ctime)
  max_time = min(Sys.time(), file_info$atime)
  if(created_time > max_time){
    created_time <- paste0(substr(max_time, 1, 4), 
                           substr(created_time, 5, 100))
    Sys.setFileTime(file, created_time)
  }
  size = sprintf("%010d", file_info$size) %>% as.character()
  new_name = paste0(as.character(created_time), '-', size)
  new_name_clean = gsub(' |:', '-', new_name)
  extension = get_extension(file)
  file.path(dirname(file), paste0(new_name_clean, '.', extension))
  
}

get_extension <- function(file){
  tail(unlist(strsplit(basename(file), '\\.')),1)
}

get_last_created <- function(listed_files, file){
  sort(names(files_listed[files_listed==file]), F)[-1]
}

remove_duplicates <- function(files_listed){
  to_remove_table <- sort(table(files_listed ),T)
  to_remove <- names(to_remove_table[to_remove_table>1])
  rm_files = unlist(lapply(to_remove, function(x) get_last_created(files_listed, x)))
  for(file in rm_files){
    file.remove(file)
  }
}


change_original_date <- function(path, sign='+', years=0, months=0, days=0, hours=0, minutes=0, seconds=0){
  base = '-DateTimeOriginal'
  dates = paste0(c(years, months, days), collapse = ':')
  hours = paste0(c(hours, minutes, seconds), collapse = ':')
  newdates = paste0(base, sign, '=', dates, ' ', hours)
  exiftoolr::exif_call(args = normalizePath(path), newdates)
}

original_exif_date <- function(path){
  etime = exiftoolr::exif_read(path)$DateTimeOriginal
  time_to_pos(etime)
}

time_to_pos <- function(x){
  org_date = gsub(':','-',substr(x, 0, 10))
  org_secs = gsub('-',':',substr(x, 12, 19))
  org_time_format = paste(org_date, org_secs)
  as.POSIXct(org_time_format,tz=Sys.timezone())
}

get_original_time <- function(path){
  file = normalizePath(path)
  time_to_pos(substr(basename(file),0,19))
}


timediff_list <- function(path){
  original <- get_original_time(path)
  exif <- original_exif_date(path)
  timediff = as.integer(original - exif)
  sn = ifelse(sign(timediff)==-1,'-','+') 
  tdabs = ifelse(sign(timediff)==-1, timediff*-1, timediff)
  years = floor(tdabs/365.25)
  months = floor((tdabs-years * 365.25) / 30.417)
  days= floor((tdabs-years * 365.25) - months* 30.417)
  
  list(years=as.integer(years), 
       months=as.integer(months), 
       days=as.integer(days), 
       sign = sn)
}


change_date <- function(path){
  file = normalizePath(path)
  ls = timediff_list(file)
  change_original_date(file,sign = ls$sign,  
                       years=ls$years, months=ls$months, days=ls$days)
  
}


main <- function(path){
  ls <- sapply(list_files(path) , created_time_filename) 
  remove_duplicates(ls)
  old_files = names(ls)
  new_files = as.character(ls)
  for(i in seq_along(old_files)){
    if(file.exists(old_files[i])){
      file.rename(old_files[i], new_files[i])
    }
  }
}



