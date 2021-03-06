#  File src/library/stats/R/Kalman.R
#  Part of the R package, http://www.R-project.org
#
#  Copyright (C) 2002-14 The R Core Team
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/


## There is a bare-bones version of this in StructTS.
KalmanLike <- function(y, mod, nit = 0L, fast = TRUE)
{
    ## next call changes objects a, P, Pn if fast == TRUE: beware!
    x <- .Call(C_KalmanLike, y, mod$Z, mod$a, mod$P, mod$T, mod$V, mod$h,
               mod$Pn, nit, FALSE, fast)
    s2 <- x[1L]/x[3L]
    list(Lik = 0.5*(log(s2) + x[2L]/x[3L]), s2 = s2)
}

KalmanRun <- function(y, mod, nit = 0L, fast = TRUE)
{
    ## next call changes objects a, P, Pn if fast == TRUE: beware!
    z <- .Call(C_KalmanLike, y, mod$Z, mod$a, mod$P, mod$T, mod$V, mod$h,
               mod$Pn, nit, TRUE, fast)
    x <- z$values
    z[[1L]] <- c(Lik = 0.5*(log(x[1L]/x[3L]) + x[2L]/x[3L]), s2 = x[1L]/x[3L])
    z
}

## used by predict.Arima
KalmanForecast <- function(n.ahead = 10L, mod, fast = FALSE)
    ## next call changes objects a, P if fast==TRUE
    .Call(C_KalmanFore, as.integer(n.ahead), mod$Z, mod$a, mod$P,
          mod$T, mod$V, mod$h, fast)


KalmanSmooth <- function(y, mod, nit = 0L)
{
    z <- .Call(C_KalmanSmooth, y, mod$Z, mod$a, mod$P, mod$T, mod$V, mod$h,
               mod$Pn, as.integer(nit))
    dn <- dim(z$smooth)
    dim(z$var) <- dn[c(1L, 2L, 2L)]
    z
}
