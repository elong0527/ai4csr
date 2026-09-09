#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(name) {
  m <- regmatches(args, regexec(paste0("^--", name, "=(.*)$"), args))
  v <- Filter(function(x) length(x) == 2, m)
  if (length(v) == 0) stop(paste("missing required argument --", name, sep = ""))
  v[[1]][2]
}
sap_path <- get_arg("sap")
data_path <- get_arg("data")
out_sel <- get_arg("out_selection")
out_sum <- get_arg("out_summary")
code_version <- "v2.0"

sap_lines <- readLines(sap_path, warn = FALSE)
grab <- function(key) {
  hit <- grep(paste0("^", key, ":\\s*"), sap_lines, value = TRUE)
  if (length(hit) == 0) return(NA_character_)
  sub(paste0("^", key, ":\\s*"), "", hit[1])
}
sap_version <- grab("Version")
lower <- suppressWarnings(as.integer(grab("WindowLower")))
target <- suppressWarnings(as.integer(grab("WindowTarget")))
upper_raw <- grab("WindowUpper")
upper <- if (is.na(upper_raw) || upper_raw == "none") Inf else suppressWarnings(as.integer(upper_raw))
if (is.na(sap_version)) {
  stop("ESCALATE: SAP excerpt states no version; refusing to select Week 24 records.")
}
if (is.na(lower) || is.na(target) || is.na(upper)) {
  stop("ESCALATE: SAP excerpt states no usable window; refusing to select Week 24 records.")
}

ad <- read.csv(data_path, stringsAsFactors = FALSE)
ad <- ad[ad$EFFFL == "Y" & ad$ITTFL == "Y" & ad$PARAMCD == "ACTOT", ]
ad$SITEGR1 <- factor(ad$SITEGR1)

pick_subject <- function(d) {
  obs <- d[d$DTYPE != "LOCF" & d$ADY >= lower & d$ADY <= upper, ]
  if (nrow(obs) > 0) {
    obs <- obs[order(abs(obs$ADY - target), obs$ADY), ]
    return(obs[1, ])
  }
  locf <- d[d$DTYPE == "LOCF", ]
  if (nrow(locf) > 0) {
    locf <- locf[order(abs(locf$ADY - target), locf$ADY), ]
    return(locf[1, ])
  }
  NULL
}
parts <- lapply(split(ad, ad$USUBJID), pick_subject)
parts <- parts[!vapply(parts, is.null, logical(1))]
sel <- do.call(rbind, parts)
row.names(sel) <- NULL
sel$SAP_VERSION <- sap_version
sel$CODE_VERSION <- code_version
write.csv(sel, out_sel, row.names = FALSE)

summarize_arm <- function(d, col) {
  v <- d[[col]][!is.na(d[[col]])]
  c(n = length(v), mean = mean(v), sd = stats::sd(v))
}
arms <- c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
rows <- lapply(arms, function(a) {
  d <- sel[sel$TRTP == a, ]
  c(arm = a, summarize_arm(d, "CHG"))
})
sum_df <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)

fit <- (function() {
  op <- options(contrasts = c("contr.sum", "contr.poly"))
  on.exit(options(op), add = TRUE)
  stats::lm(CHG ~ TRTPN + SITEGR1 + BASE, data = sel)
})()
dose_p <- stats::drop1(fit, . ~ ., test = "F")["TRTPN", "Pr(>F)"]
sum_df$dose_response_p <- ""
sum_df$dose_response_p[1] <- formatC(dose_p, format = "f", digits = 3)
write.csv(sum_df, out_sum, row.names = FALSE)
cat("selected", nrow(sel), "subjects sap_version=", sap_version,
    " dose_response_p=", formatC(dose_p, format = "f", digits = 3), "\n", sep = "")
