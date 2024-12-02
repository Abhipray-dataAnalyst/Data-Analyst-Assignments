use classicmodels;
show tables;

-- Q1

-- a

select employeeNumber, firstName, lastName from employees where jobtitle = "Sales Rep" and reportsTo = 1102;

-- b

select distinct productLine from products where productline like "%cars";
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Q2

SELECT 
    customerNumber,
    customerName,
    
    CASE
        WHEN country in ('USA','Canada') THEN 'North America'
        WHEN country in ('UK','France','Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment 
FROM
    customers;

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q3

select productCode, sum(quantityOrdered) as total_ordered from orderdetails group by productCode order by total_ordered desc limit 10;

-- b 

select monthname(paymentDate)payment_month, count(amount)num_payments from payments group by payment_month having num_payments>20 order by
monthname(paymentDate) desc;


--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q4

-- a

create database Customers_Orders;
use Customers_Orders;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY auto_increment,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

-- b

create table Orders(order_id int PRIMARY KEY auto_increment,
customer_id int,
order_date DATE,
total_amount DECIMAL(10,2),
foreign key (customer_id) references Customers(customer_id),
CHECK (total_amount >= 0)
);


------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5

use classicmodels;
Select country, COUNT(*) order_count
from Customers
join Orders on Customers.customerNumber = Orders.customerNumber
group by country
order by order_count desc
Limit 5;


----------------------------------------------------------------------------------------------------------------------------------------------------
-- 6

CREATE TABLE project (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50) NOT NULL,
    Gender CHAR(9),check (gender in ("Male","Female")),
    ManagerID INT
);
insert into project values 
(1,'Pranaya','Male',3),
(2,'Priyanka','Female',1),
(3,'Preety','Female', NULL),
(4,'Anurag','Male',	1),
(5,'Sambit','Male'	,1),
(6,'Rajesh','Male'	,3),
(7,'Hina','Female',	3);

Select m.Fullname Manager,e.Fullname Employee from project e
join project m on e.managerid = m.employeeid where
e.Fullname not in ('Preety', 'Pranaya');


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 7

create table facility(Facility_id int, Facility_Name varchar(100), State varchar(100),Country varchar(100));
alter table facility modify column Facility_id int auto_increment PRIMARY KEY;
alter table facility add column city varchar(100) not null after facility_name;
desc facility;


----------------------------------------------------------------------------------------------------------------------------------------------------
-- 8
CREATE VIEW ProductLineSales AS
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    Products p
JOIN 
    ProductLines pl ON p.productLine = pl.productLine
JOIN 
    OrderDetails od ON p.productCode = od.productCode
JOIN 
    Orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
    
select * from ProductLineSales;


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q9

DELIMITER //

CREATE PROCEDURE Get_country_payments(in inputYear int, in inputCountry varchar(50))
BEGIN
    select
        year(p.paymentDate) AS Year,
        c.country as Country,
        concat(format(SUM(p.amount)/1000, 0), 'K') AS 'Total Amount'
    from
        Payments p
    join
        Customers c on p.customerNumber = c.customerNumber
    where
        year(p.paymentDate) = inputYear and c.country = inputCountry
    group by 1,2;
END //

DELIMITER ;

call classicmodels.Get_country_payments(2003,"France");

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Q10

SELECT c.customerName, COUNT(*) AS order_count,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS order_frequency_rnk
FROM customers c
JOIN orders o ON c.customernumber = o.customernumber
GROUP BY c.customerName
ORDER BY order_count DESC;

-- b 

select
    year(orderDate) as 'Year',
    MonthName(orderDate) as 'Month',
    count(orderNumber) as 'Total Orders',
    concat(round(((count(orderNumber) - LAG(count(orderNumber),1) over()) / LAG(count(orderNumber), 1) over())*100), '%') as '% YoY Change'
from Orders
group by Year, Month;


select lag(count(ordernumber)) over() from orders;
select count(ordernumber) from orders;
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q11

SELECT productLine, COUNT(*) AS Total
FROM products
WHERE buyPrice > (
    SELECT AVG(buyPrice)
    FROM products
)
GROUP BY productLine
ORDER BY Total DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q12

use classicmodels;

Create table  Emp_EH (
    EmpID int primary key,
    EmpName varchar(30),
    EmailAddress varchar(30));
    
       
call classicmodels.EMPLOYEEDETAILS(1, 'john doe', 'john.doe@example.com');
call classicmodels.EMPLOYEEDETAILS(2, 'Niharika Rathod ', 'niharika.Rathod@example.com');
call classicmodels.EMPLOYEEDETAILS(1, 'jane smith', 'jane.smith@example.com');
call classicmodels.EMPLOYEEDETAILS(null, 'William Smith', 'William.Smith@example.com');


select * from emp_eh;
select * from insertdetails;

drop table emp_eh;

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q13

CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //
CREATE TRIGGER before_insert_emp_bit
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END;
//
DELIMITER ;

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Alice', 'Musician', '2023-05-20', -8);

SELECT * FROM Emp_BIT WHERE Name = 'Alice';