# DWD SAP Sales Cartons Query

## Overview
This SQL query extracts and analyzes hourly sales carton data from SAP. It processes real sales transactions alongside forecasted sales data to provide insights into order trends, warehouse operations, and customer demand.

## Key Features
- **Common Table Expressions (CTEs):**
  - `vbak`: Extracts sales orders with timestamps and filters for relevant order types.
  - `vbap`: Retrieves sales order details, including product and quantity.
  - `sales_data`: Merges sales orders and their respective details.
  - `min_max_zcrd` & `min_max_zfre`: Identifies order ID ranges for filtering customer records.
  - `vbpa`: Links sales orders with customer and supplier information.
  - `forecast_data`: Integrates projected sales data from an external source.
- **Data Enrichment & Transformations:**
  - Extracts the **hour** of the transaction and categorizes it as **Morning/Afternoon**.
  - Joins **real sales data** with **forecasted data** for comparative analysis.
  - Creates a **distinct key** to uniquely identify each sales order item.

## How It Works
1. **Extracts** real sales data from SAP (`vbak`, `vbap`, `vbpa`).
2. **Joins** sales orders with product and warehouse data.
3. **Categorizes** sales transactions based on time of day (morning/afternoon).
4. **Filters & Cleans** sales data using supplier/customer conditions.
5. **Combines** real sales data with external forecast data for comparative insights.
6. **Outputs** a final dataset containing both real and forecasted sales trends.

## Use Cases
- **Sales Performance Analysis:** Understanding order trends by hour and warehouse.
- **Forecast Accuracy Evaluation:** Comparing real vs. projected sales figures.
- **Warehouse & Logistics Planning:** Identifying peak sales periods for resource allocation.
- **Customer & Supplier Tracking:** Linking sales orders to specific vendors and buyers.

## Technologies Used
- SQL (BigQuery or similar syntax)
- SAP Data Extraction (Tables: `vbak`, `vbap`, `vbpa`)
- External Data Source (`excel_sheet.forecast_1week_salescartons`)

## Contribution
Potential improvements include:
- Refining **forecasting** logic for better predictions.
- Enhancing **supplier/customer segmentation**.
- Optimizing **query performance** by indexing key fields.