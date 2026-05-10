DROP TABLE IF EXISTS zepto;

create table zepto(
category VARCHAR(120),
name varchar(150),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

select count(*) from zepto;

-- data exploration

-- sample data 
SELECT * FROM zepto
limit 10 ;

-- null values

SELECT * FROM zepto
WHERE name is null
or
category is null
or
mrp is null
or
discountPercent is null
or
discountSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outOfstock is null
or
quantity is null;

-- different product categories

SELECT DISTINCT category
from zepto
ORDER BY category;


-- create primary key
ALTER TABLE zepto
ADD COLUMN id SERIAL PRIMARY KEY;

-- products in stock vs out of stock

SELECT outOfStock, COUNT(id)
FROM zepto
GROUP BY outOfStock;


-- product names present multiple times

SELECT name, COUNT(id) as "no_of_id"
from zepto
GROUP BY name
HAVING count(id)>1
ORDER BY count(id) desc;


-- data cleaning

-- products with price 0

SELECT * FROM zepto
where mrp = 0 or discountSellingPrice = 0;

DELETE FROM zepto
where mrp = 0;

--convert paisa to rupees

UPDATE zepto
SET mrp = mrp /100.0,
discountSellingPrice = discountSellingPrice/100.0;

select mrp, discountSellingPrice from zepto;



-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountPercent
from zepto
ORDER BY discountPercent Desc
limit 10;


--Q2.What are the Products with High MRP but Out of Stock


select distinct name, mrp
from zepto
where outOfStock = True and mrp >300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category


SELECT category,
SUM(discountSellingPrice*availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.


SELECT DISTINCT name, mrp, discountPercent
from zepto
where mrp>500 and discountPercent <10
order by mrp desc, discountPercent desc;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select category,
Round(AVG(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;




-- Q6. Find the price per gram for products above 100g and sort by best value.


select DISTINCT name, weightInGms, discountSellingPrice,
Round(discountSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >=100
order by price_per_gram;



--Q7.Group the products into categories like Low, Medium, Bulk.


SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
WHEN weightInGms <5000 THEN 'Medium'
else 'Bulk'
END AS weight_category
from zepto;


--Q8.What is the Total Inventory Weight Per Category 


SELECT category,
SUM(weightInGms * availableQuantity) as total_weight
from zepto
GROUP BY category
ORDER BY total_weight;






