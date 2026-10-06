-- 01_load_bronze.sql
-- Create bronze tables and load the original PKDD'99 raw .asc files.
-- Bronze keeps source column names and stores all raw columns as TEXT.
-- Data cleaning, type casting, renaming, and constraints are handled in silver.

-- bronze.account
CREATE TABLE bronze.account(
    account_id TEXT,
    district_id TEXT,
    frequency TEXT,
    "date" TEXT,
    ingrested_at TIMESTAMP DEFAULT now()
)
COPY bronze.account(
    account_id,
    district_id,
    frequency,
    "date"
)
FROM '<RAW_DATA_DIR>/account.asc'
WITH(
    FORMAT csv,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);

-- bronze.card
CREATE TABLE bronze.card(
	card_id TEXT,
	disp_id TEXT,
	"type" TEXT,
	issued TEXT,
	ingested_at TIMESTAMP default now()
);

COPY bronze.card(
	card_id,
	disp_id,
	"type",
	issued
)
FROM '<RAW_DATA_DIR>/card.asc'
WITH (
    FORMAT csv,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);

-- bronze.client
CREATE TABLE bronze.client(
	client_id TEXT,
	birth_number TEXT,
	district_id TEXT
    ingested_at TIMESTAMP default now()
);

COPY bronze.client(
	client_id,
	birth_number,
	district_id
)
FROM '<RAW_DATA_DIR>/client.asc'
WITH (
	FORMAT CSV,
	DELIMITER ';',
	QUOTE '"',
	HEADER true
);

-- bronze.disp
CREATE TABLE bronze.disp(
	disp_id TEXT,
	client_id TEXT,
	account_id TEXT,
	"type" TEXT,
	ingested_at TIMESTAMP DEFAULT now()
); 

COPY bronze.disp(
	disp_id,
	client_id,
	account_id,
	"type" 
)
FROM '<RAW_DATA_DIR>/disp.asc'
WITH (
	FORMAT CSV,
	DELIMITER ';',
	QUOTE '"',
	HEADER true
);

-- bronze.district
CREATE TABLE bronze.district(
    A1 TEXT,
    A2 TEXT,
    A3 TEXT,
    A4 TEXT,
    A5 TEXT,
    A6 TEXT,
    A7 TEXT,
    A8 TEXT,
    A9 TEXT,
    A10 TEXT,
    A11 TEXT,
    A12 TEXT,
    A13 TEXT,
    A14 TEXT,
    A15 TEXT,
    A16 TEXT,
    ingested_at TIMESTAMP DEFAULT now()
);

COPY bronze.district(
    A1,
    A2,
    A3,
    A4,
    A5,
    A6,
    A7,
    A8,
    A9,
    A10,
    A11,
    A12,
    A13,
    A14,
    A15,
    A16
)
FROM '<RAW_DATA_DIR>/district.asc'
WITH (
    FORMAT CSV,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);

-- bronze.loan
CREATE TABLE bronze.loan(
    "loan_id" TEXT,
    account_id TEXT,
    "date" TEXT,
    amount TEXT,
    duration TEXT,
    payments TEXT,
    status TEXT
    ingested_at TIMESTAMP DEFAULT now()    
);

COPY bronze.loan(
    loan_id,
    account_id,
    "date",
    amount,
    duration,
    payments,
    status
)
FROM '<RAW_DATA_DIR>/loan.asc'
WITH(
    FORMAT CSV,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);

-- bronze.order
CREATE TABLE bronze."order"(
    order_id TEXT,
    account_id TEXT, 
    bank_to TEXT,
    account_to TEXT,
    amount TEXT,
    k_symbol TEXT,
    ingested_at TIMESTAMP DEFAULT now()
);

COPY bronze."order"(
    order_id,
    account_id, 
    bank_to,
    account_to,
    amount,
    k_symbol
)
FROM '<RAW_DATA_DIR>/order.asc'
WITH (
    FORMAT CSV,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);

-- bronze.trans
CREATE TABLE bronze.trans(
    trans_id TEXT,
    account_id TEXT,
    "date" TEXT,
    "type" TEXT,
    operation TEXT,
    amount TEXT,
    balance TEXT,
    k_symbol TEXT,
    bank TEXT,
    account TEXT,
    ingested_at TIMESTAMP DEFAULT now()
);

COPY bronze.trans(
    trans_id,
    account_id,
    "date",
    "type",
    operation,
    amount,
    balance,
    k_symbol,
    bank,
    account
)
FROM '<RAW_DATA_DIR>/trans.asc'
WITH(
    FORMAT CSV,
    DELIMITER ';',
    QUOTE '"',
    HEADER true
);