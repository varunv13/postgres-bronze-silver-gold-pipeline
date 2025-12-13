import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# loads the environment variables from the .env file
load_dotenv()

# accessing the variables in the .env file
host=os.getenv("DB_HOST")
database=os.getenv("DB_NAME")
user=os.getenv("DB_USER")
password=os.getenv("DB_PASS")
port=os.getenv("DB_PORT")

# # reading the CSV file using pandas
dataframe = pd.read_csv("google_books_dataset.csv", dtype=str)

# # where ever is emptiness, replace it with Null
dataframe = dataframe.replace({"": None, "NaN": None})

# # type conversion for those fields which are INT, FLOAT type in table
dataframe["page_count"] = pd.to_numeric(dataframe["page_count"], errors="coerce")
dataframe["average_rating"] = pd.to_numeric(dataframe["average_rating"], errors="coerce")
dataframe["ratings_count"] = pd.to_numeric(dataframe["ratings_count"], errors="coerce")
dataframe["list_price"] = pd.to_numeric(dataframe["list_price"], errors="coerce")

engine = create_engine(
    f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
)

# loading the data into the table
dataframe.to_sql(
    name="book_info",
    con=engine,
    schema="bronze",
    if_exists="append",
    index=False,
    chunksize=1000,
    method="multi"
)

print("Data loading completed")

