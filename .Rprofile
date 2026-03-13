# Ensure global .Rprofile is sourced first
if (file.exists(Sys.getenv("R_PROFILE_USER", "~/.Rprofile"))) {
  source(Sys.getenv("R_PROFILE_USER", "~/.Rprofile"))
}

# Load here package and confirm root on startup
if (requireNamespace("here", quietly = TRUE)) {
  library(here)
  message("Project root: ", here())
} else {
  message("Install 'here' package: install.packages('here')")
}


# Ensure global .Rprofile is sourced first
if (file.exists(Sys.getenv("R_PROFILE_USER", "~/.Rprofile"))) {
  source(Sys.getenv("R_PROFILE_USER", "~/.Rprofile"))
}

# Load here package and confirm root on startup
if (requireNamespace("here", quietly = TRUE)) {
  library(here)
  message("Project root: ", here())
} else {
  message("Install 'here' package: install.packages('here')")
}

# Load startup datasets
if (requireNamespace("readxl", quietly = TRUE) & requireNamespace("readr", quietly = TRUE)) {
  input_path <- here("inputs")
  
  TractFIPS <- readr::read_csv(here(input_path, "Census_Tract_FIPS_Code_Detroit_MI.csv"),
                               show_col_types = FALSE)
  
  Tract     <- readxl::read_excel(here(input_path, "Detroit_MI.xlsx"), sheet = "Tract")
  BlockGroup <- readxl::read_excel(here(input_path, "Detroit_MI.xlsx"), sheet = "BlockGroup")
  
  message("Datasets loaded: TractFIPS, Tract, BlockGroup")
} else {
  message("Install missing packages: install.packages(c('readr', 'readxl'))")
}