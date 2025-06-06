# Sample matrix from the example
test_triangle <- matrix(
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

test_that("truncate_triangles returns correct number of truncated matrices with valid input", { # nolint
  n <- 2
  result <- truncate_triangles(test_triangle, n = n)

  # Verify list length
  expect_length(result, n)

  # Verify matrix properties
  expect_true(all(sapply(result, is.matrix)))
  expect_true(all(sapply(result, \(x) ncol(x) == ncol(test_triangle))))

  # Verify row reduction pattern
  expect_identical(nrow(result[[1]]), nrow(test_triangle) - 1L)
  expect_identical(nrow(result[[2]]), nrow(test_triangle) - 2L)
})

test_that("truncate_triangles default n calculation works correctly", {
  expected_default <- nrow(test_triangle) - ncol(test_triangle) - 1
  result <- truncate_triangles(test_triangle)
  expect_length(result, expected_default)
})

test_that("truncate_triangles edge cases are handled properly", {
  # n = 0 returns empty list
  expect_length(truncate_triangles(test_triangle, n = 0), 0)

  # Input validation
  expect_error(
    truncate_triangles(as.data.frame(test_triangle)),
    "Assertion on 'triangle' failed: Must inherit from class 'matrix'"
  ) # nolint
  expect_error(
    truncate_triangles(test_triangle, n = -1),
    "Assertion on 'n' failed: Element 1 is not >= 0."
  )
  expect_error(
    truncate_triangles(test_triangle, n = 2.5),
    "Assertion on 'n' failed: Must be of type 'integerish'"
  )
})

test_that("truncate_triangles warnings are generated for excessive n values", {
  safe_n <- nrow(test_triangle) - ncol(test_triangle) - 1
  expect_silent(truncate_triangles(test_triangle, n = safe_n))
  expect_warning(truncate_triangles(test_triangle, n = safe_n + 1))
})

test_that("truncate_triangles NA replacement works as expected", {
  result <- truncate_triangles(test_triangle, n = 1)[[1]]
  # Expect bottom 3 elemets of lower left triangle to be NAs
  expect_true(all(
    anyNA(result[5, 4]),
    anyNA(result[6, 3:4])
  ))
})

test_that("truncate_triangles truncated matrices preserve original structure", {
  result <- truncate_triangles(test_triangle, n = 1)[[1]]

  # Verify first rows remain unchanged
  expect_identical(
    result[1:(nrow(result) - 1), ],
    test_triangle[1:(nrow(result) - 1), ]
  )
})
