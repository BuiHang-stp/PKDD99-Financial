# PKDD99-Financial — Project Context

> Source: [PKDD'99 Discovery Challenge — Financial dataset](https://web.archive.org/web/20180506061559/http://lisp.vse.cz/pkdd99/Challenge/chall.htm). Real, anonymized data from a Czech bank, 1993–1998.

---

## Overview

A retail bank offers accounts, payments, loans and cards to individual clients. It stores data on its clients, their accounts, every transaction, standing payment orders, loans and issued cards, plus socio-economic data for each district.

In the original challenge, the bank states the problem this way: managers have only a vague idea of **who is a good client** (to offer more services) and **who is a bad client** (to watch carefully and reduce losses).

---

## Source Data

| Table | Rows | Description |
|---|---:|---|
| `account` | 4,500 | Accounts: opening date, branch district, statement frequency |
| `client` | 5,369 | Clients: birth date and gender (encoded), home district |
| `disp` | 5,369 | Links clients to accounts, with role (owner / user) |
| `trans` | 1,056,320 | Transactions: date, type, operation, amount, balance after |
| `order` | 6,471 | Standing payment orders (debits only) |
| `loan` | 682 | Loans: date, amount, duration, monthly payment, status |
| `card` | 892 | Cards issued to a disposition |
| `district` | 77 | District data: population, salary, unemployment, crime |


---

## Business Problems

1. **Customer activity:** the bank lacks a consistent view of how actively accounts are used over time and how customer engagement changes month by month.

2. **Credit risk:** some loans experience repayment problems. The bank wants to understand whether account behaviour before loan origination contains useful early-warning signals.

3. **Cross-sell:** the bank wants to identify healthy, active clients who do not currently hold a card and may be suitable for a card offer.

---

## Analysis

| # | Question | Business use | Output |
|---|---|---|---|
| 1 | How actively are accounts used over time, and what does this imply about customer engagement? | Retail banking performance tracking | KPI dashboard |
| 2 | Does pre-loan account behaviour signal elevated repayment risk? | Credit risk / early warning | Memo + watch list |
| 3 | Which healthy, active clients do not currently hold a card? | Card cross-sell campaign | Target list |

Ad-hoc questions answered with the same data are kept in `docs/adhoc/`.

---

## Role

Act as a Data Analyst in the bank's analytics team. Build a PostgreSQL warehouse with a Medallion architecture (bronze → silver → gold), answer the three analysis questions above, and handle short ad-hoc questions from business teams (Retail, Credit, Card Product).

---

## Ad-hoc Query List (Basic → Advanced)

### Basic

1. **Q1: Number of clients, accounts, loans, cards** (`count`)

2. **Q2: Loans by status A / B / C / D** (`group-by`, `share-of-total`)

3. **Q3: Accounts by statement frequency** (`group-by`, `case-when`)

4. **Q4: Client gender and age distribution** (`substring`, `make-date`, `case-when`)

5. **Q5: Transaction count and amount by type and operation** (`group-by`, `sum`)

### Intermediate

6. **Q6: Share of accounts with a loan, a card, a standing order** (`left-join`, `count-distinct`)

7. **Q7: Accounts shared by an owner and a user** (`group-by`, `having`)

8. **Q8: Money in and out per month** (`date-trunc`, `conditional-sum`)

9. **Q9: Problematic-loan rate by duration and amount band, with sample size** (`case-when`, `ratio`)

10. **Q10: Accounts that ever paid penalty interest** (`filter`, `count-distinct`)

### Advanced

11. **Q11: Monthly active accounts and active rate, month over month** (`generate-series`, `cte`, `lag`)

12. **Q12: End-of-month balance per account, carried forward in months with no transactions** (`window`, `row-number`, `carry-forward`)

13. **Q13: Dormant accounts (no client activity for 3+ months)** (`window`, `gaps-and-islands`)

14. **Q14: Account behaviour in the 6 months before each loan, healthy vs problematic loans** (`date-window-join`, `cte`, `no-leakage`)

15. **Q15: Active, healthy clients with no card, split into priority tiers** (`anti-join`, `ntile`)

---

## Known Constraints

- Only 682 loans; the number of problematic loans is small and will be confirmed during scope checking. Credit findings are reported with sample sizes and treated as signals, not as a validated predictive model.

- The dataset does not include account closing dates, days-past-due measures, credit bureau data, or other modern credit-risk variables.

- Data covers 1993–1998 and is used to practise analytical methods and data modeling, not to describe today's banking market.