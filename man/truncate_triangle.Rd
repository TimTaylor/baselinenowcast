% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/truncate_triangles.R
\name{truncate_triangle}
\alias{truncate_triangle}
\title{Get a single truncated triangle}
\usage{
truncate_triangle(t, matr_observed)
}
\arguments{
\item{t}{Integer indicating the number of timepoints to truncate off the
bottom of the original reporting triangle.}

\item{matr_observed}{Matrix of the reporting triangle/matrix
to be used to generate retrospective nowcast matrices, with rows
representing the time points of reference and columns representing the
delays.}
}
\value{
Matrix with \code{t} fewer rows than \code{matr_observed}.
}
\description{
This function takes in a integer \code{t} and a reporting triangle and generates
a truncated reporting triangle, remove the last \code{t} observations.
}
\examples{
# example code
triangle <- matrix(
  c(
    65, 46, 21, 7,
    70, 40, 20, 5,
    80, 50, 10, 10,
    100, 40, 31, 20,
    95, 45, 21, NA,
    82, 42, NA, NA,
    70, NA, NA, NA
  ),
  nrow = 7,
  byrow = TRUE
)

trunc_rep_tri <- truncate_triangle(t = 1, matr_observed = triangle)
trunc_rep_tri
}
