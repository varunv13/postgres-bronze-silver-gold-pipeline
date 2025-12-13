DROP TABLE IF EXISTS bronze.book_info;

CREATE TABLE bronze.book_info (
	book_id         VARCHAR(100),
	title           VARCHAR(200),
	subtitle        VARCHAR(300),
	authors         VARCHAR(300),
	publisher       VARCHAR(500),
	published_date  VARCHAR(100),
	description     TEXT,
	page_count      INT,
	categories      VARCHAR(200),
	average_rating  FLOAT,
	ratings_count   INT,
	language        VARCHAR(50),
	preview_link    TEXT NOT NULL,
	info_link       TEXT NOT NULL,
	isbn_13         VARCHAR(20),
	isbn_10         VARCHAR(20),
	list_price      FLOAT,
	currency        VARCHAR(20),
	buyable         VARCHAR(10),
	search_category VARCHAR(100),
	thumbnail       TEXT NOT NULL
);

ALTER TABLE  bronze.book_info
ALTER COLUMN title       TYPE TEXT,
ALTER COLUMN subtitle    TYPE TEXT,
ALTER COLUMN authors     TYPE TEXT,
ALTER COLUMN description TYPE TEXT;

ALTER TABLE bronze.book_info
ALTER COLUMN preview_link DROP NOT NULL,
ALTER COLUMN info_link    DROP NOT NULL,
ALTER COLUMN thumbnail    DROP NOT NULL;

SELECT COUNT(*) FROM bronze.book_info; -- 15147









