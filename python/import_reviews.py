# import pandas as pd
# from sqlalchemy import create_engine

# # Read CSV
# reviews = pd.read_csv("data/olist_order_reviews_dataset.csv")

# print(reviews.columns.tolist())
# # Convert date columns
# reviews["review_creation_date"] = pd.to_datetime(
#     reviews["review_creation_date"],
#     errors="coerce"
# )

# reviews["review_answer_timestamp"] = pd.to_datetime(
#     reviews["review_answer_timestamp"],
#     errors="coerce"
# )

# # Connect to MySQL
# engine = create_engine(
#     "mysql+pymysql://root:root@localhost/retail_sales"
# )

# # Import into MySQL
# reviews.to_sql(
#     "reviews",
#     con=engine,
#     if_exists="append",
#     index=False
# )

# print("Reviews imported successfully!")
import pandas as pd

products = pd.read_csv("data/olist_products_dataset.csv")
print(products.columns.tolist())
