## Sample data from Cao & Tian 2021

## code to prepare `pollen_meta` dataset goes here

pollen_weights_threshold <- read.csv(
  file = "data-raw/pollen_variable.csv",
  header = TRUE
)
names(pollen_weights_threshold)[c(1, 3)] <- c("taxa", "threshold")

usethis::use_data(pollen_weights_threshold, overwrite = TRUE)

## code to prepare pollen_pft
pollen_pft <- read.csv(file = "data-raw/pollen-pft.csv", header = TRUE)
names(pollen_pft)[1] <- "taxa"

usethis::use_data(pollen_pft, overwrite = TRUE)


## code to prepare pft_biome
pft_biome <- read.csv(file = "data-raw/pft-biome.csv", header = TRUE)
names(pft_biome)[1] <- "biome"

usethis::use_data(pft_biome, overwrite = TRUE)

## code to prepare pollen_percent
pollen_percent <- read.csv(file = "data-raw/pollen_data.csv", header = TRUE)
names(pollen_percent)[names(pollen_percent) == "Alt"] <- "Elev"
usethis::use_data(pollen_percent, overwrite = TRUE)
