# Raw Data Inspection

Goal: understand the real format of the 8 raw files **before** loading them into PostgreSQL.

---

## 1. Format summary

| File | Rows (per description) | Header | Header quoted | Text values quoted | Decimal separator | Date format | Empty values seen |
| --- | ---: | --- | --- | --- | --- | --- | --- |
| `account.asc` | 4,500 | Yes | Yes | Yes | – | `YYMMDD` | No |
| `client.asc` | 5,369 | Yes | Yes | Yes | – | encoded in `birth_number` | No |
| `disp.asc` | 5,369 | Yes | Yes | Yes | – | – | No |
| `trans.asc` | 1,056,320 | Yes | Yes | Yes | `.` | `YYMMDD` | **Yes: `""` and `;;`** |
| `order.asc` | 6,471 | Yes | Yes | Yes | `.` | – | No |
| `loan.asc` | 682 | Yes | Yes | Yes | `.` | `YYMMDD` | No |
| `card.asc` | 892 | Yes | Yes | Yes | – | `YYMMDD 00:00:00` | No |
| `district.asc` | 77 | Yes | **No** | Yes | `.` | – | No |

All files use `;` as the column delimiter and `"` as the quote character.

---

## 2. Load decisions for the bronze layer

Based on the summary above, every file can be loaded with the same settings:

```sql
COPY bronze.<table> FROM '<path>/<file>.asc'
WITH (FORMAT csv, DELIMITER ';', QUOTE '"', HEADER true);
```

Decisions:

1. **All columns are loaded as `text`.** No type casting in bronze, so an unexpected value cannot break the load or be silently changed.
2. **Each bronze table gets an `ingested_at` column** to record when the data was loaded.
3. **Empty values in `trans.asc` need attention.** In PostgreSQL `COPY ... FORMAT csv`, an unquoted empty field (`;;`) is read as `NULL`, but a quoted empty string (`""`) is read as an empty string `''`. The same column can therefore contain both `NULL` and `''`. → **Verify after load:** count `NULL` and `''` separately in `k_symbol`, `operation`, `bank`, `account`.
4. **Encoded fields are decoded in silver, not in bronze:** dates (`YYMMDD`), `birth_number`, Czech codes.

---

## 3. Findings

### `client.asc`

Evidence: `1;"706213";18`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | `birth_number` is a quoted 6-digit code | `"706213"`, `"450204"` | Keep as text in bronze |
| 2 | For women, the month part is month + 50 | `"706213"` → month 62 → 62 − 50 = 12 → female, born 1970-12-13 | Decode `birth_date` and `gender` in silver; keep original `birth_number` |
| 3 | `district_id` is the client's address (not the branch) | Data description | Join to `district` for client location |

### `account.asc`

Evidence: `576;55;"POPLATEK MESICNE";930101`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | `frequency` is a quoted Czech code | `"POPLATEK MESICNE"` | Translate in silver using the mapping table |
| 2 | `district_id` is the location of the branch | Data description | Do not confuse with the client's district |
| 3 | `account_id` is the main join key to `trans`, `order`, `loan`, `disp` | Data description | Check uniqueness and orphan keys after load |

### `disp.asc`

Evidence: `4;4;3;"OWNER"` and `5;5;3;"DISPONENT"`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | One account can have two clients with different roles | Account 3 has one `OWNER` and one `DISPONENT` | Joining `client → disp → account → trans` without filtering will duplicate transactions. Use the owner when a client attribute is needed |
| 2 | `disp` is the bridge table between `client` and `account` | Data description | Keep this relationship in the schema design |

### `trans.asc`

Evidence: `695247;2378;930101;"PRIJEM";"VKLAD";700.00;700.00;"";;`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | Two forms of empty value | `""` and `;;` | See load decision 3 |
| 2 | Partner `account` looks numeric but is quoted | `"62457513"` | Treat as an identifier (text), not a number |
| 3 | `amount` and `balance` have decimals | `700.00`, `4881.80` | Use a decimal type (e.g. `NUMERIC`) in silver |
| 4 | `type`, `operation`, `k_symbol` are Czech codes | `"PRIJEM"`, `"VKLAD"` | Translate in silver; keep original codes |
| 5 | `date` is `YYMMDD` | `930101` → 1993-01-01 | Convert in silver with an explicit century rule (19xx) |

### `order.asc`

Evidence: `29401;1;"YZ";"87144583";2452.00;"SIPO"`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | Orders are debits only (money leaving the account) | Data description | Treat as fixed monthly obligations |
| 2 | `account_to` looks numeric but is quoted | `"87144583"` | Treat as an identifier (text) |
| 3 | One account can have several orders | Account 3 appears in several rows | Relationship `account → order` is one-to-many |

### `loan.asc`

Evidence: `5314;1787;930705;96396;12;8033.00;"B"`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | `amount` looks like an integer, `payments` has decimals | `96396`, `8033.00` | Check the full column before choosing types |
| 2 | `duration` values are multiples of 12 | `12, 24, 36, 48, 60` | Unit is months (per description) |
| 3 | `status` is the loan outcome: A, B, C, D | `"A"`, `"B"` | Main outcome variable. Bad-loan definition will be decided and documented in `metric_definitions.md` |

### `card.asc`

Evidence: `1005;9285;"classic";931107 00:00:00`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | `issued` contains a date and a time part | `931107 00:00:00` | Time is always `00:00:00` in the sample → keep only the date in silver. **Verify after load** that no other time exists |
| 2 | A card is linked to `disp_id`, not directly to an account or client | `disp_id = 9285` | Relationship: `card → disp → client / account` |

### `district.asc`

Evidence: `1;"Hl.m. Praha";"Prague";1204953;...`

| # | Observation | Evidence | Decision |
| --- | --- | --- | --- |
| 1 | Header is not quoted, unlike the other files | `A1;A2;A3;...;A16` | No impact with `FORMAT csv` |
| 2 | Column names `A1`–`A16` have no meaning on their own | Data description | Rename in silver (`district_name`, `region`, `avg_salary`, ...) |
| 3 | Some columns have decimals | `0.29`, `46.7` | Use a decimal type for ratios and rates |