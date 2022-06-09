new_location <- function(filename){
  time = gsub('[^0-9]','',basename(filename))
  file.path(dirname(filename), substr(time, 1,4), 
            substr(time, 5,6), basename(filename))
}