"use strict";

// Benchmark review progress as a GitHub-style heatmap: one square per yamaa
// SDTM, SEND, or ADaM benchmark, grey with no review, light green with one
// reviewer, green with two or more. Approval needs two reviewers.
//
// GROUPS lists the benchmarks on yamaa main at commit 93a6757, by standard,
// then domain, then name. SNAPSHOT counts the reviewers of each benchmark in
// https://elong0527.github.io/yamaa/benchmark/review/reviews.json at the time
// it names. The slide draws the snapshot, then redraws from the live file
// when the network allows, again each time the slide is shown, so reviews
// posted during the workshop appear. The yamaa Docs workflow rebuilds that
// file whenever a review discussion is created.
(() => {
  const SOURCE = "https://elong0527.github.io/yamaa/benchmark/review/reviews.json";
  const PAGE = "https://elong0527.github.io/yamaa/benchmark/";
  const GROUPS = [
    ["ADaM", [
      "adam-adae-adamig11", "adam-adae-analysis-time", "adam-adae-death",
      "adam-adae-exposure-adjusted-incidence", "adam-adae-occurrence-flags",
      "adam-adae-onset-emergence", "adam-adae-partial-dates",
      "adam-adae-partial-times", "adam-adae-phase-emergence",
      "adam-adae-post-dose-window", "adam-adae-post-index",
      "adam-adae-prior-serious-event", "adam-adae-proper-case-terms",
      "adam-adae-protocol-review", "adam-adae-query-flags",
      "adam-adae-review-order", "adam-adae-serious-events",
      "adam-adae-serious-sequence", "adam-adae-severity",
      "adam-adae-severity-override", "adam-adae-severity-rank",
      "adam-adae-text-cleanup", "adam-adae-worsening-emergence",
      "adam-adae-worst-severity", "adam-adaecm-related-pairs",
      "adam-adce-worst-toxicity", "adam-adcm-atc-classes",
      "adam-adcm-end-date-bound", "adam-adcm-free-text-start-date",
      "adam-adcm-on-treatment", "adam-adcm-related-events",
      "adam-adeg-derived-intervals", "adam-adeg-placebo-corrected-change",
      "adam-adeg-qtc-flags", "adam-adeg-replicate-qtc-average",
      "adam-adeg-time-matched-baseline",
      "adam-adeg-time-matched-concentration", "adam-adex-cumulative-dose",
      "adam-adex-dose-reduction", "adam-adex-infusion-duration",
      "adam-adex-uncollected", "adam-adfa-fever", "adam-adice-governing-event",
      "adam-adis-log-titer", "adam-adlb-adamig11", "adam-adlb-bds",
      "adam-adlb-character-result-text", "adam-adlb-closest-visit",
      "adam-adlb-end-of-treatment", "adam-adlb-limit-imputation",
      "adam-adlb-lymphocytes", "adam-adlb-mean", "adam-adlb-metadata",
      "adam-adlb-nonparametric-limits", "adam-adlb-ordered-sum",
      "adam-adlb-parameter-names", "adam-adlb-reference-limits",
      "adam-adlb-reported-precision", "adam-adlb-shift-criteria",
      "adam-adlb-supplb-padded-key", "adam-adlbc-row-window",
      "adam-adlbc-window-chain", "adam-adoe-study-eye",
      "adam-adpc-blq-imputation", "adam-adpc-relative-times",
      "adam-adpp-accumulation-ratio", "adam-adpp-carryover-exclusion",
      "adam-adpp-comparison-sets", "adam-adpp-dose-normalized",
      "adam-adpp-geometric-mean-ratio", "adam-adpp-period-treatment",
      "adam-adqs-missed-visit-locf", "adam-adqs-multi-scale-scoring",
      "adam-adqs-pro-phantom-records", "adam-adqs-screening-baseline",
      "adam-adqs-subscale-score", "adam-adrs-best-response",
      "adam-adrs-composite-response", "adam-adrs-confirmed-response",
      "adam-adrs-measurable-disease", "adam-adrs-response-prep",
      "adam-adrs-response-records", "adam-adsl-adamig11", "adam-adsl-adamig12",
      "adam-adsl-age-group", "adam-adsl-alive-date", "adam-adsl-analysis-age",
      "adam-adsl-bmi", "adam-adsl-bmi-quartile-group",
      "adam-adsl-completion-flag", "adam-adsl-country-region",
      "adam-adsl-crossover-periods", "adam-adsl-crossover-sequence",
      "adam-adsl-demographics", "adam-adsl-disposition",
      "adam-adsl-dose-adjustment", "adam-adsl-duration",
      "adam-adsl-flag-chain", "adam-adsl-investigator-comment",
      "adam-adsl-new-therapy", "adam-adsl-period-dates",
      "adam-adsl-period-status", "adam-adsl-randomization",
      "adam-adsl-rescue-med", "adam-adsl-site-parse", "adam-adsl-treatment",
      "adam-adsl-xpt", "adam-adtr-nadir", "adam-adtr-sum", "adam-adtte-dor",
      "adam-adtte-first-ae", "adam-adtte-os", "adam-adtte-pfs",
      "adam-adtte-pro-deterioration", "adam-advs-bmi", "adam-advs-bsa",
      "adam-advs-carryforward", "adam-advs-crossover-period-records",
      "adam-advs-dosing-weight", "adam-advs-first-observed-carry",
      "adam-advs-locf", "adam-advs-locf-record", "adam-advs-map",
      "adam-advs-orthostatic-criteria", "adam-advs-percentiles",
      "adam-advs-prior-result", "adam-advs-window-table", "adam-advs-windows",
      "adam-clinsite-site-level", "adam-results-ae-incidence"
    ]],
    ["SDTM", [
      "sdtm-ae-coding", "sdtm-ae-meddra-hierarchy", "sdtm-ae-odm-repeated",
      "sdtm-ae-partial-dates", "sdtm-ae-seriousness",
      "sdtm-cm-collected-medications", "sdtm-cm-odm-repeated",
      "sdtm-cm-whodrug-coding", "sdtm-co-long-comments", "sdtm-dm-age",
      "sdtm-dm-arms", "sdtm-dm-basic", "sdtm-dm-dates", "sdtm-dm-death",
      "sdtm-dm-metadata", "sdtm-dm-no-deaths", "sdtm-dm-odm-snapshot",
      "sdtm-dm-race-ethnicity", "sdtm-dm-sdtmig33", "sdtm-dm-xpt",
      "sdtm-ds-multi-form-disposition", "sdtm-ds-reasons", "sdtm-ds-sequence",
      "sdtm-ec-collected-exposure", "sdtm-eg-ecg-findings",
      "sdtm-ex-combination", "sdtm-ex-from-ec", "sdtm-ex-infusion-duration",
      "sdtm-ex-intervals", "sdtm-fa-event-findings", "sdtm-fa-odm-multitest",
      "sdtm-fa-reactogenicity-diary", "sdtm-lb-character-results",
      "sdtm-lb-compartments", "sdtm-lb-findings", "sdtm-lb-grading",
      "sdtm-lb-lab-specific-ranges",
      "sdtm-lb-last-observation-before-exposure", "sdtm-lb-metadata",
      "sdtm-lb-multiform", "sdtm-lb-ranges", "sdtm-mh-ongoing-conditions",
      "sdtm-mh-prespecified-conditions", "sdtm-mo-sdtmig33",
      "sdtm-pc-pk-concentrations", "sdtm-pp-pk-parameters",
      "sdtm-pr-procedures", "sdtm-qs-questionnaire-items",
      "sdtm-relrec-dataset-level", "sdtm-relrec-links",
      "sdtm-rs-timepoint-response", "sdtm-se-subject-elements",
      "sdtm-suppdm-metadata", "sdtm-suppmh-linkage", "sdtm-suppmh-long-terms",
      "sdtm-suppmh-qualifiers", "sdtm-sv-sdtmig33", "sdtm-sv-subject-visits",
      "sdtm-ta-sponsor-epoch", "sdtm-tr-tumor-measurements",
      "sdtm-ts-trial-summary", "sdtm-tu-tumor-identification",
      "sdtm-vs-collected-form", "sdtm-vs-epoch-from-subject-elements",
      "sdtm-vs-planned-time-points", "sdtm-vs-replicates", "sdtm-vs-study-day",
      "sdtm-vs-units"
    ]],
    ["SEND", [
      "send-bw-sendig311"
    ]],
  ];
  const SNAPSHOT = {
    updated: "2026-11-11 00:19 UTC",
    reviewers: {
      "adam-adae-adamig11": 2, "adam-adae-analysis-time": 2,
      "adam-adae-death": 1, "adam-adae-exposure-adjusted-incidence": 1,
      "adam-adex-infusion-duration": 2, "adam-adex-uncollected": 2,
      "adam-adfa-fever": 2, "adam-adice-governing-event": 1,
      "adam-adqs-missed-visit-locf": 1, "adam-adrs-best-response": 1,
      "adam-adsl-flag-chain": 1, "adam-adsl-investigator-comment": 1,
      "adam-adsl-new-therapy": 1, "sdtm-ae-coding": 2,
      "sdtm-ae-seriousness": 1, "sdtm-dm-basic": 2, "sdtm-pp-pk-parameters": 1,
      "sdtm-pr-procedures": 1, "sdtm-qs-questionnaire-items": 2,
      "sdtm-relrec-dataset-level": 2, "sdtm-relrec-links": 2,
      "sdtm-rs-timepoint-response": 2, "sdtm-se-subject-elements": 2,
      "sdtm-suppdm-metadata": 2, "sdtm-suppmh-linkage": 2,
      "sdtm-suppmh-long-terms": 2, "sdtm-suppmh-qualifiers": 1,
      "sdtm-sv-sdtmig33": 2, "sdtm-sv-subject-visits": 1,
      "sdtm-ta-sponsor-epoch": 1, "sdtm-tr-tumor-measurements": 1,
      "sdtm-ts-trial-summary": 1, "sdtm-tu-tumor-identification": 2,
      "sdtm-vs-collected-form": 1, "sdtm-vs-epoch-from-subject-elements": 1,
      "sdtm-vs-planned-time-points": 1, "sdtm-vs-replicates": 1,
      "sdtm-vs-study-day": 1, "sdtm-vs-units": 1
    },
  };

  const root = document.getElementById("review-heatmap");
  if (!root) return;

  function element(tag, className, text) {
    const node = document.createElement(tag);
    if (className) node.className = className;
    if (text !== undefined) node.textContent = text;
    return node;
  }

  function cell(count) {
    return element("span", `heatmap-cell level-${Math.min(count, 2)}`);
  }

  function draw(reviewers, updated, live) {
    let total = 0;
    let once = 0;
    let twice = 0;
    const groups = element("div", "heatmap-groups");
    for (const [standard, names] of GROUPS) {
      const group = element("div", "heatmap-group");
      const label = element("div", "heatmap-label", `${standard} `);
      label.append(element("span", "", String(names.length)));
      const grid = element("div", "heatmap-grid");
      for (const name of names) {
        const count = reviewers[name] || 0;
        total += 1;
        if (count >= 1) once += 1;
        if (count >= 2) twice += 1;
        const link = element("a", `heatmap-cell level-${Math.min(count, 2)}`);
        link.href = `${PAGE}${name}.html`;
        link.target = "_blank";
        link.rel = "noopener";
        link.title = `${name}: ${count} ${count === 1 ? "review" : "reviews"}`;
        grid.append(link);
      }
      group.append(label, grid);
      groups.append(group);
    }

    const legend = element("div", "heatmap-legend", "Reviews ");
    legend.append(cell(0), " 0 ", cell(1), " 1 ", cell(2), " 2");

    const summary = element("p", "heatmap-summary");
    summary.append(
      element("strong", "", `${once} of ${total}`),
      " benchmarks have a review; ",
      element("strong", "", String(twice)),
      ` have two. ${live ? "Live" : "Snapshot"}: ${updated}.`,
    );

    root.replaceChildren(groups, legend, summary);
  }

  function count(reviews) {
    const people = {};
    for (const review of reviews) {
      (people[review.benchmark] ||= new Set()).add(review.reviewer);
    }
    const found = {};
    for (const [name, reviewers] of Object.entries(people)) found[name] = reviewers.size;
    return found;
  }

  function refresh() {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 5000);
    fetch(SOURCE, { cache: "no-store", signal: controller.signal })
      .then((response) => (response.ok ? response.json() : Promise.reject(response.status)))
      .then((saved) => draw(count(saved.reviews), saved.updated, true))
      .catch(() => {})
      .finally(() => clearTimeout(timer));
  }

  draw(SNAPSHOT.reviewers, SNAPSHOT.updated, false);
  refresh();
  window.addEventListener("load", () => {
    if (!window.Reveal) return;
    window.Reveal.on("slidechanged", (event) => {
      if (event.currentSlide.contains(root)) refresh();
    });
  });
})();
