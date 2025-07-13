from dotenv import load_dotenv
import pandas as pd
import os
from sqlalchemy import create_engine



load_dotenv()

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_SERVER = os.getenv("DB_SERVER")
DB_NAME = os.getenv("DB_NAME")


engine = create_engine(f'mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_SERVER}:3306/{DB_NAME}')

data_folder = "data"

for file in os.listdir(data_folder):
    if '.csv' in file:
        df = pd.read_csv('data/' + file)
        print(df.shape)
        


for filename in os.listdir(data_folder):
    if '.csv' in filename:
        table_name = filename.replace(".csv", "")
        file_path = os.path.join(data_folder, filename)

        print(f"Loading{filename} as table`{table_name}`...")
        df = pd.read_csv(file_path)
        df.to_sql(table_name, con=engine, if_exists='replace', index=False)

print("All csv files uploaded successfully")



