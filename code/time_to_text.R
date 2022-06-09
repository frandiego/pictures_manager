time_to_text <- function(time, min_year = 2022){
  timetext = gsub('-|:| ', '', as.character(time))
  if (substr(timetext, 1, 4) > as.character(min_year)){
    # check if higher than 222
    timetext <- paste0(as.character(min_year), 
                       substr(timetext, 5, nchar(timetext)))
  }
  return(paste0(timetext, random_number_string(3)))
}
