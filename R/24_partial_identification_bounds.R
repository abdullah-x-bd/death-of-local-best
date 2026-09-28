# Utilities for coefficient bounds with interval-censored outcomes.
#
# For a fixed linear regression design beta = A y, where
# A = (X' W X)^(-1) X' W.
# Given elementwise lower and upper bounds on y, each coefficient's
# coordinatewise sharp extrema are obtained analytically.
#
# NOTE:
# This handles identification uncertainty from censoring, not statistical
# confidence intervals.

coefficient_bounds_lm <- function(X, lower, upper, weights=NULL, tol=1e-10) {
  X <- as.matrix(X)
  lower <- as.numeric(lower)
  upper <- as.numeric(upper)

  n <- nrow(X)
  if (length(lower)!=n || length(upper)!=n) {
    stop("Outcome bounds must have one entry per row of X.")
  }

  if (any(!is.finite(lower)) || any(!is.finite(upper))) {
    stop("Finite lower and upper outcome bounds are required.")
  }

  if (any(lower > upper)) {
    stop("At least one lower bound exceeds its upper bound.")
  }

  if (is.null(weights)) {
    weights <- rep(1,n)
  }

  weights <- as.numeric(weights)
  if (length(weights)!=n || any(weights<0) || any(!is.finite(weights))) {
    stop("Invalid regression weights.")
  }

  # Weighted normal equations.
  sw <- sqrt(weights)
  Xw <- X * sw

  XtWX <- crossprod(Xw)

  if (rcond(XtWX) < tol) {
    stop("Design matrix is numerically rank deficient.")
  }

  # A maps the unweighted y vector into weighted OLS coefficients.
  # beta = (X'WX)^(-1) X'W y
  A <- solve(XtWX, t(X) * weights)

  lower_beta <- upper_beta <- numeric(nrow(A))

  for (j in seq_len(nrow(A))) {
    a <- A[j,]

    y_for_min <- ifelse(a >= 0, lower, upper)
    y_for_max <- ifelse(a >= 0, upper, lower)

    lower_beta[j] <- sum(a * y_for_min)
    upper_beta[j] <- sum(a * y_for_max)
  }

  names(lower_beta) <- colnames(X)
  names(upper_beta) <- colnames(X)

  data.frame(
    term=colnames(X),
    lower=lower_beta,
    upper=upper_beta,
    row.names=NULL,
    check.names=FALSE
  )
}

empflag_bounds <- function(flag, top_cap=NA_real_) {
  flag <- toupper(trimws(as.character(flag)))

  bounds <- list(
    A=c(0,19),
    B=c(20,99),
    C=c(100,249),
    E=c(250,499),
    F=c(500,999),
    G=c(1000,2499),
    H=c(2500,4999),
    I=c(5000,9999),
    J=c(10000,24999),
    K=c(25000,49999),
    L=c(50000,99999),
    M=c(100000,top_cap)
  )

  out_l <- out_u <- rep(NA_real_,length(flag))

  for (k in names(bounds)) {
    idx <- which(flag==k)
    if (!length(idx)) next
    out_l[idx] <- bounds[[k]][1]
    out_u[idx] <- bounds[[k]][2]
  }

  data.frame(lower=out_l,upper=out_u)
}
