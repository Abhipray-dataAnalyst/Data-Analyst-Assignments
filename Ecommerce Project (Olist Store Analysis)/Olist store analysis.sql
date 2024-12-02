create database	olist_analysis;
use olist_analysis;


-- KPI 1:weekend vs weekday (order_purchase_timestamp) payment statistics
select 
    case when dayofweek(date_format(o.order_purchase_timestamp,'%y-%m-%d')) in (1,7) then 'weekend' else 'weekday' end as daytype,
    count(distinct o.order_id) as Totalorders,
    round(sum(p.payment_value)) as Totalpayments,
    round(avg(p.payment_value)) as Averagepayment
from 
    olist_orders_dataset as o
join
    olist_order_payments_dataset as p on o.order_id = p.order_id
 group by
     daytype;
     
     
    
    -- KPI2: Number of Orders with review score 5 and payment type as credit card.

select 
      count(distinct p.order_id) as NumberofOrders
from
    olist_order_payments_dataset as p
join
    olist_order_reviews_dataset as r on p.order_id = r.order_id
where   
     r.review_score = 5
    and p.payment_type = 'credit_card';  



-- KPI3 : Average number of days taken for order_delivered_customer_date for pet_shop

select
      p.product_category_name,
     avg(datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)) as avg_delivery_days
from
    olist_orders_dataset as o
join 
    olist_order_items_dataset as i on i.order_id = o.order_id
 join
     olist_products_dataset as p on p.product_id = i.product_id
 where
    p.product_category_name = 'pet_shop' and o.order_delivered_customer_date is not null
GROUP BY
    p.product_category_name;   
    
    
    
    
-- KPI4: Average price and payment values from customers of sao paulo city
SELECT
    AVG(oi.price) AS avg_order_price,
    AVG(op.payment_value) AS avg_payment_value
FROM
    olist_orders_dataset AS o
JOIN
    olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN
    olist_order_payments_dataset AS op ON o.order_id = op.order_id
JOIN
    olist_customers_dataset AS c ON o.customer_id = c.customer_id
WHERE
    c.customer_city = 'São Paulo';





-- KPI5: Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select	
rew.review_score,
round(avg(datediff(ords.order_delivered_customer_date,ords.order_purchase_timestamp)),0) as Avg_shipping_days
from 
olist_orders_dataset ords
join olist_order_reviews_dataset rew on rew.order_id = ords.order_id
group by rew.review_score
order by rew.review_score;





