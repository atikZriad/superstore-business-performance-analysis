# Dataset setup

The project expects the Sample Superstore dataset to be imported into PostgreSQL as `public.superstore`.

The raw CSV is intentionally not included in this repository because its redistribution terms have not been verified. Use the dataset copy already available to you, and confirm its source/license before publishing or sharing it.

Expected columns (snake_case):
`row_id`, `order_id`, `order_date`, `ship_date`, `ship_mode`, `customer_id`, `customer_name`, `segment`, `country`, `city`, `state`, `postal_code`, `region`, `product_id`, `category`, `sub_category`, `product_name`, `sales`, `quantity`, `discount`, `profit`.

Recommended types: integer for row_id and quantity; date for order_date and ship_date; numeric for sales, discount, and profit; text for identifiers and dimensions. Preserve leading zeros in postal codes if your workflow requires them.

After import, run `sql/01_data_quality_and_validation.sql` first. If the actual table or column names differ, adjust the import mapping rather than modifying source values silently.
