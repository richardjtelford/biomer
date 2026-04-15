
<!-- README.md is generated from README.Rmd. Please edit that file -->

# biomer

<!-- badges: start -->

<!-- badges: end -->

The goal of biomer is to support biomisation of pollen data.

## Installation

You can install the development version of biomer like so:

``` r
# install.package("pak") # if pak not already installed.
pak::pak("richardjtelford/biomer")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(biomer)
biomes <- biomer(
  pollen_percent = pollen_percent,
  meta_cols = c("Site", "Long", "Lat", "Elev"),
  pollen_weights_threshold = pollen_weights_threshold,
  pollen_pft = pollen_pft,
  pft_biome = pft_biome
)
#> Warning in check_pft(pollen_pft, pft_biome): Taxa not assigned to any pft:
#> Humulus, Plantaginaceae, Polygala, Sanguisorba, Urtica, Valerianaceae
biomes
#> # A tibble: 360 × 6
#> # Groups:   Site, Long, Lat, Elev [19]
#>    Site     Long   Lat  Elev biome  biome_score
#>    <chr>   <dbl> <dbl> <int> <chr>        <dbl>
#>  1 GHB-1+2  112.  38.9  1860 A_CLDE        2.07
#>  2 GHB-1+2  112.  38.9  1860 B_CLEG        2.07
#>  3 GHB-1+2  112.  38.9  1860 C_CLMX        2.07
#>  4 GHB-1+2  112.  38.9  1860 D_COEG        5.09
#>  5 GHB-1+2  112.  38.9  1860 E_COMX        9.42
#>  6 GHB-1+2  112.  38.9  1860 F_TEDE       10.3 
#>  7 GHB-1+2  112.  38.9  1860 G_WTEM        2.88
#>  8 GHB-1+2  112.  38.9  1860 H_WTEG        2.04
#>  9 GHB-1+2  112.  38.9  1860 I_TRSE        3.01
#> 10 GHB-1+2  112.  38.9  1860 J_TREG        3.01
#> # ℹ 350 more rows

top_biome(biomes)
#> # A tibble: 19 × 6
#> # Groups:   Site, Long, Lat [19]
#>    Site     Long   Lat  Elev top_biome top_biome_score
#>    <chr>   <dbl> <dbl> <int> <chr>               <dbl>
#>  1 GHB-1+2  112.  38.9  1860 M_TEGR               14.4
#>  2 GHB-10   112.  38.9  1860 M_TEGR               15.3
#>  3 GHB-11   112.  38.9  1860 M_TEGR               15.5
#>  4 GHB-12   112.  38.9  1860 M_TEGR               15.5
#>  5 GHB-13   112.  38.9  1860 M_TEGR               17.4
#>  6 GHB-14   112.  38.9  1860 M_TEGR               15.3
#>  7 GHB-15   112.  38.9  1860 M_TEGR               16.1
#>  8 GHB-16   112.  38.9  1860 M_TEGR               16.2
#>  9 GHB-17   112.  38.9  1860 M_TEGR               18.1
#> 10 GHB-18   112.  38.9  1860 M_TEGR               18.7
#> 11 GHB-19   112.  38.9  1860 M_TEGR               15.7
#> 12 GHB-20   112.  38.9  1860 M_TEGR               14.8
#> 13 GHB-3    112.  38.9  1860 M_TEGR               15.8
#> 14 GHB-4    112.  38.9  1860 M_TEGR               14.8
#> 15 GHB-5    112.  38.9  1860 L_TEXE               16.5
#> 16 GHB-6    112.  38.9  1860 M_TEGR               16.6
#> 17 GHB-7    112.  38.9  1860 M_TEGR               16.8
#> 18 GHB-8    112.  38.9  1860 M_TEGR               13.6
#> 19 GHB-9    112.  38.9  1860 M_TEGR               15.3
```
