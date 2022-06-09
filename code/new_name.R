new_name <- function(filename){
  fi = file.info(filename)
  origin <- head(rownames(fi),1)
  extension <- tail(unlist(strsplit(basename(origin),'\\.')),1)
  newfile <- paste0(time_to_text(fi$ctime),'.', extension)
  list(origin=origin, destination = file.path(dirname(origin), newfile))
}
