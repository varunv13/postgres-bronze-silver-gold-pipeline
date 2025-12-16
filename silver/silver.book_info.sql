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

--- ========= Queries to find the published date ========= ---

SELECT 
COUNT(book_id)
FROM bronze.book_info 
WHERE published_date IS NULL; --- 214 

SELECT 
COUNT(book_id) 
FROM bronze.book_info 
WHERE LENGTH(TRIM(published_date)) = 10; --- 6054

SELECT 
COUNT(book_id)
FROM bronze.book_info
WHERE LENGTH(TRIM(published_date)) = 4; --- 8407

SELECT 
COUNT(book_id)
FROM bronze.book_info
WHERE LENGTH(TRIM(published_date)) = 7; --- 455

SELECT 
LENGTH(book_id)
FROM bronze.book_info
WHERE LENGTH(TRIM(published_date)) > 10; --- 14

SELECT 
COUNT(book_id)
FROM bronze.book_info
WHERE LENGTH(TRIM(published_date)) = 5; --- 3

--- ===== AVERAGE RATING LOGIC TO CHANGE ===== ---

SELECT DISTINCT average_rating FROM bronze.book_info;

SELECT
average_rating,
CASE
WHEN average_rating = 1 THEN 1 
WHEN average_rating IN (1.5, 2) THEN 2
WHEN average_rating IN (2.5, 3) THEN 3
WHEN average_rating IN (3.5, 4) THEN 4
WHEN average_rating IN (4.5, 5) THEN 5
ELSE 0
END AS new_average_rating
FROM bronze.book_info;


--- NOTE: WE REMOVE ALL THOSE RECORDS FOR WHICH WE FOUND THE LIST PRICE 0 OR NULL ---
SELECT 
COUNT(list_price) 
FROM bronze.book_info
WHERE list_price IS NULL OR list_price = 0; --- 58 records will be removed

--- NOTE: WE WILL REMOVE THOSE RECORDS WHOSE TITLE ARE NOT PRESENT ---
SELECT 
COUNT(book_id)
FROM bronze.book_info
WHERE title IS NULL; --- 8 RECORDS WILL BE REMOVED

--- NOTE: WE WILL MAKE CHANGES WITH THOSE RECORDS WHOSE TITLE CONTAINS BEST SELLER ---
SELECT COUNT(book_id)
FROM bronze.book_info
WHERE title ILIKE '%BEST%SELLER%'; --- 25

--- NOTE: WE FOUND ALL THOSE ISBN NUMBERS WHICH WERE NULL ---
SELECT
COUNT(book_id)
FROM bronze.book_info
WHERE isbn_13 IS NULL; --- 7764

SELECT
COUNT(book_id)
FROM bronze.book_info
WHERE isbn_10 IS NULL; --- 8026

SELECT
COUNT(book_id)
FROM bronze.book_info
WHERE isbn_13 IS NULL AND isbn_10 IS NULL; --- 7764

--- ===== RATINGS COUNTS & AVERAGE COUNTS ===== ---
SELECT *
FROM bronze.book_info
WHERE average_rating IS NULL AND ratings_count = 0; ---- 14290, THESE RECORDS ARE YET TO BE RATED

SELECT COUNT(book_id)
FROM bronze.book_info
WHERE average_rating IS NOT NULL AND ratings_count IS NULL; --- 0 NO RECORDS

--- ===== PAGE COUNT ===== ---
SELECT *
FROM bronze.book_info
WHERE page_count <= 0; --- 858, WE WILL NOT CONSIDER THOSE RECORDS WHOSE PAGE COUNT IS 0 OR NULL

SELECT COUNT(book_id)
FROM bronze.book_info
WHERE page_count IS NULL; --- 214

--- ===== LANGUAGE ===== ---
SELECT COUNT(DISTINCT(language))
FROM bronze.book_info; --- 37

