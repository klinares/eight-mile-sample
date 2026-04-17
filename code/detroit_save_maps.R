# detroit_save_maps.R
# ------------------------------------------------------------------
# Produces the two ggmap figures used in detroit_sampling_report_V3.qmd.
# Run this script once after a new sample is generated.
# The resulting PNGs are written to outputs/figures/ and read into
# the report via knitr::include_graphics().
# ------------------------------------------------------------------

pacman::p_load(
  tidyverse, sf, tigris, ggmap, viridis, here
)

options(tigris_class = "sf", tigris_use_cache = TRUE)

here::i_am("inputs/Detroit_MI.xlsx")

# API key
api_keys <- read_csv("D:/repos/api-keys.csv", show_col_types = FALSE)
stadia_key <- api_keys |> dplyr::filter(key_id == "stadiamaps_key") |> pull(key)
register_stadiamaps(key = stadia_key)

# figures directory
fig_dir <- here("outputs", "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# --- inputs --------------------------------------------------------

tract_fips <- read_csv(
  here("inputs", "Census_Tract_FIPS_Code_Detroit_MI.csv"),
  col_names = "GEOID",
  col_types = cols(GEOID = col_character()),
  skip = 1, show_col_types = FALSE
)

sample_data <- read_csv(
  here("outputs", "SAMPLE_EffectSize.csv"),
  col_types = cols(Tract = col_character(),
                   BlockGroup = col_character()),
  show_col_types = FALSE
)

# --- shapefiles ----------------------------------------------------

invisible(capture.output(suppressMessages({
  detroit_tracts_sf <- tracts(state = "MI", county = "Wayne", year = 2020) |>
    right_join(tract_fips, by = "GEOID") |>
    st_transform(crs = 4326)

  detroit_bgs_sf <- block_groups(state = "MI", county = "Wayne", year = 2020) |>
    mutate(GEOIDt = str_sub(GEOID, 1, 11)) |>
    right_join(tract_fips, by = c("GEOIDt" = "GEOID")) |>
    select(-GEOIDt) |>
    st_transform(crs = 4326)
})))

detroit_bbox <- c(left = -83.29, bottom = 42.25,
                  right = -82.91, top = 42.45)

detroit_basemap <- get_stadiamap(bbox = detroit_bbox, zoom = 12,
                                 maptype = "stamen_toner_lite")

# --- theme ---------------------------------------------------------

map_theme <- theme_void() +
  theme(plot.title    = element_text(face = "bold", size = 13, hjust = .5),
        plot.subtitle = element_text(size = 9, hjust = .5, color = "gray40"),
        plot.margin   = margin(4, 4, 4, 4))

# --- Figure 1: full frame -----------------------------------------

fig_frame <- ggmap(detroit_basemap) +
  geom_sf(data = detroit_bgs_sf, fill = NA,
          linetype = "dotted", linewidth = 0.2, color = "grey50",
          inherit.aes = FALSE) +
  geom_sf(data = detroit_tracts_sf, fill = NA,
          color = "black", linewidth = 0.3, inherit.aes = FALSE) +
  labs(title = "City of Detroit",
       subtitle = "Census Tracts (solid) and Block Groups (dotted)") +
  map_theme

ggsave(file.path(fig_dir, "detroit_frame_map.png"),
       plot = fig_frame,
       width = 8, height = 7, dpi = 300, bg = "white")

# --- Figure 2: selected sample ------------------------------------

fig_sample <- ggmap(detroit_basemap) +
  geom_sf(data = detroit_tracts_sf, fill = NA,
          color = "grey70", linewidth = 0.2, inherit.aes = FALSE) +
  geom_sf(data = detroit_tracts_sf |>
            dplyr::filter(GEOID %in% sample_data$Tract),
          fill = viridis(1, begin = 0.4, alpha = 0.3),
          color = viridis(1, begin = 0.4), linewidth = 0.5,
          inherit.aes = FALSE) +
  geom_sf(data = detroit_bgs_sf |>
            dplyr::filter(GEOID %in% sample_data$BlockGroup),
          fill = NA, color = "red", linewidth = 0.7,
          inherit.aes = FALSE) +
  labs(title = "Selected Sample: 40 Tracts and Block Groups",
       subtitle = "Blue fill = sample tracts; Red outline = selected BGs") +
  map_theme

ggsave(file.path(fig_dir, "detroit_sample_map.png"),
       plot = fig_sample,
       width = 8, height = 7, dpi = 300, bg = "white")

message("Saved:\n  ", file.path(fig_dir, "detroit_frame_map.png"),
        "\n  ", file.path(fig_dir, "detroit_sample_map.png"))
