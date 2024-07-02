
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aFILLiator

<!-- badges: start -->
<!-- badges: end -->

aFILLiator is a small collection of scripts that find the affiliation of
an author by looking at the affiliation they used in their last paper
available in [PubMed](https://pubmed.ncbi.nlm.nih.gov/). The goal is to
help authors to find the affiliations of their collaborators, thus
speeding up the writing process of this tedious (but necessary) section.

## Installation

You can install the development version of aFILLiator from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Benjamin-Valderrama/aFILLiator")
```

## Example

This is a basic example which shows you how aFILLiator works…

``` r
library(aFILLiator)

# we call the main function of aFILLiator
aFILLiator(fore_name = "Benjamin", last_name = "Valderrama")
#> [1] "Benjamin Valderrama"
#> [1] "Entrez search result with 1 hits"
#> [1] "Extracting affiliations from the article : 38525261 (PMID)"
#>       name  last_name
#> 1 Benjamin Valderrama
#>                                                                   affiliations
#> 1 APC Microbiome Ireland, University College Cork, Cork, County Cork, Ireland.
#>   extracted_from_pmid
#> 1            38525261
```

In addition, aFILLiator can be used to gather information from multiple authors. To do so, a data frame with two columns can be generated and imported into your R session.
Below you can see an example of such a data frame. Notice the two columns, one with the forenames (`fore_name`), and other with the last names (`last_name`) of each author.
 
``` r

# Example data frame
test_df
#>   fore_name    last_name
#> 1    Thomaz Bastiaanssen
#> 2  Benjamin   Valderrama
#> 3    John F        Cryan
```

The data frame with the names can then be transformed into an object of class `list`, and we can use the function `aFILLiator` to loop over matching pairs of `fore_name`s and `last_name`s.

``` r

library(aFILLiator)

# convert to a list to loop over it
names_list <- test_df |> 
        as.list()

# loop over the matching forenames and last names using the aFILLliator function
affiliations_df <- mapply(aFILLiator, names_list$fore_name, names_list$last_name) |>
        t() |>
        data.frame() |>
        # make the output a data frame again
        sapply(X = _, FUN = unlist) |>
        data.frame()

#> [1] "Thomaz Bastiaanssen"
#> [1] "Entrez search result with 23 hits"
#> [1] "Extracting affiliations from the article : 38852762 (PMID)"
#> [1] "Benjamin Valderrama"
#> [1] "Entrez search result with 1 hits"
#> [1] "Extracting affiliations from the article : 38525261 (PMID)"
#> [1] "John F Cryan"
#> [1] "Entrez search result with 89 hits"
#> [1] "Extracting affiliations from the article : 38852762 (PMID)"


# see the output
affiliations_df

#>              name    last_name
#> Thomaz     Thomaz Bastiaanssen
#> Benjamin Benjamin   Valderrama
#> John F     John F        Cryan
#>                                                                                                                                                                                            affiliations
#> Thomaz                                       APC Microbiome Ireland, University College Cork, Cork T12YT20, Ireland; Dept. of Anatomy and Neuroscience, University College Cork, Cork T12YT20, Ireland.
#> Benjamin                                                                                                                   APC Microbiome Ireland, University College Cork, Cork, County Cork, Ireland.
#> John F   APC Microbiome Ireland, University College Cork, Cork T12YT20, Ireland; Dept. of Anatomy and Neuroscience, University College Cork, Cork T12YT20, Ireland. Electronic address: J.Cryan@ucc.ie.
#>          extracted_from_pmid
#> Thomaz              38852762
#> Benjamin            38525261
#> John F              38852762
```
