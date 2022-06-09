move_files_new_names <- function(path){
  ls <- lapply(list_files_no_number(path), new_name)
  for (file in ls){
    file.rename(from = file$origin, to = file$destination)
  }
  gc()
}