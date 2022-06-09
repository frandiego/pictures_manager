reorder_files <- function(path){
  ls = list_files_number(path)
  ls_new = unname(sapply(ls, new_location))
  for (i in seq_along(ls)){
    file.rename(ls[i], ls_new[i])
  }
}