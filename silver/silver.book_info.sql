SELECT * FROM bronze.book_info LIMIT 1;

--- ========== To describe the table structure ========== ---
SELECT
	column_name,
	data_type,
	character_maximum_length,
	is_nullable,
	column_default
FROM 
	information_schema.columns
WHERE TABLE_NAME = 'book_info';

--- ========== DROP EXISTING TABLE AND CREATE NEW ONE ========== ---
DROP TABLE IF EXISTS silver.book_info;

CREATE TABLE silver.book_info (
    book_id         TEXT PRIMARY KEY,
    title            TEXT NOT NULL,      -- final cleaned title
    subtitle         TEXT,
    authors          TEXT,               -- cleaned author names only
    publisher        TEXT,
    published_date   DATE,
    published_year   INT,
    description      TEXT,
    page_count       INT       CHECK (page_count > 0),
    categories       TEXT,
    average_rating   FLOAT     CHECK (average_rating BETWEEN 0 AND 5),
    ratings_count    INT       CHECK (ratings_count >= 0),
    language         VARCHAR(50),
    preview_link     TEXT,
    info_link        TEXT,
    isbn_13          VARCHAR(20),
    isbn_10          VARCHAR(20),
    list_price       FLOAT     CHECK (list_price >= 0),
    currency         VARCHAR(10),
    buyable          BOOLEAN,
    search_category  TEXT,
    thumbnail        TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- ============ REFINING THE DATA ============ ---

--- Making sure that there is no duplicate book_id in the table
SELECT COUNT(book_id), 'A' FROM bronze.book_info
UNION
SELECT COUNT(DISTINCT book_id), 'B' FROM bronze.book_info; --- 15147

--- Making sure that NO book_id in the table is NULL
SELECT COUNT(book_id) FROM bronze.book_info WHERE book_id IS NULL;

--- Making sure that book_id remains structured and consistent
--- We use REGEXP_REPLACE() if we want to deal with multiple characters to replace
SELECT 
book_id,
UPPER(TRIM(REGEXP_REPLACE(book_id, '[-_]', '', 'g')))
FROM bronze.book_info;



