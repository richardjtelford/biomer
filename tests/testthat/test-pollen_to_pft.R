test_that("pollen to pft works", {
  meta_cols <- c("Site", "Long", "Lat", "Elev")
  pollen_percent2 <- pollen_percent |>
    pivot_longer(-all_of(meta_cols),
      names_to = "taxa",
      values_to = "percent"
    ) |>
    group_by(across(all_of(meta_cols))) |>
    filter(Site == "GHB-1+2")

  pollen3 <- threshold_pollen(
    pollen_percent = pollen_percent2,
    pollen_weights_threshold = pollen_weights_threshold
  )

  pft <- pollen_to_pft(pollen_percent = pollen3, pollen_pft = pollen_pft)


  betula_pft <- pollen_pft |>
    filter(taxa == "Betula") |>
    select(-taxa) |>
    select(where(\(x) {
      x > 0
    })) |>
    colnames() |>
    sort()

  expect_equal(
    pft |>
      filter(taxa == "Betula") |>
      dplyr::pull(pft) |>
      sort(),
    betula_pft
  )

  expect_equal(
    pft |>
      filter(taxa == "Betula") |>
      dplyr::pull(percent) |>
      unique(),
    pollen3 |>
      filter(taxa == "Betula") |>
      dplyr::pull(percent)
  )
})
