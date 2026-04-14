#' Example pollen data for biomisation
#' @name example_biome_data
#' @description These data sets contain example pollen data for
#' biomisation, obtained from Cao and Tian (2021)
#' @details
#' `pollen_percent` contains modern pollen surface sample data in wide format.
#' The first few columns are metadata (Site, Latitude, Longitude, Elevation)
#' (NB Latitude, Longitude and Elevation are identical for all Sites,
#' which may be an error).
#' Pollen percent data are in the remaining columns.
#'

#' @source Cao, X. and Tian, F. (2021) Pollen-based biome reconstruction in R.
#' Zenodo <https://doi.org/10.5281/zenodo.7523423>
"pollen_percent"



#' @details
#' `pollen_weights_threshold` contain the weights and thresholds for each taxa used for biomisation.

#' and threshold for the threshold that must be reached before the species can
#' be assumed to be locally present.
#' \describe{
#'   \item{taxa}{Taxa names}
#'   \item{weight}{taxa weighting, 1 for most species}
#'   \item{threshold}{threshold (percent) that must be reached before the
#' species can be assumed to be locally present and including in calculations.}
#' }
#' @rdname example_biome_data
"pollen_weights_threshold"



#' @details
#' `pollen_pft` shows how taxa are assigned to plant functional types.
#' Each row is for one taxon, with the name given in the first column, `taxa`.
#' The remaining columns are the plant functional types.
#' Each entry is either 0 or 1, depending on whether the
#' taxon can belong to the plant functional type.

#' @rdname example_biome_data
"pollen_pft"


#' @details
#' `pft_biome` shows which plant functional types can occur in each biome.
#' Each row represents one biome,
#' with the name given in the first column, `biome`.
#' The remaining columns are the plant functional types.
#' Each entry is either 0 or 1, depending on whether the
#' plant functional type can occur in the biome.
#' @rdname example_biome_data
"pft_biome"
