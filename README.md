# Inventory and Sales Analysis

This query retrieves detailed inventory, sales, and forecasting information

## Features

### Data Collection:

**Basic Item Details:**
- Retrieves department, category, brand, vendor, item IDs, UPC, item name, cost, price, and other vendor-specific details.

**Forecast Information:**
- Includes network weekly forecast and weeks of supply (WOS).

**On Hand Information:**
- Calculates total on-hand inventory across various distribution centers (DCs).
- Provides a breakdown of on-hand inventory for each DC.

**On Order Information:**
- Calculates total items on order across various DCs.
- Provides a breakdown of items on order for each DC.

**Earliest Must Arrive By Date (MABD):**
- Identifies the earliest MABD for items and provides details for each DC.

**Inventory Value:**
- Calculates cost and price dollar values of on-hand inventory and weekly gross merchandise value (GMV) forecast.

**Aged Inventory:**
- Includes information about units sold in the last 90 days.

**Snoozed Items:**
- Indicates if an item is unavailable from the vendor and the expected end date for this unavailability.

**More Details:**
- Includes the item start date for additional context.

### Data Integration:
- Merges data from three tables:
  - `item_node_level_instock_details` (A)
  - `uber_data` (B)
  - `item_aggregated_sales` (C)
- Filters data to include specific warehouses and departments.
- Aggregates relevant information by grouping the results by item ID.

### Data Visualization:
- Summarizes key inventory and sales metrics for better decision-making and trend analysis.

## Results
- The analysis provides comprehensive insights into the inventory levels, sales trends, and forecasting details for the 'Beauty' and 'Cosmetics' categories.
- Helps identify potential supply chain issues and optimize inventory management strategies.

## Contact
For any questions or contributions, feel free to open an issue or contact me through my GitHub profile.
