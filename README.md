# Multivariate Snow Index

R functions for postprocessing and calculating the Multivariate Snow Index (MSI) based on daily snow depth data proposed in **Albalat et al. (2025)**.

## Functions overview

This repository contains two main functions:

1.  `SD_initial`: postprocess the original daily snow depth time series to retrieve the main variables needed for computing the MSI. The input data required to run this function requires to main variables, one containing the time steps and the other the snow depth. This function returns several metrics related to the snow depth data, such as the **fresh snow** (daily difference in snow depth), **snow cover presence-absence**, among others.

2.   `MSI_fun_single` function for calculating the Multivariate Snow Index (MSI) for snow depth data. This function identifies the number of days where snow depth (`SD`) is greater than or equal to the 50th percentile (`P50`) and calculates the cumulative snow excess starting from the third consecutive day.


### Example Data

The repository includes example data (`example_data.csv`) to demonstrate the use of the `SD_initial` and `MSI_fun_single` functions.

### Quick example

Needed libraries to run the following codes
```r
library(tidyverse)
library(zoo)
```

``` r
source("Functions/SD_initial.r")
source("Functions/MSI_fun_single.r")

example_data <- read.csv("data/exemple_data.csv")
processed_data <- SD_initial(example_data)
result <- MSI_fun_single(processed_data, 2008, 2020)
print(result)
```
