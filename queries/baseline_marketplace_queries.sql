-- test
SELECT * FROM ProductCategory;

-- 1.i want my most frequent customers
SELECT c.customer_id,c.name,COUNT(o.order_id) AS total_orders
FROM customer c
JOIN `order` o ON c.customer_id=o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC;

-- 2.most popular products/ most sold products
SELECT p.product_id, p.name,SUM(oi.quantity) AS total_sold
FROM product p
JOIN orderitem oi ON p.product_id=oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;

-- 3.best reviewed products with at least 10 reviews/ avg rating per product
SELECT p.product_id, p.name, ROUND(AVG(r.rating),2) AS avg_rating, COUNT(r.review_id) AS num_reviews
FROM product p
JOIN review r ON p.product_id=r.product_id
GROUP BY p.product_id
HAVING COUNT(r.review_id)>=10
ORDER BY avg_rating DESC;

-- 4.average product rating per category
SELECT cat.category_name, ROUND(AVG(r.rating), 2) AS avg_rating, COUNT(r.review_id) AS review_count
FROM category cat
JOIN productcategory pc ON cat.category_id =pc.category_id
JOIN product p ON pc.product_id= p.product_id
JOIN review r ON p.product_id =r.product_id
GROUP BY cat.category_id
ORDER BY avg_rating DESC;

-- 5.monthly order volume/ order trend ocer time
SELECT year(order_date) as Year_,month(order_date) as Month_,COUNT(order_id) AS orders
FROM `Order`
GROUP BY Year_,Month_
order by Year_,Month_;

-- 6.monthly revenue trend from payments                     
SELECT YEAR(payment_date) AS year_, MONTH(payment_date) AS month_,ROUND(SUM(amount), 2) AS total_revenue
FROM payment
GROUP BY year_, month_
ORDER BY year_,month_;

-- 7.highest spending customers
SELECT c.customer_id,c.name,SUM(p.amount) AS total_spent
FROM customer c
JOIN `order` o ON c.customer_id=o.customer_id
JOIN payment p ON o.order_id=p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- 8.most reviewed categories
SELECT c.category_name,COUNT(r.review_id) AS total_reviews
FROM Category c
JOIN productcategory pc ON c.category_id=pc.category_id
JOIN product p ON pc.product_id =p.product_id
JOIN Review r ON p.product_id= r.product_id
GROUP BY c.category_id
ORDER BY total_reviews DESC;

-- 9.products that never sold
SELECT p.product_id,p.name
FROM product p
LEFT JOIN orderitem oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 10.customers placed the most orders in the last 6 months
SELECT c.customer_id, c.name, COUNT(o.order_id) as total_order
FROM Customer c
JOIN `Order` o ON c.customer_id=o.customer_id
WHERE o.order_date >= '2024-12-11'
GROUP BY(customer_id)
order by(total_order) DESC;

-- 11.the customers who have ordered the single most expensive product
SELECT DISTINCT c.customer_id,c.name,p.name as product_name, p.price
FROM Customer c
JOIN `order` o ON c.customer_id=o.customer_id
JOIN OrderItem oi ON o.order_id=oi.order_id
JOIN Product p ON oi.product_id=p.product_id
WHERE oi.product_id =(SELECT product_id
					  FROM product
		              WHERE price=(SELECT MAX(price) 
									 FROM product));

-- 12.the customers whose total spending is above the average spending of all customers
SELECT c.customer_id, c.name,SUM(p.amount) AS total_spent
FROM customer c
JOIN `order` o ON c.customer_id=o.customer_id
JOIN payment p ON o.order_id=p.order_id
GROUP BY c.customer_id
HAVING total_spent>(SELECT AVG(total_amount) 
					 FROM `order`);

-- 13.products with a price higher than the average price of all products
SELECT product_id,name,price
FROM product
WHERE price>(SELECT AVG(price)
			 FROM product)
ORDER BY price DESC;

-- 14.i want to show the avg_price to the above query- i tried with cross join
SELECT p.product_id,p.name,p.price,avg_table.avg_price
FROM product p
CROSS JOIN (SELECT AVG(price) AS avg_price 
			FROM product) 
            AS avg_table
WHERE p.price>avg_table.avg_price
ORDER BY p.price DESC;

-- 15.top products by total revenue(price*quantity)
SELECT p.product_id,p.name,total_revenue
FROM (SELECT product_id,SUM(price*quantity) AS total_revenue
      FROM OrderItem
      GROUP BY product_id) AS revenue_table
JOIN product p ON p.product_id=revenue_table.product_id
ORDER BY total_revenue DESC;

-- 16.all customers who have placed at least one order and write at least one review
SELECT c.customer_id,c.name
FROM customer c
WHERE EXISTS 
	(SELECT * 
	 FROM `order` o 
	 WHERE o.customer_id=c.customer_id
    ) AND 
    EXISTS 
    (SELECT * 
	 FROM review r 
	 WHERE r.customer_id= c.customer_id
    );

-- 17.products with same price
SELECT p1.name AS product_1,p2.name AS product_2,p1.price
FROM product p1
JOIN product p2 ON p1.price=p2.price AND p1.product_id<p2.product_id;

-- 18.top products reviewed by different customers
SELECT 
    r.product_id, 
    COUNT(DISTINCT r.customer_id) AS reviewer_count
FROM review r
GROUP BY r.product_id
ORDER BY reviewer_count DESC;

-- 19.most frequently bought product pair
SELECT oi1.product_id AS product_1,oi2.product_id AS product_2, COUNT(*) AS bought_together
FROM Orderitem oi1
JOIN Orderitem oi2 ON oi1.order_id=oi2.order_id AND oi1.product_id<oi2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY bought_together DESC;






