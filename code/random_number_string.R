random_number_string <- function(n=3){
  as.character(substr(gsub('\\.','',as.character(runif(1)*100)),1,3))
}