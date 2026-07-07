import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:root@localhost/retail_sales"
)

payments = pd.read_csv("data/olist_order_payments_dataset.csv")

print("Total Rows:", len(payments))
print(payments.head())

payments.to_sql(
    "payments",
    con=engine,
    if_exists="append",
    index=False
)

print("Payments imported successfully!")