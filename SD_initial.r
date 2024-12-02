#' SD_initial
#'
#' This function preprocesses snow data, adding essential columns required for
#' the `MSI_fun_single` function. It calculates seasonal classifications, snow
#' depth metrics, and other derived variables.
#'
#' @param data A data frame containing raw snow data with the following columns:
#' - `datetime`: Date of the observation in the format `%d/%m/%Y`.
#' - `SD`: Snow depth values (numeric).
#'
#' @return A processed data frame with additional columns:
#' - `datetime`: Converted to `Date` format.
#' - `month`: Extracted month from `datetime`.
#' - `year`: Extracted year from `datetime`.
#' - `dy`: Day of the year (1-365/366).
#' - `winseason`: Winter season year (e.g., 2008 for the 2008-2009 season).
#' - `season`: Label for the winter season (e.g., "2008-2009").
#' - `FS`: Fresh snow amount calculated as the daily difference in snow depth, where negative values are replaced with 0.
#' - `SC`: Snow on the ground indicator (1 if `SD >= 1`, otherwise 0).
#' - `SDay`: Snowfall day indicator (1 if fresh snow `FS >= 1`, otherwise 0).
#' - `SFD`: Snow-free day indicator (1 if fresh snow `FS == 0`, otherwise 0).
#'
#' @details
#' This function is specifically designed for use with snow depth datasets and
#' provides key derived variables for snow analysis. It supports the `MSI_fun_single`
#' function by adding seasonal classifications (`winseason`, `season`) and snow
#' depth metrics (`FS`, `SC`, `SDay`, `SFD`).
#'
#' @examples
#' # Example usage
#' raw_data <- data.frame(
#'   datetime = c("01/11/2008", "02/11/2008", "03/11/2008"),
#'   SD = c(0.5, 1.2, 0.8)
#' )
#'
#' processed_data <- SD_initial(raw_data)
#' print(processed_data)
#'
#' @export 
SD_initial <- function(data) {
  
  colnames(data) <- c("datetime", "SD")

  data <- data %>%
    mutate(datetime = as.Date(datetime, format = "%d/%m/%Y"),
           month = month(datetime),
           year = year(datetime),
           dy = yday(datetime),
           winseason = ifelse(month >= 1 & month <= 9, year - 1, year))
  
  # class winter seasons HN
  data$season = paste0(data$winseason, "-", data$winseason + 1)
  
  # Fresh Snow (FS)
  data$FS <- round(data$SD - lag(data$SD, 1), digits = 2)
  data$FS <- ifelse (data$FS <= 0, 0, data$FS)
  
  # Snow on the ground (SC)
  data$SC <- ifelse(data$SD >= 1, 1, 0)

  # Snow fall day (SDay)
  data$SDay <- ifelse(data$FS >= 1, 1, 0)
  
  # Snow free day (SFD)
  data$SFD <- ifelse(data$FS == 0, 1, 0)

  return(data)
}
