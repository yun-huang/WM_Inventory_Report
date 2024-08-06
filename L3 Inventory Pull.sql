SELECT

-- Basic Item Details
B.super_department_name AS r2d2_super_department_name,
B.department_name AS r2d2_department_name, 
B.category_name AS r2d2_category_name,
B.sub_category_name AS r2d2_sub_category_name,
A.brand,
A.vendor_name,
A.item_id,
A.upc,
A.walmart_item_num,
A.item_name,
A.is_replen,
A.replen_type,
A.end_date,
A.sortable,
A.cost,
A.price,
B.vendor_pack_qty,
A.mirror_num,
B.shipping_tier,
B.buy_in,
B.is_orderable,
B.orderable_reason_code,
A.display_status,
B.geo_item_class,

-- Forecast Information
A.network_weekly_forecast,
COALESCE(A.network_wos, 0) AS "network_wos", -- exclude null values

-- On hand information
SUM(COALESCE(A.total_OH, 0)) AS "Total_OH", -- excluding null values
SUM(CASE WHEN A.dc_id = 'DC1' THEN A.total_OH ELSE 0 END) AS WH1_OH,
SUM(CASE WHEN A.dc_id = 'DC2' THEN A.total_OH ELSE 0 END) AS WH2_OH,
SUM(CASE WHEN A.dc_id = 'DC3' THEN A.total_OH ELSE 0 END) AS WH3_OH,
SUM(CASE WHEN A.dc_id = 'DC4' THEN A.total_OH ELSE 0 END) AS WH4_OH,
SUM(CASE WHEN A.dc_id = 'DC5' THEN A.total_OH ELSE 0 END) AS WH5_OH,
SUM(CASE WHEN A.dc_id = 'DC6' THEN A.total_OH ELSE 0 END) AS WH6_OH,

-- On order information
SUM(COALESCE(A.dc_on_order, 0)) AS "Total_OO", -- excluding null values
SUM(CASE WHEN A.dc_id = 'DC1' THEN A.dc_on_order ELSE 0 END) AS WH1_OO,
SUM(CASE WHEN A.dc_id = 'DC2' THEN A.dc_on_order ELSE 0 END) AS WH2_OO,
SUM(CASE WHEN A.dc_id = 'DC3' THEN A.dc_on_order ELSE 0 END) AS WH3_OO,
SUM(CASE WHEN A.dc_id = 'DC4' THEN A.dc_on_order ELSE 0 END) AS WH4_OO,
SUM(CASE WHEN A.dc_id = 'DC5' THEN A.dc_on_order ELSE 0 END) AS WH5_OO,
SUM(CASE WHEN A.dc_id = 'DC6' THEN A.dc_on_order ELSE 0 END) AS WH6_OO,

-- Earliest MABD information
MIN(A.earliest_mabd) AS "Earliest_mabd", -- earliest MABD
MAX(CASE WHEN A.dc_id = 'DC1' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH1_Earliest_MABD, -- Max will give us a non-0 value
MAX(CASE WHEN A.dc_id = 'DC2' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH2_Earliest_MABD, -- Max will give us a non-0 value
MAX(CASE WHEN A.dc_id = 'DC3' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH3_Earliest_MABD, -- Max will give us a non-0 value
MAX(CASE WHEN A.dc_id = 'DC4' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH4_Earliest_MABD, -- Max will give us a non-0 value
MAX(CASE WHEN A.dc_id = 'DC5' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH5_Earliest_MABD, -- Max will give us a non-0 value
MAX(CASE WHEN A.dc_id = 'DC6' AND A.earliest_mabd IS NOT NULL THEN A.earliest_mabd ELSE 0 END) AS WH6_Earliest_MABD, -- Max will give us a non-0 value

-- Inventory Value
A.cost * SUM(COALESCE(A.total_OH, 0)) AS "OH Cost Dollar Value",
A.price * SUM(COALESCE(A.total_OH, 0)) AS "OH Price Dollar Value",
A.price * A.network_weekly_forecast AS "Weekly GMV Forecast",

-- Aged Inventory
C.trail90d_own_unit AS "Units Sold Last 90 Days",

-- Snoozed Items
A.vendor_unavailability AS "Item Snoozed",
A.vendor_unavailability_end_date AS "Snooze End Date",

-- More Details
A.start_date

-- Data Source
FROM dummy_analytics.item_node_level_instock_details A
LEFT OUTER JOIN dummy_analytics.uber_data B ON (A.item_id = B.item_id)
LEFT OUTER JOIN dummy_analytics.item_aggregated_sales C ON (A.item_id = C.item_id)
WHERE A.dc_id IN ('DC1', 'DC2', 'DC3', 'DC4', 'DC5', 'DC6') -- warehouse IDs
AND B.department_name IN ('Beauty') -- Insert L2
AND B.category_name IN ('Cosmetics') -- Insert L3
GROUP BY A.item_id;
