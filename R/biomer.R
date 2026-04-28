# fudge high/low pollen producers
# convert to plant functional type
# calculate biome scores
#' Reconstruct biome from pollen data
#' @param pollen_percent data frame of pollen percent data in either wide format
#' (if `wide` is TRUE), or long format (if `wide` is FALSE) with columns
#' `meta_cols`, taxa, and percent.
#' See object `pollen_percent` for an example of the expected wide format.
#' @param wide logical, whether data are in long (one row per sample * species)
#' or wide (one row per sample). Defaults to TRUE.
#' @param meta_cols vector of column names from pollen percent that describe
#' the sample rather than the pollen percent.
#' @param pollen_weights_threshold data frame of pollen threshold
#' and weight data.
#' It should have columns named `taxa`, `weight` and `threshold`.
#' Missing taxa will be given default values.
#' If missing completely, defaults to threshold of 0.5 and
#' weight of 1 for all taxa.
#' @param pollen_pft  data frame of pollen assignments to plant functional
#' types.
#' The first column should contain the taxa name, and the remaining columns
#' should be for each plant functional type. Entries are 1 or zero depending on
#' whether the taxon can be assigned to the plant functional type.
#' See object `pollen_pft` for an example of the expected format.
#' @param pft_biome data frame of plant functional types to biomes.
#' The first column should be called biome.
#' The remaining columns are for the plant functional types.
#' Entries are 1 or zero depending on whether that plant functional type can be
#' found in that biome.
#' See object `pft_biome` for an example of the expected format.
#' @param default_threshold default threshold for inclusion in calculation.
#' Defaults to 0.5.
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr mutate left_join join_by across all_of group_by
#' @references Prentice et al. (1996).
#' @examples
#' biomer(
#'   pollen_percent = pollen_percent,
#'   meta_cols = c("Site", "Long", "Lat", "Elev"),
#'   pollen_weights_threshold = pollen_weights_threshold,
#'   pollen_pft = pollen_pft,
#'   pft_biome = pft_biome
#' )
#' @export


biomer <- function(pollen_percent, wide = TRUE, meta_cols, pollen_weights_threshold,
                   pollen_pft, pft_biome, default_threshold = 0.5) {
  # check meta_cols exist
  check_meta_cols(pollen_percent, meta_cols)
  # make pollen thin
  if (wide) {
    pollen_percent <- pollen_percent |>
      pivot_longer(cols = -meta_cols, names_to = "taxa", values_to = "percent")
  }
  pollen_percent <- pollen_percent |>
    group_by(across(all_of(meta_cols)))

  # check pollen_weights_threshold
  if (missing(pollen_weights_threshold)) {
    pollen_weights_threshold <- check_pollen_weights_threshold(
      pollen_percent = pollen_percent,
      default_threshold = default_threshold
    )
  } else {
    pollen_weights_threshold <- check_pollen_weights_threshold(
      pollen_percent = pollen_percent,
      pollen_weights_threshold = pollen_weights_threshold,
      default_threshold = default_threshold
    )
  }


  # check pollen_percent, pollen_weights_threshold, pollen_pft
  check_pollen(pollen_percent, pollen_pft)

  # check pollen_pft pft_biome
  check_pft(pollen_pft, pft_biome)

  # threshold  & weight pollen
  pollen_percent <- threshold_pollen(
    pollen_percent = pollen_percent,
    pollen_weights_threshold = pollen_weights_threshold
  )

  # pollen to pft
  pft <- pollen_to_pft(
    pollen_percent = pollen_percent,
    pollen_pft = pollen_pft
  )

  # pft to biome
  biome_scores <- pft_to_biome(
    pft = pft,
    pft_biome = pft_biome
  )

  # return calculated biome scores.
  biome_scores
}

#### Helper functions ####

check_pollen_weights_threshold <- function(pollen_percent,
                                           pollen_weights_threshold,
                                           default_threshold) {
  pollen_names <- unique(pollen_percent$taxa)
  # create pollen_weights_threshold if missing
  if (missing(pollen_weights_threshold)) {
    pollen_weights_threshold <- data.frame(
      taxa = pollen_names,
      weight = 1,
      threshold = default_threshold
    )
  }

  # check column names
  correct_names <- c("taxa", "weight", "threshold")
  if (all(!correct_names %in% colnames(pollen_weights_threshold))) {
    stop(
      "pollen_weights_threshold must have columns ",
      correct_names, " any additional columns are ignored."
    )
  }


  # add missing weights/thresholds
  if (any(!pollen_names %in% pollen_weights_threshold$taxa)) {
    pollen_weights_threshold <- rbind(
      pollen_weights_threshold,
      data.frame(
        taxa = setdiff(pollen_names, pollen_weights_threshold$taxa),
        weight = 1,
        threshold = default_threshold
      )
    )
  }

  pollen_weights_threshold
}

# check meta cols
check_meta_cols <- function(pollen_percent, meta_cols) {
  # check sample names
  if (!all(meta_cols %in% names(pollen_percent))) {
    stop("Not all elements of meta_cols are columns in pollen_percent")
  }
}

# check pollen

check_pollen <- function(pollen_percent, pollen_pft) {
  # check pollen_pft

  # check all pollen taxa in pollen_pft
  pollen_names <- unique(pollen_percent$taxa)
  matches <- pollen_names %in% pollen_pft$taxa
  if (!all(matches)) {
    stop(
      "There is a mismatch between the pollen_percent and pollen_pft datasets: taxa ",
      pollen_names[!matches],
      " not in pollen_pdf"
    )
  }
}

# check pollen_pft pft_biome
check_pft <- function(pollen_pft, pft_biome) {
  # check pollen_pft column names
  if (colnames(pollen_pft)[1] != "taxa") {
    stop("First column of pollen_pft must be called taxa (and contain the names of the taxa).")
  }

  # check pft_biome column names
  if (colnames(pft_biome)[1] != "biome") {
    stop("First column of pft_biome must be called biome (and contain the names of the biomes).")
  }


  matches <- names(pollen_pft[, -1]) %in% names(pft_biome[, -1])
  if (!all(matches)) {
    stop(
      "There is a mismatch between the pollen_pft and pft_biome datasets: pft(s) ",
      paste(names(pollen_pft[, -1])[!matches], collapse = ", "),
      " not in pft_biome"
    )
  }

  matches <- names(pft_biome[, -1]) %in% names(pollen_pft[, -1])
  if (!all(matches)) {
    stop(
      "There is a mismatch between the pollen_pft and pft_biome datasets: pft(s) ",
      paste(names(pft_biome[, -1])[!matches], collapse = ", "),
      " not in pollen_pft"
    )
  }

  # check taxa in pollen_pft not assigned to any pft
  n_pollen <- rowSums(pollen_pft[, -1])
  if (any(n_pollen == 0)) {
    warning(
      "Taxa not assigned to any pft: ",
      paste(pollen_pft[n_pollen == 0, "taxa"], collapse = ", ")
    )
  }

  # check biomes with no pft assigned
  n_biome <- rowSums(pft_biome[, -1])
  if (any(n_biome == 0)) {
    warning(
      "No pft assigned to biome: ",
      paste(pft_biome[n_biome == 0, "biome"], collapse = ", ")
    )
  }


  # check pft not assigned to any biomes
  n_pft <- colSums(pft_biome[, -1])
  if (any(n_pft == 0)) {
    warning(
      "pft not assigned to any biome: ",
      paste(colnames(pft_biome)[-1][n_pft == 0], collapse = ", ")
    )
  }
}

# threshold & weight pollen
#' @importFrom dplyr left_join mutate if_else
threshold_pollen <- function(pollen_percent, pollen_weights_threshold) {
  # join pollen data to weights_thresholds
  pollen_percent |>
    left_join(pollen_weights_threshold, by = join_by("taxa")) |>
    mutate(
      # set percent below threshold to zero
      percent = if_else(
        condition = .data$percent < .data$threshold,
        true = 0,
        false = .data$percent
      ),
      # mutliple by weights
      percent = .data$percent * .data$weight
    ) |>
    select(-all_of(c("weight", "threshold")))
}


# pollen to pft
#' @importFrom rlang .data
#' @importFrom tidyr drop_na pivot_longer
#' @importFrom dplyr filter left_join group_by select
pollen_to_pft <- function(pollen_percent, pollen_pft) {
  # pivot pollen_pft
  pollen_pft <- pollen_pft |>
    pivot_longer(-all_of("taxa"), names_to = "pft", values_to = "present") |>
    filter(.data$present == 1)

  # join pollen percent and plant functional type
  pollen_percent |>
    filter(.data$percent > 0) |>
    left_join(pollen_pft, by = join_by("taxa")) |>
    drop_na("pft") |>
    select(-"present")
}

# pft to biome
#' @importFrom rlang .data
#' @importFrom dplyr distinct
pft_to_biome <- function(pft, pft_biome) {
  # pivot biomes
  pft_biome <- pft_biome |>
    pivot_longer(-all_of("biome"), names_to = "pft", values_to = "present") |>
    filter(.data$present == 1)

  # join pft to biomes
  pft |>
    left_join(pft_biome, by = join_by("pft"), relationship = "many-to-many") |>
    group_by(.data$biome, .add = TRUE) |>
    select(-"pft", -"present") |>
    # remove duplicates because taxa in two pft both in same biome
    distinct() |>
    # calculate biome score
    summarise(biome_score = sum(sqrt(.data$percent)), .groups = "drop_last")
}

#' Find top biome
#' @param biome_scores biome scores calculated by `biomer`.
#' @importFrom dplyr summarise
#' @importFrom rlang .data
#' @examples
#' biomer(
#'   pollen_percent = pollen_percent,
#'   meta_cols = c("Site", "Long", "Lat", "Elev"),
#'   pollen_weights_threshold = pollen_weights_threshold,
#'   pollen_pft = pollen_pft,
#'   pft_biome = pft_biome
#' ) |>
#'   top_biome()
#'
#' @export
top_biome <- function(biome_scores) {
  biome_scores |>
    summarise(
      top_biome = .data$biome[which.max(.data$biome_score)],
      top_biome_score = max(.data$biome_score)
    )
}
