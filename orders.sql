--------------------------
select * from employees
--Display in descending order of seniority the male employees whose net salary (salary + commission) is greater than or equal to 8000. The resulting table should include the following columns: Employee Number, First Name and Last Name (using LPAD or RPAD for formatting), Age, and Seniority.

SELECT employee_number, LAST_NAME, FIRST_NAME, salary + commission AS salaire_total, 
       DATEDIFF(year, BIRTH_DATE, GETDATE()) AS age
FROM EMPLOYEES
WHERE title = 'MR.'
ORDER BY hire_date DESC;

---------------------------
select * from products
select * from order_details
select * from Customers
--Display products that meet the following criteria: (C1) quantity is packaged in bottle(s), (C2) the third character in the product name is 't' or 'T', (C3) supplied by suppliers 1, 2, or 3, (C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null). The resulting table should include the following columns: product number, product name, supplier number, units ordered, and unit price.

select product_name , product_ref, quantity,supplier_number,units_on_order, unit_price
from PRODUCTS

where quantity like '%bottles%'
and (SUBSTRING(PRODUCT_NAME,3,1)='t' or SUBSTRING(PRODUCT_NAME,3,1)='T')
and SUPPLIER_NUMBER in (1,2,3)
and UNIT_PRICE > 70 and UNIT_PRICE < 200
and units_on_order is not null
----------------------
select * from SUPPLIERS
--Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code. The query should utilize a single subquery. The resulting table should include all columns from the customer table.

select * from CUSTOMERS
where 
Country = (select country from suppliers where supplier_number= 1)
and city = (select city from suppliers where supplier_number = 1)
 AND RIGHT(postal_code, 3) = (SELECT RIGHT(postal_code, 3) FROM SUPPLIERS WHERE supplier_number = 1);
 
 ---------------------------
 -- For each order number between 10998 and 11003, do the following: Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise. \Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise. The resulting table should display the columns: order number, new discount rate, and discount rate application note.

select *, QUANTITY * unit_price as qv, 
 case
 when QUANTITY * unit_price between 0 and  2000 then 'O.5'
 when QUANTITY * unit_price between 2001 and  10000 then '5'
 when QUANTITY * unit_price between 10001 and  40000 then '10'
 WHEN QUANTITY * unit_price between 40001 and  80000 then '15'
 else '20'
 End as discount,
 CASE 
 when ORDER_NUMBER between 10998  and 11003 then 'apply the old discount rate'
 else 'apply new discount rate'
 end 
 as note
FROM order_details
 where ORDER_NUMBER between 10998 and 11003
 ----------------
-- Display suppliers of beverage products. The resulting table should display the columns: supplier number, company, address, and phone number.
select S.SUPPLIER_NUMBER, S.COMPANY, S.ADDRESS, S.phone, c.category_name
from SUPPLIERS S

INNER JOIN products p on S.supplier_number =  p.supplier_number
INNER JOIN CATEGORIES C on p.category_code = c.category_code
where
category_name like '%beverage%';

--------------------------------
select * from CUSTOMERS
select * from ORDER_DETAILS
select * from ORDERS
select * from CATEGORIES


--Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. The resulting table should display the column: customer code.
select C.customer_code 
from CUSTOMERS C
INNER JOIN ORDERS O ON C.customer_code = O.customer_code
INNER JOIN ORDER_DETAILS OD  on o.order_number = OD.order_number
INNER JOIN products p on OD.product_ref= p.product_ref
INNER JOIN categories cat on p.category_code = cat.category_code
where
Cat.CATEGORY_NAME ='desserts'
and C.city = 'Berlin'
group by c.customer_code
having count(OD.product_ref) <= 1

----------------------
---Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 (considering customers who haven't placed any orders yet). The resulting table should display the columns: customer number, company name, phone number, total amount, and country.
select c.customer_code, c.company, c.phone, c.country,SUM((od.quantity * od.unit_price)*1-discount) AS total
from CUSTOMERS C
left JOIN orders o  on c.customer_code = O.customer_code
left JOIN order_details OD on O.order_number = OD.order_number
where country = 'France'
and  o.order_date BETWEEN '1998-04-01' AND '1998-04-30'
            AND DATENAME(WEEKDAY, o.order_date) = 'LUNDI'
group by c.customer_code, c.company, c.phone, c.country
order by total desc;
------------------------------------------
---Display customers who have ordered all products. The resulting table should display the columns: customer code, company name, and telephone number.

select  c.customer_code, c.company, c.phone 
from  customers C
INNER JOIN orders o  on c.customer_code = O.customer_code
INNER JOIN order_details OD on O.order_number = OD.order_number
INNER JOIN  products P on od.product_ref= p.product_ref
group by c.customer_code, c.company, c.phone 
having count(distinct P.product_ref) = (select count(*) from products)
-------------------------------------------
--Display for each customer from France the number of orders they have placed. The resulting table should display the columns: customer code and number of orders.

select  c.customer_code, count(o.order_number) as total_order
from customers c
left JOIN orders o  on c.customer_code = O.customer_code
where country = 'France'
group by C.customer_code
order by total_order
------------------------------------------
--Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.


 SELECT 
    SUM(CASE WHEN YEAR(order_date) = 1996 THEN 1 ELSE 0 END) AS orders_in_1996,
    SUM(CASE WHEN YEAR(order_date) = 1997 THEN 1 ELSE 0 END) AS orders_in_1997,
    SUM(CASE WHEN YEAR(order_date) = 1997 THEN 1 ELSE 0 END) - 
    SUM(CASE WHEN YEAR(order_date) = 1996 THEN 1 ELSE 0 END) AS Difference
FROM 
    orders
WHERE 
    YEAR(order_date) IN (1996, 1997);


select * from PRODUCTS 
select * from order_details 
select * from orders
select * from customers

