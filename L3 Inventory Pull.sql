SELECT

# Basic Item Details
B.r2d2_super_department_name,
B.r2d2_department_name, 
B.r2d2_category_name,
B.r2d2_sub_category_name,
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

# Forecast Information
A.network_weekly_forecast,
COALESCE(A.network_wos, 0) AS "network_wos", #exclude null values

# On hand information
sum(COALESCE(A.total_OH,0)) AS "Total_OH", #excluding null values
sum(Case when A.dc_id = '4364' then A.total_OH else 0 end) as LAX_OH,
sum(Case when A.dc_id = '4401' then A.total_OH else 0 end) as ATL_OH,
sum(Case when A.dc_id = '4900' then A.total_OH else 0 end) as DFW_OH,
sum(Case when A.dc_id = '6284' then A.total_OH else 0 end) as MCO_OH,
sum(Case when A.dc_id = '6559' then A.total_OH else 0 end) as IND_OH,
sum(Case when A.dc_id = '8302' then A.total_OH else 0 end) as PHL_OH,

# On order information
sum(COALESCE(A.dc_on_order,0)) AS "Total_OO", #excluding null values
sum(Case when A.dc_id = '4364' then A.dc_on_order else 0 end) as LAX_OO,
sum(Case when A.dc_id = '4401' then A.dc_on_order else 0 end) as ATL_OO,
sum(Case when A.dc_id = '4900' then A.dc_on_order else 0 end) as DFW_OO,
sum(Case when A.dc_id = '6284' then A.dc_on_order else 0 end) as MCO_OO,
sum(Case when A.dc_id = '6559' then A.dc_on_order else 0 end) as IND_OO,
sum(Case when A.dc_id = '8302' then A.dc_on_order else 0 end) as PHL_OO, 

# Earliest MABD information
MIN(A.earliest_mabd) AS "Earliest_mabd", #earliest MABD
Max(Case when A.dc_id = '4364' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as LAX_Earliest_MABD, #Max will give us a none 0 value
Max(Case when A.dc_id = '4401' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as ATL_Earliest_MABD, #Max will give us a none 0 value
Max(Case when A.dc_id = '4900' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as DFW_Earliest_MABD, #Max will give us a none 0 value
Max(Case when A.dc_id = '6284' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as MCO_Earliest_MABD, #Max will give us a none 0 value
Max(Case when A.dc_id = '6559' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as IND_Earliest_MABD, #Max will give us a none 0 value
Max(Case when A.dc_id = '8302' AND A.earliest_mabd is not null then A.earliest_mabd else 0 end) as PHL_Earliest_MABD, #Max will give us a none 0 value

# Inventory Value
A.cost * sum(COALESCE(A.total_OH,0)) AS "OH Cost Dollar Value",
A.price * sum(COALESCE(A.total_OH,0)) AS "OH Price Dollar Value",
A.price * A.network_weekly_forecast AS "Weekly GMV Forecast",

# Aged Inventory
C.trail90d_own_unit AS "Units Sold Last 90 Days",

# Snoozed Items
A.vendor_unavailability AS "Item Snoozed",
A.vendor_unavailability_end_date AS "Snooze End Date",

#More Details
A.start_date

# Data Source
FROM sims_analytics.item_node_level_instock_details A
	LEFT OUTER JOIN sims_analytics.uber_data B ON (A.item_id = B.item_id)
	LEFT OUTER JOIN sims_analytics.item_aggregated_sales C ON (A.item_id = C.item_id)
WHERE A.dc_id IN ('4364', '4401', '4900', '6284', '6559', '8302') # warehouse IDs
	AND B.r2d2_department_name IN ("Beauty") #Insert L2
	AND B.r2d2_category_name IN ("Cosmetics") #Insert L3
GROUP BY A.item_id