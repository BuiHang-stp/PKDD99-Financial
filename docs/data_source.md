# Data Source

## Source

* **Dataset:** PKDD'99 Financial Dataset
* **Source:** [PKDD'99 Discovery Challenge](https://web.archive.org/web/20180506061559/http://lisp.vse.cz/pkdd99/Challenge/chall.htm)
* **Accessed:** 26 September 2026
* **Description:** Anonymized real-world banking data from a Czech bank, covering 1993–1998.

## Raw Files

The original financial dataset used in this project contains eight relational data files.

| File           | Description                      | Size (bytes) | SHA256                                                             |
| -------------- | -------------------------------- | -----------: | ------------------------------------------------------------------ |
| `account.asc`  | Account information              |      155,356 | `58D7F50ABD72E9B1A5568346F74BB54CD71224EE1DB9F09A27D7CAC563F38CC6` |
| `card.asc`     | Credit card information          |       31,588 | `FC669BDE6ADF6457D87421C0BFB218E9C384A7032C6ACCD348D207A405E72109` |
| `client.asc`   | Client information               |       94,820 | `E435C6B92D246F4F0DFD5E2827469D745C06238714C32B3FFB415EEBE794E1A7` |
| `disp.asc`     | Client–account relationships     |      129,716 | `EBD801F77B6D322E8EBC08E52F188E7C8FCA539325F85F57F8C73434DA9D32D8` |
| `district.asc` | District demographic information |        6,574 | `7F03CF3B9B82F0FDCC3ABDF6CC716F145DB8E9875C68E2D2E2F7151E9ECF4DF3` |
| `loan.asc`     | Loan information                 |       27,037 | `68535F609A254AA7A3F03DD8E27DCB822B532DF12A0D6046F0666B8DC0B8AE8E` |
| `order.asc`    | Permanent payment orders         |      273,800 | `035930FA6ACD2CA42A935E654B21E1BB260248F49B6DC6E7DE6351B7C4D56D02` |
| `trans.asc`    | Account transactions             |   69,406,578 | `75AB2F39DF9D79D79C5C900DE90DDD28248B689F214598AC9FA2FF0F574A70D2` |

**Total raw data size:** 70,125,469 bytes.

## Data Integrity

Files in `data/raw/` are preserved in their original extracted form.

No transformations, manual edits, delimiter changes, encoding conversions, or spreadsheet resaves are performed on the raw files.

SHA256 checksums are recorded above so that the exact source files used in this project can be independently verified.

## Repository Policy

Raw source files are not committed to this repository.

To reproduce the source data setup:

1. Download the PKDD'99 Financial dataset from the source above.
2. Extract the eight `.asc` files into `data/raw/`.
3. Run the following command in PowerShell:

```powershell
Get-FileHash .\data\raw\*.asc -Algorithm SHA256 |
Select-Object @{Name='File';Expression={Split-Path $_.Path -Leaf}}, Hash
```

4. Compare the resulting SHA256 hashes with the values recorded above.
