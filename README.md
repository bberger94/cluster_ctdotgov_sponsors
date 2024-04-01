# Cluster biopharma firms from ClinicalTrials.gov and link to outside sources

## Overview

This project focuses on cleaning, clustering, and analyzing sponsor names from ClinicalTrials.gov. The aim is to consolidate disparate sponsor names, identify common sponsors, and link them with drug approval dates. 

## Getting Started

### Prerequisites

- R 
- R packages: `tidyverse`, `feather`, `tm`, `tidytext`, `countrycode`, `proxyC`, `apcluster`, `gtsummary`
- GNU make

### Installation

1. Clone this repository to your local machine using `git clone`.
2. Open the `cluster_ctdotgov_sponsors.Rproj` in RStudio to set up the project environment.
3. Install the required R packages.

## Usage

The project consists of several R scripts.

1. `clean_sponsor_names.R` - Cleans the sponsor names data for consistency.
2. `cluster_ctdotgov_sponsors.R` - Performs clustering on the consolidated sponsor names to identify unique entities.
3. `join_drugsatfda_approvals.R` - Joins the cleaned sponsor names with drug approval dates from the Drugs@FDA database.

You can run the code sequentially by calling `make`.

## Data

- `drug_approval_dates.csv`: Contains drug approval dates for clinicaltrials.gov sponsors.
- `firm_xwalk.csv`: Crosswalk file that assigns consolidated firm IDs to clinicaltrials.gov sponsors.
