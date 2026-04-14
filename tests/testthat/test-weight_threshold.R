test_that("thresholds and weights work", {
  pollen_percent2 <- pollen_percent |>
    pivot_longer(
      cols = -c("Site", "Long", "Lat", "Elev"),
      names_to = "taxa",
      values_to = "percent"
    )

  # check threshold
  thresh <- check_pollen_weights_threshold(
    pollen_percent = pollen_percent2,
    default_threshold = 0.5
  )

  expect_equal(
    threshold_pollen(
      pollen_percent2,
      pollen_weights_threshold = thresh
    )$percent,
    if_else(pollen_percent2$percent < 0.5, 0, pollen_percent2$percent)
  )
  # check weights
  thresh$weight <- 5
  expect_equal(
    threshold_pollen(
      pollen_percent2,
      pollen_weights_threshold = thresh
    )$percent,
    if_else(pollen_percent2$percent < 0.5, 0, pollen_percent2$percent * 5)
  )
})
