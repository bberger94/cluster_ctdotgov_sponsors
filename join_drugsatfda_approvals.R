# --------------------------------------------------------------- #
# Join Drugs@FDA approved drugs to trial sponsors
# --------------------------------------------------------------- #

library(tidyverse)
library(lubridate)
library(tm)
library(fuzzyjoin)
library(gtsummary)


# ---------------------- #
# Load cleaning function
# ---------------------- #
source("src/process_data/clean_sponsor_names.R")

# --------------- #
# Load data
# --------------- #
# Load trial sponsor to firm id crosswalk
firm_xwalk <- readRDS("data/intermediate/xwalks/firm_xwalk.RDS")

# Load Drugs@FDA sponsors
drugsatfda_applications <- read_tsv("data/raw/drugsatfda/2022-08-23/Applications.txt",
                                    col_types = "cccc") 

# Load Drugs@FDA application submission info
drugsatfda_submissions <- suppressWarnings(
  read_tsv("data/raw/drugsatfda/2022-08-23/Submissions.txt",
           col_types = "cicicTcc"))

# ------------------------------------- #
# Clean trial and drug sponsors
# ------------------------------------- #
# Identify trial sponsors from ctdotgov
ctdotgov_corpus_names <- unique(sort(firm_xwalk$corpus_name))

# Create drug sponsors from drugsatfda
drugsatfda_corpus_names <- unique(sort(drugsatfda_applications$SponsorName))

# Create corpus
corpus_A <- Corpus(VectorSource(c(ctdotgov_corpus_names, drugsatfda_corpus_names)))

# Clean firm names
corpus_B <- clean_sponsor_names(corpus_A, stem = FALSE)

length(ctdotgov_corpus_names) + length(drugsatfda_corpus_names)

# ------------------------------------- #
# Create document term matrices
# ------------------------------------- #
# Create document term matrix with all rows
full_dtm <- corpus_B %>% 
  DocumentTermMatrix(list(wordLengths = c(1, Inf))) 

# Select subset of rows for ctdotgov firms
ctdotgov_dtm <- full_dtm %>% 
  head(length(ctdotgov_corpus_names)) %>% 
  weightTfIdf() %>%
  as.matrix()

# Select subset of rows for drugsatfda firms
drugsatfda_dtm <- full_dtm %>% 
  tail(length(drugsatfda_corpus_names)) %>%
  weightTfIdf() %>%
  as.matrix()

# ------------------------------------- #
# Link trial sponsors to drug sponsors
# ------------------------------------- #
simils <- proxyC::simil(ctdotgov_dtm, drugsatfda_dtm, method = "cosine")

# For each ctdotgov sponsor, find Drugs@FDA sponsor that is most similar
matches <- tibble(ctdotgov_corpus_name = ctdotgov_corpus_names,
                  match_id = apply(simils, 1, which.max),
                  similarity = apply(simils, 1, max),
                  drugsatfda_name = drugsatfda_corpus_names[match_id]) 


# Filter out bad matches
good_matches <- matches %>% 
  filter(similarity >= 0.75) %>% 
  select(-match_id)

# Join with rest of data
matched_firms <- firm_xwalk %>% 
  left_join(good_matches, c("corpus_name" = "ctdotgov_corpus_name")) %>% 
  select(firm_id, firm_name, ctdotgov_name, drugsatfda_name, n_trials) 


# ------------------------------------------------ #
# Get drug approval dates
# ------------------------------------------------ #
approval_dates <- drugsatfda_submissions %>%
  filter(SubmissionType == "ORIG") %>%
  group_by(ApplNo) %>%
  summarize(approval_date = as_date(min(SubmissionStatusDate)))


# ------------------------------------------------------------ #
# Get first approval date for each Drugs@FDA sponsor
# ------------------------------------------------------------ #
drugsatfda_first_approvals <- drugsatfda_applications %>%
  # Join approval dates
  inner_join(approval_dates, by = "ApplNo") %>%
  rename(drugsatfda_name = SponsorName) %>%
  # Get date of first approval for each sponsor
  group_by(drugsatfda_name) %>% 
  summarize(n_approvals = n(),
            first_approval_date = min(approval_date),
            .groups = "drop")


# ------------------------------------------------------------ #
# Aggregate approvals to the firm level
# ------------------------------------------------------------ #
drug_approval_dates <- matched_firms %>%
  left_join(drugsatfda_first_approvals, by = "drugsatfda_name") %>%
  # Aggregate to firm level
  group_by(firm_id, firm_name) %>%
  summarize(n_trials = sum(n_trials),
            first_approval_date = min(replace_na(first_approval_date, as_date(Inf))),
            n_approvals = sum(replace_na(n_approvals, 0)),
            .groups = "drop") 


# ------------------------------------------------------------ #
# Print diagnostics
# ------------------------------------------------------------ #
# Check that we get a decent number of matches
drug_approval_dates %>% 
  transmute("Total Trials" = n_trials,
            "Total Approvals" = n_approvals,
            "Any Approval" = first_approval_date < Inf) %>% 
  tbl_summary(
    statistic = list(all_continuous() ~ "{mean} ({sd})", 
                     all_categorical() ~ "{n} ({p}%)"),
    digits = ~ c(1, 1)) %>% 
  as_tibble() %>% 
  print()

# Check that more trials associated with more approvals
print(summary(lm(n_approvals ~ n_trials, drug_approval_dates)))


# ---------- #
# Save data
# ---------- #
saveRDS(drug_approval_dates, "data/intermediate/drug_approval_dates.RDS")



