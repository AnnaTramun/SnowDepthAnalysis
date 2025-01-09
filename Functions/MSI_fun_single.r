#' MSI_fun_single
#'
#' This function calculates the Multivariate Snow Index (MSI) for a single snow station.
#' It identifies the number of days (`SD_d`) where the snow depth (`SD`) is greater than
#' or equal to the 50th percentile (`P50`) and calculates the cumulative snow excess (`SD_i`)
#' starting from the third consecutive day exceeding `P50`.
#'
#' @param data A data frame containing snow data with the following columns:
#' - `datetime`: Date of the observation.
#' - `SD`: Snow depth.
#' - `month`: Month of the observation.
#' - `dy`: Day of the year.
#' - `winseason`: Winter season year.
#' - `season`: Winter season label (e.g., "2008-2009").
#' @param refperiod_start Numeric value indicating the start year of the reference period.
#' @param refperiod_end Numeric value indicating the end year of the reference period.
#'
#' @return A data frame summarizing the results for each winter season:
#' - `season`: Winter season label (e.g., "2008-2009").
#' - `winseason`: Winter season year.
#' - `SD_d`: Total number of days where `SD >= P50`.
#' - `SD_i`: Cumulative snow excess starting from the third consecutive day exceeding `P50`, normalized to a 181-day base.
#'
#' @details
#' The function calculates the 50th percentile (`P50`) of snow depth based on a centered
#' 31-day rolling mean for the reference period (`refperiod_start` to `refperiod_end`).
#' It uses this threshold to identify snow excess (`SD >= P50`) and calculates the cumulative
#' excess magnitude starting from the third consecutive day.
#'
#' Missing values are handled appropriately in the calculations using `na.rm = TRUE`.
#'
#' @examples
#' # Example usage
#' data <- data.frame(
#'   datetime = seq.Date(as.Date("2008-11-01"), as.Date("2009-04-30"), by = "day"),
#'   SD = runif(181, 0, 100),
#'   month = rep(c(11:12, 1:4), each = 30, length.out = 181),
#'   dy = 1:181,
#'   winseason = rep(2008, 181),
#'   season = rep("2008-2009", 181)
#' )
#'
#' result <- MSI_fun_single(data, refperiod_start = 2000, refperiod_end = 2010)
#' print(result)
#'
#' @export

MSI_fun_single <- function(data, refperiod_start, refperiod_end) {
  
  # Calculate the reference period thresholds
  data_threshold_ref <- data %>%
    filter(winseason >= refperiod_start & winseason <= refperiod_end) %>%
    mutate(centered_SD = round(zoo::rollapply(SD, width = 31, mean, align = "center", fill = NA), digits = 2)) %>%
    group_by(dy) %>%
    mutate(p50_SD = round(quantile(centered_SD, 0.50, na.rm = TRUE), digits = 2)) %>%
    ungroup() %>%
    filter(month %in% c(11:12, 1:4)) # Filter winter months
  
  # Merge reference data with main dataset
  SD_dat <- data %>%
    filter(month %in% c(11:12, 1:4)) %>%
    inner_join(select(data_threshold_ref, dy, month, p50_SD), by = c("dy", "month")) %>%
    distinct(datetime, .keep_all = TRUE) %>%
    mutate(pSD = ifelse(SD >= p50_SD, 1, 0)) %>%
    mutate(countSD = ifelse(pSD == 1, sequence(rle(as.character(pSD))$lengths), 0),
           diff = ifelse(pSD == 1, round((SD - p50_SD), digits = 2), 0)) %>%
  group_by(winseason, countSD >= 3) %>%
  mutate(SD_i = sum(diff)) %>%
  ungroup()
  
  # Summarize results for each winter season
  MSI <- SD_dat %>%
    #select(season, winseason, SD, pSD, SD_i) %>%
    group_by(season, winseason) %>%
    summarise(
      SD_d = sum(pSD, na.rm = TRUE), # Total days with SD >= P50
      SD_i = round(max(SD_i, na.rm = TRUE) / 181, digits = 2)) # excees of SD 
  
  return(MSI)
}


