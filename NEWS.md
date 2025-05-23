# baselinenowcast 0.0.0.1000

-   Standardises naming of objects that are matrices vs vectors and objects that contain observations, point estimates, and probabilistic draws.
-   Modifies functions that estimate a delay and generate a point nowcast to ensure that they throw an error/warning if the first element of the delay PMF is 0.
-   Adjusts function to estimate delay distribution to be able to handle complete and partially complete reporting triangles.
-   Add function to convert a list of expected observed reporting squares to a long tidy dataframe indexed by reference time, delay, and a sample index.
-   Implement zero-handling in the bottom left of the reporting triangle when applying the delay to generate a point nowcast.
-   Add function to generate a list of expected observed reporting squares.
-   Add function to generate an expected observed reporting square from a point nowcast and a vector of dispersion parameters.
-   Add function to estimate dispersion parameters from a match list of nowcasts and observed reporting triangles.
-   Add functions to generate retrospective nowcasts from a single reporting triangle.
-   Refactor uncertainty estimation to use a user-facing function to generate retrospective reporting triangles.
-   Methods write-up as a separate vignette.
-   Introduced function to estimate the uncertainty from a triangle to be nowcasted and a delay distribution.
-   Introduced functions to get the delay estimate and apply the delay, and used these in the Getting Started vignette.
-   Added package skeleton.
