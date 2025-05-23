# Sample data
test_matrix <- matrix(
  c(
    10, 20, 30, 40,
    15, 25, 35, 23.1,
    20, 30, 32.1, 17.1,
    25, 40.6, 18.7, 20.5
  ),
  nrow = 4,
  byrow = TRUE
)

valid_disp <- c(5, 3, 2)

test_that("get_nowcast_mat_draw basic functionality with valid inputs", {
  set.seed(123)
  result <- get_nowcast_mat_draw(test_matrix, valid_disp)

  # Verify output structure
  expect_identical(dim(result), dim(test_matrix))
  expect_false(anyNA(result))

  # Verify upper triangle remains unchanged
  expect_identical(result[1:2, 1:2], test_matrix[1:2, 1:2])

  # Very all values are integers
  expect_silent(assert_integerish(result))
})

test_that("get_nowcast_mat_draw input validation works correctly", {
  # NA in input matrix
  na_matrix <- test_matrix
  na_matrix[1, 1] <- NA
  expect_error(
    get_nowcast_mat_draw(na_matrix, valid_disp),
    "`point_nowcast_matrix` contains NA values. It should only contain"
  )

  # Dispersion parameter length mismatch
  expect_error(
    get_nowcast_mat_draw(test_matrix, c(1, 2)),
    "`disp` vector should be of length one less than"
  )
})

test_that("get_nowcast_mat_draw invalid dispersion parameters throw errors", {
  # Negative dispersion
  expect_error(add_obs_error_to_nowcast(test_matrix, c(-1, 2, 3)))

  # Zero dispersion should fail
  expect_error(add_obs_error_to_nowcast(test_matrix, c(0, 2, 3)))

  # input not a matrix
  expect_error(add_obs_error_to_nowcast(data.frame(test_matrix), valid_disp))
})

test_that("get_nowcast_mat_draw random generation is reproducible with seed", {
  set.seed(456)
  result1 <- get_nowcast_mat_draw(test_matrix, valid_disp)
  set.seed(456)
  result2 <- get_nowcast_mat_draw(test_matrix, valid_disp)
  expect_identical(result1, result2)
})

test_that(
  "get_nowcast_mat_draw output follows negative binomial distribution",
  {
    set.seed(789)
    result <- get_nowcast_mat_draw(test_matrix, valid_disp)

    # Test last column (delay = 3)
    generated_vals <- result[3:4, 4]
    original_means <- test_matrix[3:4, 4]

    # Check mean is close to original (with tolerance for sampling error)
    test_bounds <- (mean(generated_vals) >
      mean(original_means) - 15) &
      (mean(generated_vals) <
        mean(original_means) + 15)

    expect_true(test_bounds)
  }
)

test_that("get_nowcast_mat_draw output dimensions match input", {
  square_matrix <- matrix(1:9, nrow = 3)
  disp <- c(2, 2)
  result <- get_nowcast_mat_draw(square_matrix, disp)
  expect_identical(dim(result), c(3L, 3L))
})
