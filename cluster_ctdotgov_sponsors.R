# --------------------------------------------------------------- #
# Clean ctdotgov firm names and cluster
# --------------------------------------------------------------- #
library(tidyverse)
library(feather)

# Text processing
library(tm)
library(tidytext)

# Identify countries for use as stopwords
library(countrycode)

# Efficiently calculate cosine distance
library(proxyC)

# Affinity propogation clustering
library(apcluster)

# ------------------------------------ #
# Load dictionary and cleaning function
# ------------------------------------ #
source("clean_sponsor_names.R")

# ------------------------------------ #
# Load clinicaltrials.gov sponsor data
# ------------------------------------ #
trial_sponsors <- read_feather("data/ctdotgov/sponsors.feather")

# --------------------------------------------------------------- #
# 1. Clean firm names and create corpora
# --------------------------------------------------------------- #
# Create crosswalk between ctdotgov names and corpus names
ctdotgov_names <- trial_sponsors %>% 
	# Keep firms (drop universities, governments, other non-private entities)
	filter(lead_or_collaborator == "lead" & agency_class == "INDUSTRY") %>% 
	# Look-up corpus name if different from actual name
	mutate(ctdotgov_name = name,
				 corpus_name = coalesce(firm_dictionary[ctdotgov_name], ctdotgov_name)) %>% 
	# Count trials per firm name
	group_by(ctdotgov_name, corpus_name) %>% 
	summarize(n_trials = n(),
						.groups = "drop")

# Create vector of unique corpus names 
corpus_names <- sort(unique(ctdotgov_names$corpus_name))

# Create corpus
ctdotgov_corpus_A <- Corpus(VectorSource(corpus_names))

# Clean firm names
ctdotgov_corpus_B <- clean_sponsor_names(ctdotgov_corpus_A)

# Create document term matrix, weighting for term frequency
dtm <- ctdotgov_corpus_B %>% 
	DocumentTermMatrix(list(wordLengths = c(1, Inf))) %>%
	weightTfIdf() %>%
	tidy() %>% 
	cast_sparse(row = document, column = term, value = count, repr = "T")

# Print head and tail of corpus
inspect(head(ctdotgov_corpus_B, 20))
inspect(tail(ctdotgov_corpus_B, 20))

# Test that firms have at least 1 character in cleaned name
stopifnot(min(nchar(ctdotgov_corpus_B$content)) > 0)

# --------------------------------------------------------------- #
# 2. Cluster firm names according to similarity
# --------------------------------------------------------------- #

# Calculate cosine similarity
simils <- proxyC::simil(dtm, method = "cosine")

# Run affinity propogation clustering on subset of data
N <- nrow(simils)
s <- simils[1:N, 1:N]
system.time(apres <- apcluster(s, lam = 0.5, q = 0.99995, seed = 1))

# Link exemplars to terms
exemplars <- tibble(
	firm_id = as.integer(rownames(s)),
	row = 1:N,
	exrow = apres@idx,
	name = corpus_names[firm_id],
	exemplar_id = firm_id[exrow],
	exemplar_name = name[exrow]
) 

# Create unique firm IDs
firm_xwalk <- ctdotgov_names %>%
	left_join(exemplars, by = c("corpus_name" = "name")) %>% 
	# Re-select exemplars according to firm name with most trials
	group_by(exemplar_id) %>% 
	mutate(new_exemplar_name = ctdotgov_name[n_trials == max(n_trials)][1]) %>% 
	ungroup() %>% 
	select(ctdotgov_name, corpus_name, firm_id = exemplar_id, firm_name = new_exemplar_name, n_trials)

# ---------- #
# Save data
# ---------- #
write_feather(firm_xwalk, "firm_xwalk.feather")



