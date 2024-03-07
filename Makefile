
# --- Identify firms with approved drugs by linking firms to approved drugs from Drugs@FDA --- #
data/drug_approval_dates.feather: \
	data/firm_xwalk.feather \
	join_drugsatfda_approvals.R \
	clean_sponsor_names.R
	Rscript join_drugsatfda_approvals.R >& logs/join_drugsatfda_approvals.log

# --- Cluster firm names to create unique firm identifiers --- #
data/firm_xwalk.feather: \
	cluster_ctdotgov_sponsors.R \
	clean_sponsor_names.R
	Rscript cluster_ctdotgov_sponsors.R >& logs/cluster_ctdotgov_sponsors.log
