USE customer_behavior;
SELECT 
    *
FROM
    customer;

-- Toatal Revenue By Gender
SELECT 
    gender, SUM(purchase_amount) AS revenue
FROM
    customer
GROUP BY gender;

-- Customers used a discount but stil spent more than average purchase amont
SELECT 
    customer_id, purchase_amount
FROM
    customer
WHERE
    discount_applied = 'yes'
        AND purchase_amount >= (SELECT 
            AVG(Purchase_Amount)
        FROM
            customer);

-- Top 5 products with highest average review rating
SELECT 
    item_purchased,
    ROUND(AVG(review_rating), 2) AS 'Average Product rating'
FROM
    customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- Compare the average amount between Standard and Express Shipping
SELECT 
    shipping_type, ROUND(AVG(purchase_amount), 2)
FROM
    customer
GROUP BY shipping_type
HAVING Shipping_Type IN ('Standard' , 'Express');

-- Compare the average spends and total revenue between subscribers and non-subscribers

SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customer,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM
    customer
GROUP BY subscription_status;

-- Top 5 products have the highest percentage of purchase with discount applied

SELECT 
    item_purchased,
    ROUND(SUM(CASE
                WHEN discount_applied = 'yes' THEN 1
                ELSE 0
            END) / COUNT(*) * 100) AS discount_rate
FROM
    customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Segment customer into new 
with customer_type as(
	select customer_id , previous_purchases , 
	case when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal' end as customer_segment
	from customer)

SELECT 
    customer_segment, COUNT(*) AS 'Numberr of Customers'
FROM
    customer_type
GROUP BY customer_segment;

-- Top 3 most purchased products in each category
with item_counts as (
select category , item_purchased , 
count(customer_id) as total_orders , 
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category , item_purchased
)
SELECT 
    item_rank, category, item_purchased, total_orders
FROM
    item_counts
WHERE
    item_rank <= 3;
    
-- Customers who are repeats buyers also likely to subscribe
SELECT 
    subscription_status, COUNT(customer_id) AS repeat_buyers
FROM
    customer
WHERE
    Previous_Purchases >= 5
GROUP BY subscription_status;

-- Revenue contribution of each age group
SELECT 
    age_group,
    COUNT(customer_id) AS total_customer,
    SUM(purchase_amount) AS Revenue
FROM
    customer
GROUP BY age_group;


