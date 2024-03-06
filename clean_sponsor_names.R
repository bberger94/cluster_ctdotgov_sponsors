

# --------------------------------------------------------------- #
# Define dictionary to replace firm names and stopwords to remove
# --------------------------------------------------------------- #
# Define dictionary to rename firms
firm_dictionary <- c(
  "Acceleron Pharma, Inc., a wholly-owned subsidiary of Merck & Co., Inc., Rahway, NJ USA" = "Acceleron Pharma, Inc.", 
  "Afferent Pharmaceuticals, Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Afferent Pharmaceuticals, Inc.", 
  "ArQule, Inc., a subsidiary of Merck Sharp & Dohme LLC, a subsidiary of Merck & Co., Inc. (Rahway, NJ USA)" = "ArQule, Inc.", 
  "Array Biopharma, now a wholly owned subsidiary of Pfizer" = "Array Biopharma",
  "Brainvectis, a subsidiary of Asklepios BioPharmaceutical, Inc. (AskBio)" = "Brainvectis", 
  "Cardiogenesis Corporation, a wholly-owned subsidiary of CryoLife, Inc." = "Cardiogenesis Corporation", 
  "CellMed AG, a subsidiary of BTG plc." = "CellMed AG", 
  "Cubist Pharmaceuticals LLC, a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Cubist Pharmaceuticals LLC", 
  "DICE Therapeutics, Inc., a wholly owned subsidiary of Eli Lilly and Company" = "DICE Therapeutics, Inc.",
  "GB001, Inc, a wholly owned subsidiary of Gossamer Bio, Inc."  = "Gossamer", 
  "GB002, Inc., a wholly owned subsidiary of Gossamer Bio, Inc." = "Gossamer", 
  "GB003, Inc., a wholly owned subsidiary of Gossamer Bio, Inc." = "Gossamer", 
  "GB004, Inc., a wholly owned subsidiary of Gossamer Bio, Inc." = "Gossamer", 
  "GB005, Inc., a wholly owned subsidiary of Gossamer Bio, Inc." = "Gossamer", 
  "GB006, Inc., a wholly owned subsidiary of Gossamer Bio, Inc." = "Gossamer",
  "Genzyme, a Sanofi Company" = "Genzyme", 
  "Hospira, now a wholly owned subsidiary of Pfizer" = "Hospira", 
  "Imago BioSciences, Inc., a subsidiary of Merck & Co., Inc., (Rahway, New Jersey USA)" = "Imago BioSciences, Inc.",
  "Immune Design, a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Immune Design",
  "Juno Therapeutics, a Subsidiary of Celgene" = "Juno Therapeutics", 
  "K-Group Alpha, Inc., a wholly owned subsidiary of Zentalis Pharmaceuticals, Inc." = "K-Group Alpha, Inc.",
  "K-Group, Beta, Inc., a wholly owned subsidiary of Zentalis Pharmaceuticals, Inc" = "K-Group Beta, Inc.",
  "Kanyos Bio, Inc., a wholly-owned subsidiary of Anokion SA" = "Kanyos Bio, Inc.", 
  "MDD US Operations, LLC a subsidiary of Supernus Pharmaceuticals" = "MDD US Operations, LLC",
  "Merck Healthcare KGaA, Darmstadt, Germany, an affiliate of Merck KGaA, Darmstadt, Germany" = "Merck Sharp and Dohme", 
  "Merck KGaA, Darmstadt, Germany" = "Merck Sharp and Dohme", 
  "NexMed (U.S.A.), Inc. (subsidiary of Apricus Biosciences, Inc.)" = "NexMed, Inc.", 
  "NovaCardia, Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "NovaCardia, Inc.",
  "Oncoethix GmbH, a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Oncoethix GmbH",
  "Oncoimmune, Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Oncoimmune, Inc.",
  "Optimer Pharmaceuticals LLC, a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Optimer Pharmaceuticals LLC",
  "Pacira CryoTech, Inc., a wholly owned subsidiary of Pacira BioSciences, Inc." = "Pacira", 
  "Peloton Therapeutics, Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Peloton Therapeutics, Inc.",
  "Perosphere Pharmaceuticals Inc, a wholly owned subsidiary of AMAG Pharmaceuticals, Inc." = "Perosphere",
  "Pfizer's Upjohn has merged with Mylan to form Viatris Inc." = "Viatris",
  "PGEN Therapeutics, Inc., a subsidiary of Precigen, Inc." = "PGEN Therapeutics, Inc.", 
  "Prometheus Biosciences, Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Prometheus Biosciences, Inc.",
  "Rempex (a wholly owned subsidiary of Melinta Therapeutics, Inc.)" = "Rempex Pharmaceuticals", 
  "Rempex (a wholly owned subsidiary of Melinta Therapeutics, LLC)" = "Rempex Pharmaceuticals",
  "Rempex Pharmaceuticals (a wholly owned subsidiary of The Medicines Company)" = "Rempex Pharmaceuticals",
  "Sanofi Pasteur, a Sanofi Company"= "Sanofi", 
  "Trius Therapeutics LLC, a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "Trius Therapeutics LLC",
  "Wyeth is now a wholly owned subsidiary of Pfizer" = "Wyeth", 
  "VelosBio Inc., a subsidiary of Merck & Co., Inc. (Rahway, New Jersey USA)" = "VelosBio Inc.",
  "Zogenix International Limited, Inc., a subsidiary of Zogenix, Inc." = "Zogenix"
)


# Define stopwords
firm_stopwords <- c("ltd", "inc", "llc", "limited", "ltd", "ltda",
                    "as", "pty", "ltc", "pte", "plc", "ag", "bv", "sro", "sas", "sl", "sau",
                    "de", "et al", "nv", "gmbh", "gtc", "sa", "saci", "ltda",
                    "cro", "spa", "ab", "sarl", "pc", "cv", "kg", "pvt", "nvsa",
                    "incorporated", "associates", 
                    "north america", "asia", "south america", "africa", "europe", "usa",
                    "america", "us", "korea", "shanghai",
                    "wholly", "owned", "subsidiary",
                    "holding", "holdings", "group", 
                    "corporation", "corp", "company", "co", "companies", 
                    "industries", "solutions", "products",
                    "mid atlantic", "midatlantic")

pharma_stopwords <- c("pharmaceuticals", "pharmaceutical", "pharma", "pharms", "pharm", "pharmaceutica",
                      "therapeutics", "therap", "biotherapeutics", "biopharmaceuticals", "molecular",
                      "laboratories", "lab", "labs", "applications", "services", "commercialization",
                      "medical", "medicine", "medicines", "health", "wellness", "healthcare", "hlthcare", "health", "care",
                      "vaccines", "consumer", "division", "personal", "institute",
                      "research", "development", "technology", "technologies", "tech",
                      "biotechology", "biotechnologies", "biomedical",
                      "discovery", "oncology", "vaccine", "consulting", "diabetes",
                      "international", "global", 
                      "branded", "products", "rd", 
                      "biopharma", "biotech", "bio", "bioscience", "biosciences", 
                      "life science", "life sciences", 
                      "science", "biologicals", "devices")




# Define function to clean sponsor names
clean_sponsor_names <- function(corpus, stem = TRUE){
  
  # Combine stopword vectors
  stopwords_slim <- stopwords("en")
  stopwords_thicc <- c(stopwords_slim, 
                       firm_stopwords, 
                       pharma_stopwords, 
                       tolower(unique(countrycode::countryname_dict$country.name.en)))

  # Define helper to remove stopwords conditionally 
  remove_stopwords_conditionally <- function(x){
    # First remove stopwords in 2 ways
    x_thicc <- trimws(removeWords(x, stopwords_thicc))
    x_slim <- trimws(removeWords(x, stopwords_slim))
    # Identify strings that become empty when remove all stopwords
    is_empty_string <- nchar(x_thicc) == 0
    # If strings are empty using thicc word list, use slim
    x <- ifelse(is_empty_string, x_slim, x_thicc)
    return(x)
  }
  
  # Process string
  corpus <- corpus %>% 
    tm_map(tolower) %>% 
    tm_map(removePunctuation) %>% 
    tm_map(\(x) remove_stopwords_conditionally(x)) %>% 
    # If "company" remains replace it with "co".
    tm_map(\(x) str_replace_all(x, "\\b(company)\\b", "co")) %>% 
    # Deal with a few corner cases
    tm_map(\(x) ifelse(str_detect(x, "merck"), "merck", x)) %>%
    tm_map(\(x) ifelse(str_detect(x, "janssen|cilag|j and j"), "johnson johnson", x)) %>% 
    tm_map(str_replace_all, "lilly eli", "eli lilly") %>% 
    # Deal with whitespace
    tm_map(str_squish)
  
  if(stem == TRUE) corpus <- tm_map(corpus, stemDocument)
  
  return(corpus)
}


# Test
stopifnot({
  test_corpus <- Corpus(VectorSource(c("The Medicines Company", "Allergan", "A&G Pharmaceutical Inc.")))
  names <- clean_sponsor_names(test_corpus, stem = F)$content 
  all(nchar(names) > 0)
})



