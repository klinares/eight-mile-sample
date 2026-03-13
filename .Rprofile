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
  
  library(readr)
  library(readxl)
  library(dplyr)
  
  input_path   <- here("inputs")
  census_tract <- "Census_Tract_FIPS_Code_Detroit_MI.csv"
  detroit_mi   <- "Detroit_MI.xlsx"

  tract_fips <- read_csv(
    file.path(input_path, census_tract),
    col_names = "GEOID",
    col_types = cols(GEOID = col_character()),
    skip = 1,
    show_col_types = FALSE
  )

  tract <- read_excel(
    file.path(input_path, detroit_mi),
    sheet = "Tract"
  ) |>
    mutate(Tract = as.character(Tract)) |>
    semi_join(tract_fips, by = c("Tract" = "GEOID"))

  bg <- read_excel(
    file.path(input_path, detroit_mi),
    sheet = "BlockGroup"
  ) |>
    mutate(
      BlockGroup = as.character(BlockGroup),
      Tract = substr(BlockGroup, 1, 11)
    ) |>
    semi_join(tract_fips, by = c("Tract" = "GEOID"))

  message("Datasets loaded: tract_fips, tract, bg")

} else {
  message("Install missing packages: install.packages(c('readr', 'readxl'))")
}