# --------------------------------------------------------------- #
# Convert files to CSV for compatability
# --------------------------------------------------------------- #
library(tidyverse)
library(feather)

# Read data into a list
data <- list(
	firm_xwalk = read_feather("firm_xwalk.feather"),
	drug_approval_dates = read_feather("drug_approval_dates.feather")
)

# Save each dataset as a CSV
walk2(data, names(data), function(d, name){
	path <- paste0(name, ".csv")
	write_csv(d, path)
})
		 
