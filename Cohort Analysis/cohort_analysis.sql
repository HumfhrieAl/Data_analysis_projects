SELECT 
  u.first_name AS firstName,
  u.last_name AS lastName,
  u.id AS customerID,
  u.country AS country,
  u.latitude AS latitude,
  u.longitude AS longitude,
  u.gender AS gender,
  u.created_at AS customerCreationDate,
  oi.order_id AS orderID,
  oi.created_at AS orderCreationDate,
  oi.status AS status,
  ROUND(p.retail_price, 1) AS unitSellingPrice,
  ROUND(p.cost, 1) AS unitCostPrice,
  p.name AS productName,
  p.category AS productCategory,
  ROUND(p.retail_price - p.cost, 1) AS unitProfit,
  oi.sale_price AS salePrice,
  dc.name AS distributionCentres,
  dc.latitude AS distibutionCentreLatitude,
  dc.longitude AS distributionCentreLongitude,
  row_number() over (partition by u.id order by oi.created_at asc) AS transactionNumber
FROM
  `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN
  `bigquery-public-data.thelook_ecommerce.users` u
ON
  oi.user_id = u.id
LEFT JOIN
  `bigquery-public-data.thelook_ecommerce.products` p
ON
  oi.product_id = p.id
LEFT JOIN
  `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
ON
  p.distribution_center_id = dc.id
