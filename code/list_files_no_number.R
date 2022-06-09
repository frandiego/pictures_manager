list_files_no_number <- function(path){
  ls = list.files(path, full.names = T)
  mask = grepl('[a-z]',tolower(substr(basename(ls), 1, 4)))
  no_dir = !unname(sapply(ls, dir.exists))
  # get only those that do not start with numbers
  ls[mask & no_dir]
}
