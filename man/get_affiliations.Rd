% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/afFILLiator.R
\name{get_affiliations}
\alias{get_affiliations}
\title{Extract affiliations from a XML object}
\usage{
get_affiliations(pubmed_record, last_name)
}
\arguments{
\item{pubmed_record}{an XML object with the information of an article.}

\item{last_name}{A character vector of one element with the lastname of the author.}
}
\value{
A character vector of one element with the affiliations of the author with the last name provided.
}
\description{
Extract affiliations from a XML object
}
\examples{
pmid <- 38852762
record <- fetch_record(pmid)
get_affiliations(record, "Cryan")
}
