# PKDD99-Financial

> 🌱 **Work in progress** — started Sep 2026

Analysis of real, anonymized data from a Czech bank (1993–1998) to understand how customers use their accounts, whether account behaviour before a loan signals default risk, and which customers to offer a card to. Built with PostgreSQL (bronze → silver → gold) and Power BI.

Full business context and analysis plan: [context.md](context.md)

## Business Questions

| # | Question | Business use |
|---|---|---|
| 1 | How actively do customers use their accounts, month by month? | Retail banking performance tracking |
| 2 | Does account behaviour before a loan signal a higher risk of default? | Credit risk / early warning |
| 3 | Which healthy, active customers have no card yet? | Card cross-sell campaign |

## Data

* **Source:** [PKDD'99 Financial dataset](https://relational.fel.cvut.cz/dataset/Financial)
* **Accessed:** 26 September 2026
* **Description:** Anonymized real-world banking data from a Czech bank, covering from 1993 to 1998
* **Tables:** 8 — account, client, disposition, transaction, permanent order, loan, credit card, and district
* **Raw data is not included in this repository.** See [docs/data_source.md](docs/data_source.md) for download instructions and file checksums.

## Approach

<!--
Add pipeline after implementation:

Raw data
→ Bronze
→ Silver
→ Gold
→ Power BI semantic model
→ Dashboard

Add ERD:
docs/erd.png
-->

## Data Quality & Validation

<!--
Document the 3–5 most important data-quality issues:
- issue
- impact
- validation method
- resolution

See docs/data_quality_log.md.
-->

## Key Findings

<!--
3–5 findings.
Each finding should contain:
- the result
- a number / percentage
- relevant sample size or denominator
- business interpretation
-->

## Recommendations

<!--
Actions that logically follow from the findings.
Do not make recommendations unsupported by the analysis.
-->

## Limitations

<!-- Examples:
- Historical dataset (1993–1998)
- Limited loan sample
- No detailed delinquency / DPD information
- Observational analysis
- Findings may not generalize to modern banking environments
-->

## How to Reproduce

<!--
1. Download the original dataset.
2. Create the PostgreSQL database.
3. Run SQL scripts in the documented order.
4. Run validation checks.
5. Connect the Gold layer to Power BI.
-->

## Tools

PostgreSQL · SQL · Power BI · DAX

---
## 💬 Thank you for reading this far!     
I'm always open to Data Analyst opportunities, as well as any feedback that helps the project improve.      
Feel free to reach out.

**Bùi Thu Hằng** — Data Analyst           
Reach me via [LinkedIn](https://www.linkedin.com/in/buithuhang/) or [Email - buihang.work@gmail.com](https://mail.google.com/mail/?view=cm&fs=1&to=buihang.work@gmail.com).