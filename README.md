# SnowDepthAnalysis
R function for calculating the Multivariate Snow Index (MSI) for snow depth.
This repository contains the `MSI_fun_single` function for calculating the Multivariate Snow Index (MSI) for snow depth data.

## Function Overview

The `MSI_fun_single` function identifies the number of days where snow depth (`SD`) is greater than or equal to the 50th percentile (`P50`) and calculates the cumulative snow excess starting from the third consecutive day.

### Usage

```R
data <- SD_initial(data)
result <- MSI_fun_single(data, refperiod_start = 2008, refperiod_end = 2018)
