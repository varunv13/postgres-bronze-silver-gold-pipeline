import os
import pandas as pd
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

print(len(dataframe))