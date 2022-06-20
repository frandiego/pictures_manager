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

main(PATH)
