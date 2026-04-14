test_that("check_meta_cols", {
  meta_cols <- c("Site", "Long", "Lat", "Elev")
  expect_no_error(
    object = check_meta_cols(
      pollen_percent = pollen_percent,
      meta_cols = meta_cols
    )
  )
  expect_error(
    object = check_meta_cols(
      pollen_percent = pollen_percent,
      meta_cols = c(meta_cols, "Cat")
    ),
    regexp = "Not all elements of meta_cols are columns in pollen_percent"
  )
})

test_that("check_pollen", {
  meta_cols <- c("Site", "Long", "Lat", "Elev")
  pollen_percent2 <- pollen_percent |>
    pivot_longer(-all_of(meta_cols), names_to = "taxa", values_to = "percent")
  expect_no_error(
    object = check_pollen(
      pollen_percent = pollen_percent2,
      pollen_pft = pollen_pft
    )
  )
  # check extra taxa
  pollen_percent3 <- pollen_percent2
  pollen_percent3[1, "taxa"] <- "fish"
  expect_error(
    object = check_pollen(
      pollen_percent = pollen_percent3,
      pollen_pft = pollen_pft
    ),
    regexp = "There is a mismatch between the pollen_percent and pollen_pft datasets: taxa fish not in pollen_pdf"
  )
})


test_that("check_pft", {
  expect_no_error(
    object = suppressWarnings(
      check_pft(pollen_pft = pollen_pft, pft_biome = pft_biome)
    )
  )
  # add extra pft to pollen_pft
  pollen_pft2 <- pollen_pft
  pollen_pft2$new.biome <- 0
  expect_error(
    object = suppressWarnings(
      check_pft(pollen_pft = pollen_pft2, pft_biome = pft_biome)
    ),
    regexp = "There is a mismatch between the pollen_pft and pft_biome datasets: pft\\(s\\) new.biome not in pft_biome"
  )

  # add extra pft to pft_biome
  pft_biome2 <- pft_biome
  pft_biome2$new.biome <- 0

  expect_error(
    object = check_pft(pollen_pft = pollen_pft, pft_biome = pft_biome2),
    regexp = "There is a mismatch between the pollen_pft and pft_biome datasets: pft\\(s\\) new.biome not in pollen_pft"
  )

  # check for warning about unassigned pft

  expect_warning(
    object = check_pft(
      pollen_pft = pollen_pft,
      pft_biome = pft_biome
    ),
    regexp = "^Taxa not assigned to any pft"
  )
})
