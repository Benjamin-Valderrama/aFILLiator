fetch_record <- function(pmid){

        rentrez::entrez_fetch(db = "pubmed", id = pmid, rettype = "xml") |>
                XML::xmlParse() |>
                XML::getNodeSet(path = "//PubmedArticleSet")

}

get_affilliations <- function(pubmed_record, last_name){

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


# main function
afFILLiator <- function(fore_name = "Benjamin",
                        last_name = "Valderrama"){

        author <- paste(fore_name, last_name)
        print(author)


        search <- rentrez::entrez_search(db = "pubmed", term = paste0(author, " AND 2022 : 2024[pdat]"))


        hits <- search$count

        if (search$count == 0){
                print("No hits found for that author name")
                affilliations <- "Author not found"; pmid <- "Author not found"
        }

        else{
                print(paste("Entrez search result with", hits, "hits"))
                for(pmid in search$ids){

                        print(paste("Extracting affilliations from the article :", pmid, "(PMID)"))

                        record <- fetch_record(pmid = pmid)
                        affilliations <- get_affilliations(pubmed_record = record, last_name = last_name)

                        # If an affilliation was found, break the loop
                        if(!is.null(affilliations)){break}
                        # otherwise look at the following publication
                }

                # If no affilliation was found, then assign a value
                if(is.null(affilliations)){affilliations <- "unknown"; pmid <- NA}
        }

        # put the information together into one dataframe
        affilliations_df <- data.frame(name = fore_name,
                                       last_name = last_name,
                                       affilliations = affilliations,
                                       extracted_from_pmid = pmid)
        return(affilliations_df)
}

