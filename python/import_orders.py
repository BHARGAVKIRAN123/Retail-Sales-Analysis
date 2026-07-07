import pandas as pd
from sqlalchemy import create_engine

# Read CSV
orders = pd.read_csv("data/olist_orders_dataset.csv")

# Convert datetime columns
date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for col in date_columns:
    orders[col] = pd.to_datetime(orders[col], errors="coerce")

# Connect to MySQL
engine = create_engine(
    "mysql+pymysql://root:root@localhost/retail_sales"
)

# Import into MySQL
orders.to_sql(
    name="orders",
    con=engine,
    if_exists="append",
    index=False
)

print("Orders imported successfully!")