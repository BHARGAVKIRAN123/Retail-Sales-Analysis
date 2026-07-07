import pandas as pd
from sqlalchemy import create_engine

# Read CSV
order_items = pd.read_csv("data/olist_order_items_dataset.csv")
order_items.rename(
    columns={"order_item_id": "order_item"},
    inplace=True
)

# Convert date column
order_items["shipping_limit_date"] = pd.to_datetime(
    order_items["shipping_limit_date"],
    errors="coerce"
)

# Connect to MySQL
engine = create_engine(
    "mysql+pymysql://root:root@localhost/retail_sales"
)

# Import data
order_items.to_sql(
    name="order_items",
    con=engine,
    if_exists="append",
    index=False
)

print("Order items imported successfully!")
