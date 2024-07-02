#' Get a XML object with the article information from a PMID
#'
#' @param pmid a numeric vactor of one element with the PMID.
#'
#' @return an XML document with the article information associated to that PMID.
#' @export
#'
#' @examples
#' pmid <- 38852762
#' fetch_record(pmid)
fetch_record <- function(pmid){


        rentrez::entrez_fetch(db = "pubmed", id = pmid, rettype = "xml") |>
                XML::xmlParse() |>
                XML::getNodeSet(path = "//PubmedArticleSet")

}

#' Extract affiliations from a XML object
#'
#' @param pubmed_record an XML object with the information of an article.
#' @param last_name A character vector of one element with the lastname of the author.
#'
#' @return A character vector of one element with the affiliations of the author with the last name provided.
#' @export
#'
#' @examples
#' pmid <- 38852762
#' record <- fetch_record(pmid)
#' get_affiliations(record, "Cryan")
get_affiliations <- function(pubmed_record, last_name){


        lastname_list <- pubmed_record |>
                lapply(X = _, FUN = XML::xpathSApply, "//Author/LastName", XML::xmlValue) |>
                unlist()

        target_author_position <- which(grepl(x = lastname_list, pattern = last_name))
        # target_author_position

        #
        affiliations_list <- pubmed_record |>
                lapply(X = _, FUN = XML::xpathSApply, "//Author/AffiliationInfo", XML::xmlValue) |>
                unlist()

        targert_author_affiliations <- affiliations_list[target_author_position] |>
                unlist()

        return(targert_author_affiliations)
}


#' Get authors name, affiliations and PMID from where affiliation was gathered
#'
#' @param fore_name A character vector of one element with the name(s) of the author.
#' @param last_name A character vector of one element with the lastname of the author.
#'
#' @return A dataframe with author name, lastname, affiliations and the PMID of the publication where the information was gather from.
#' @export
#'
#' @examples
#' aFILLiator(fore_name = "John F", last_name = "Cryan")
aFILLiator <- function(fore_name = "Benjamin",
                        last_name = "Valderrama"){


        author <- paste(fore_name, last_name)
        print(author)


        search <- rentrez::entrez_search(db = "pubmed", term = paste0(author, " AND 2022 : 2024[pdat]"))


        hits <- search$count

        if (search$count == 0){
                print("No hits found for that author name")
                affiliations <- "Author not found"; pmid <- "Author not found"
        }

        else{
                print(paste("Entrez search result with", hits, "hits"))
                for(pmid in search$ids){

                        print(paste("Extracting affiliations from the article :", pmid, "(PMID)"))

                        record <- fetch_record(pmid = pmid)
                        affiliations <- get_affiliations(pubmed_record = record, last_name = last_name)

                        # If an affiliation was found, break the loop
                        if(!is.null(affiliations)){break}
                        # otherwise look at the following publication
                }

                # If no affiliation was found, then assign a value
                if(is.null(affiliations)){affiliations <- "unknown"; pmid <- NA}
        }

        # put the information together into one dataframe
        affiliations_df <- data.frame(name = fore_name,
                                       last_name = last_name,
                                       affiliations = affiliations,
                                       extracted_from_pmid = pmid)
        return(affiliations_df)
}

