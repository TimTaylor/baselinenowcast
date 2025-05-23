#' Generate retrospective nowcasts
#'
#' This function ingests a list of incomplete reporting triangles and
#'   generates a list of reporting squares, or "complete"
#'   point estimates of reporting triangles based on the delay estimated in
#'   each triangle. It uses the specified `n` number of
#'   observations to estimate the empirical delay for each retrospective
#'   reporting triangle.
#'
#' @param reporting_triangle_list List of reporting triangle matrices, in order
#'    from most recent (most complete) to least recent. Bottom right of the
#'    matrices should contain NAs.
#' @param max_delay Integer indicating the maximum delay to estimate, in units
#'   of the delay. The default is to use one less than the minimum number of
#'   rows of all of the matrices in the `list_of_rts`.
#' @param n Integer indicating the number of observations
#'    (number of rows) to use to estimate the delay distribution for each
#'    reporting triangle. Default is the minimum of the number of rows of
#'    all the matrices in the `list_of_rts`.
#'
#' @returns `pt_nowcast_matr_list` List of the same number of elements as the
#'    input `reporting_triangle_list`but with each reporting triangle filled
#'    in based on the delay estimated in that reporting triangle.
#' @export
#' @examples
#' triangle <- matrix(
#'   c(
#'     65, 46, 21, 7,
#'     70, 40, 20, 5,
#'     80, 50, 10, 10,
#'     100, 40, 31, 20,
#'     95, 45, 21, NA,
#'     82, 42, NA, NA,
#'     70, NA, NA, NA
#'   ),
#'   nrow = 7,
#'   byrow = TRUE
#' )
#'
#' trunc_rts <- truncate_triangles(triangle)
#' retro_rts <- generate_triangles(trunc_rts)
#' retro_pt_nowcast_mat_list <- generate_pt_nowcast_mat_list(retro_rts)
#' retro_pt_nowcast_mat_list[1:3]
generate_pt_nowcast_mat_list <- function(reporting_triangle_list,
                                         max_delay = min(
                                           sapply(reporting_triangle_list, ncol)
                                         ) - 1,
                                         n = min(
                                           sapply(reporting_triangle_list, nrow)
                                         )) {
  if (n > min(
    sapply(reporting_triangle_list, nrow)
  )) {
    cli_abort(
      message = c(
        "The number of observations specified for delay estimation is greater ",
        "than the minimum number of rows in all of the retrospective ",
        "reporting triangles. Either remove the reporting triangles that do ",
        "not contain sufficient data, or lower `n_history_delay`"
      )
    )
  }
  if (n < min(sapply(reporting_triangle_list, ncol))) {
    cli_abort(
      message = c(
        "The number of observations specified for delay estimation is less ",
        "than one plus the number of columns in the retrospective reporting ",
        "triangles. The delay distribution can only be estimated from at ",
        "at least the number of columns in the reporting triangle."
      )
    )
  }

  pt_nowcast_mat_list <- lapply(reporting_triangle_list,
    generate_pt_nowcast_mat,
    n = n
  )


  return(pt_nowcast_mat_list)
}

#' Generate point nowcast
#'
#' This function ingests a reporting triangle matrix and optionally, a delay
#'   distribution, and returns a completed reporting square which represents
#'   the point nowcast. If a delay distribution is specified, this will be
#'   used to generate the nowcast, otherwise, a delay distribution will be
#'   estimated from the `reporting_triangle`.
#' @param delay_pmf Vector of delays assumed to be indexed starting at the
#'   first delay column in `triangle_to_nowcast`.
#' @inheritParams get_delay_estimate
#' @returns `point_nowcast_matrix` Matrix of the same number of rows and
#'   columns as the `reporting_triangle` but with the missing values filled
#'   in as point estimates.
#' @export
#'
#' @examples
#' triangle <- matrix(
#'   c(
#'     80, 50, 25, 10,
#'     100, 50, 30, 20,
#'     90, 45, 25, NA,
#'     80, 40, NA, NA,
#'     70, NA, NA, NA
#'   ),
#'   nrow = 5,
#'   byrow = TRUE
#' )
#' point_nowcast_matrix <- generate_pt_nowcast_mat(
#'   reporting_triangle = triangle
#' )
#' point_nowcast_matrix
generate_pt_nowcast_mat <- function(reporting_triangle,
                                    max_delay = ncol(reporting_triangle) - 1,
                                    n = nrow(reporting_triangle),
                                    delay_pmf = NULL) {
  .validate_triangle(reporting_triangle)
  if (is.null(delay_pmf)) {
    delay_pmf <- get_delay_estimate(
      reporting_triangle = reporting_triangle,
      max_delay = max_delay,
      n = n
    )
  }

  point_nowcast_matrix <- apply_delay(reporting_triangle, delay_pmf)
  return(point_nowcast_matrix)
}
