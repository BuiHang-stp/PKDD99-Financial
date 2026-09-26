# Czech Code Mapping

## Purpose

This document is the single reference for all categorical codes in the PKDD'99 Financial dataset and the English labels used from the Silver layer onward.

> Raw codes are preserved exactly as they appear in the source data, including spaces, dots and letter case.

---

## Mapping Reference

| table_name | column_name | code | label | short_label | sort_order | meaning | source |
|---|---|---|---|---|---:|---|---|
| account | frequency | `POPLATEK MESICNE` | Monthly | Monthly | 1 | Statement issued monthly. | Data description |
| account | frequency | `POPLATEK TYDNE` | Weekly | Weekly | 2 | Statement issued weekly. | Data description |
| account | frequency | `POPLATEK PO OBRATU` | After Transaction | After Txn | 3 | Statement issued after each transaction. | Data description |
| disp | type | `OWNER` | Owner | Owner | 1 | Account owner; only the owner can issue permanent orders and apply for a loan. | Data description |
| disp | type | `DISPONENT` | Authorized User | User | 2 | Person allowed to operate the account, with limited rights. | Data description |
| trans | type | `PRIJEM` | Credit | Credit | 1 | Money coming into the account. | Data description |
| trans | type | `VYDAJ` | Debit | Debit | 2 | Money leaving the account. | Data description |
| trans | operation | `VKLAD` | Cash Deposit | Cash In | 1 | Cash deposited into the account. | Data description |
| trans | operation | `PREVOD Z UCTU` | Incoming Transfer | Transfer In | 2 | Transfer received from another bank. | Data description |
| trans | operation | `VYBER` | Cash Withdrawal | Cash Out | 3 | Cash withdrawn from the account. | Data description |
| trans | operation | `VYBER KARTOU` | Card Withdrawal | Card Out | 4 | Cash withdrawn using a card. | Data description |
| trans | operation | `PREVOD NA UCET` | Outgoing Transfer | Transfer Out | 5 | Transfer sent to another bank. | Data description |
| trans | k_symbol | `UROK` | Interest Credited | Interest | 1 | Interest credited to the account. | Data description |
| trans | k_symbol | `DUCHOD` | Pension | Pension | 2 | Old-age pension received. | Data description |
| trans | k_symbol | `SIPO` | Household Payment | Household | 3 | Household payment (e.g. utilities). | Data description |
| trans | k_symbol | `POJISTNE` | Insurance Payment | Insurance | 4 | Insurance payment. | Data description |
| trans | k_symbol | `UVER` | Loan Payment | Loan Repay | 5 | Loan repayment. | Data description |
| trans | k_symbol | `SLUZBY` | Statement Fee | Stmt Fee | 6 | Fee for the account statement. | Data description |
| trans | k_symbol | `SANKC. UROK` | Penalty Interest | Penalty | 7 | Penalty interest charged when the balance is negative. | Data description |
| order | k_symbol | `SIPO` | Household Payment | Household | 1 | Standing order for household payments. | Data description |
| order | k_symbol | `POJISTNE` | Insurance Payment | Insurance | 2 | Standing order for insurance. | Data description |
| order | k_symbol | `LEASING` | Leasing Payment | Leasing | 3 | Standing order for leasing. | Data description |
| order | k_symbol | `UVER` | Loan Payment | Loan Repay | 4 | Standing order for loan repayment. | Data description |
| card | type | `junior` | Junior | Junior | 1 | Junior card. | Data description |
| card | type | `classic` | Classic | Classic | 2 | Classic card. | Data description |
| card | type | `gold` | Gold | Gold | 3 | Gold card. | Data description |
| loan | status | `A` | Finished - Paid | Paid | 1 | Contract finished with no repayment problems. | Data description |
| loan | status | `B` | Finished - Unpaid | Unpaid | 2 | Contract finished but the loan was not fully repaid. | Data description |
| loan | status | `C` | Running - OK | Current | 3 | Contract still running, repayments OK so far. | Data description |
| loan | status | `D` | Running - In Debt | In Debt | 4 | Contract still running, client in debt. | Data description |

---