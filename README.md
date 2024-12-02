# SnowDepthAnalysis
R function for calculating the Multivariate Snow Index (MSI) for snow depth.
This repository contains the `MSI_fun_single` function for calculating the Multivariate Snow Index (MSI) for snow depth data.

## Function Overview

The `MSI_fun_single` function identifies the number of days where snow depth (`SD`) is greater than or equal to the 50th percentile (`P50`) and calculates the cumulative snow excess starting from the third consecutive day.

### Usage

```R
data <- SD_initial(data)
result <- MSI_fun_single(data, refperiod_start = 2008, refperiod_end = 2018)

### Example Data

The repository includes example data (`example_data.csv`) to demonstrate the use of the `SD_initial` and `MSI_fun_single` functions.

### Loading the Data
```R
example_data <- read.csv("data/example_data.csv")
processed_data <- SD_initial(example_data)
result <- MSI_fun_single(processed_data, 2008, 2020)
print(result)
