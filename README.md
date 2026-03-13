# 🚌 detroit-transit-by-design

**Team:** Effect Size | **Course:** SURV745 — Practical Tools for Survey Design
**Assigned:** 2/23/2026 | **Due:** 4/20/2026
![](images/clipboard-3499325007.png)
---

## Project Overview

Three-stage area probability sample for a face-to-face survey on **transportation insecurity among Detroit, MI residents**. The design samples census tracts (PSUs) → block groups (SSUs) → persons, targeting 1,000 respondents across four age domains (18–34, 35–49, 50–64, 65+).

**Final Deliverables:**
- `REPORT_EffectSize.pdf` — Sampling report (10–15 pages)
- `FRAME1_EffectSize.csv` / `FRAME2_EffectSize.csv` — Tract- and BG-level frame files
- `SAMPLE_EffectSize.csv` — Selected sample with probabilities and weights

---

## Getting Started

### Prerequisites

Install R, RStudio, and the following packages if not already present:

```r
install.packages(c("here", "tidyverse", "readxl", "survey", "PracTools", "srvyr",
                   "sf", "tigris", "tidycensus", "viridis", "patchwork", "sampling"))
```

### Opening the Project

1. Clone the repo to any local folder on your machine
2. Open `detroit-transit-by-design.Rproj` in RStudio
3. On startup, the project-level `.Rprofile` will automatically:
   - Set the working directory to the repo root via `here`
   - Load the two input datasets into your session (`TractFIPS`, `Tract`, `BlockGroup`)

> ⚠️ Do **not** use absolute paths (e.g. `D:/repos/...`) anywhere in scripts. Always use `here()`.

### Path Conventions

All scripts use the `here` package for portable, cross-platform paths:

```r
library(here)

# Examples
here("data", "raw", "Detroit_MI.xlsx")
here("data", "processed", "FRAME1_EffectSize.csv")
```

---

## Repo Structure

```
detroit-transit-by-design/
│
├── data/
│   ├── raw/
│   │   ├── Detroit_MI.xlsx
│   │   └── Census_Tract_FIPS_Code_Detroit_MI.csv
│   └── processed/
│       ├── FRAME1_EffectSize.csv
│       ├── FRAME2_EffectSize.csv
│       └── SAMPLE_EffectSize.csv
│
├── R/
│   ├── 01_frame_construction.qmd
│   ├── 02_mos_and_design.qmd
│   ├── 03_sample_selection.qmd
│   ├── 04_precision_weighting.qmd
│   └── 05_maps.qmd
│
├── report/
│   └── REPORT_EffectSize.qmd
│
├── .Rprofile
├── detroit-transit-by-design.Rproj
└── README.md
```

---

## Task Checklist

| Phase | Tasks | Deadline |
|---|---|---|
| **1 — Frame Construction** | Build PSU (tract) and SSU (block group) frames; QC checks | Mar 6 |
| **2 — Sample Design** | Composite MOS; domain sampling rates; design rationale | Mar 16 |
| **3 — Sample Selection** | PPS selection of 40 PSUs + 1 SSU each; base weights | Mar 27 |
| **4 — Precision & Weighting** | CVs; weighting plan; variance estimation guidance | Apr 6 |
| **5 — Report & Maps** | Maps, codebooks, full PDF report assembly, submission | Apr 17 |

---

## Key Design Parameters

| Parameter | Value |
|---|---|
| Total respondents | 1,000 |
| Sample PSUs (tracts) | 40 |
| SSUs (BGs) per PSU | 1 |
| Domain 18–34 | n = 250, RR = 0.35 |
| Domain 35–49 | n = 250, RR = 0.45 |
| Domain 50–64 | n = 250, RR = 0.50 |
| Domain 65+ | n = 250, RR = 0.65 |
| PSU selection | PPS systematic (`UPsystematic`, `set.seed(-77)`) |
| Census data | 2020 Decennial DHC via `tidycensus` |

---

*"Sampling Detroit one block group at a time."* 🏙️
