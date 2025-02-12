--SALES DATA TABLE DDL STATEMENT
CREATE TABLE sales_data (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    TransactionDate TIMESTAMP,
    TransactionAmount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    Quantity INT,
    DiscountPercent DECIMAL(5,2),
    City VARCHAR(100),
    StoreType VARCHAR(50),
    CustomerAge INT,
    CustomerGender VARCHAR(10),
    LoyaltyPoints INT,
    ProductName VARCHAR(100),
    Region VARCHAR(50),
    Returned VARCHAR(3),  -- Since it's "Yes/No", storing as VARCHAR
    FeedbackScore INT,
    ShippingCost DECIMAL(10,2),
    DeliveryTimeDays INT,
    IsPromotional VARCHAR(3)  -- Since it's "Yes/No"
);


--1.Feedback Comparison (i.e. Average Feedback score of the same product when bought from different channels (Store type)).
SELECT 
    ProductName, 
    StoreType, 
    ROUND(AVG(FeedbackScore),3) AS AvgFeedbackScore,
    COUNT(*) AS TotalTransactions
FROM sales_data
GROUP BY ProductName, StoreType
HAVING productname is not null and storetype is not null
ORDER BY ProductName, AvgFeedbackScore DESC;

--OUTPUT 1
"productname"	"storetype"	"avgfeedbackscore"	"totaltransactions"
"Apple"	        "In-Store"	    3.006	        44793
"Apple"	        "Online"	    3.001	        45177
"Laptop"	    "In-Store"	    3.003	        44867
"Laptop"	    "Online"	    2.990	        44942
"Notebook"	    "Online"	    3.009	        45251
"Notebook"	    "In-Store"	    2.996	        45043



-- 2. Product with Highest Return rate 
SELECT 
    ProductName, 
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS ReturnedOrders,
    ROUND((SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2)  AS ReturnRate
FROM sales_data
GROUP BY ProductName
ORDER BY returnrate DESC
LIMIT 1;
--OUTPUT 2
"productname"	"totalorders"	"returnedorders"	"returnrate"
   "Apple"	        89970	        45033	            50.05


--3  Most Popular Products by Sales Volume
SELECT 
    ProductName, 
    SUM(Quantity) AS TotalQuantitySold,
    SUM(TransactionAmount) AS TotalRevenue
FROM sales_data
GROUP BY ProductName
HAVING productname is not null
ORDER BY TotalQuantitySold DESC
LIMIT 10;   

--OUTPUT 3
"productname"	"totalquantitysold"	"totalrevenue"
"Apple"	             2296713	      22300717.86
"Notebook"	         498649	          24079586.12
"T-Shirt"	         270545	          102306079.47
"Laptop"	         89809	          6231220430.24
"Sofa"	             89740	          3777022903.56

--4 Top 3 preferred mode of payment on the basis of orders count.
SELECT PaymentMethod, COUNT(*) AS TotalOrders
FROM sales_data
GROUP BY PaymentMethod
ORDER BY TotalOrders DESC
LIMIT 3;

--OUTPUT 4
"paymentmethod"	"totalorders"
"Debit Card"	   113015
"Cash"	           112625
"UPI"	           112517

--5 Top 3 Cities in terms of orders count.
SELECT City, COUNT(*) AS TotalOrders
FROM sales_data
GROUP BY City
ORDER BY TotalOrders DESC
LIMIT 1;

--OUTPUT 5
"city"	    "totalorders"
"Bangalore"	    50319
"Delhi"	        50215
"Lucknow"	    50190


--6 Top customer in terms of orders count.
SELECT CustomerID, COUNT(*) AS TotalOrders
FROM sales_data
GROUP BY CustomerID
HAVING customerid is not null
ORDER BY TotalOrders DESC
LIMIT 1;

--OUTPUT 6
"customerid"	"totalorders"
39402	            24


--7 Orders count by Age Range
SELECT 
    CASE 
        WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
        WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
        WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
        WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
		WHEN CustomerAge IS NULL THEN '0'
        ELSE '60+'
    END AS AgeRange,
    COUNT(*) AS TotalOrders
FROM sales_data
GROUP BY AgeRange
ORDER BY TotalOrders DESC
LIMIT 5;

--OUTPUT 7
"agerange"	"totalorders"
"46-60"	        118833
"60+"	        110116
"36-45"	        79103
"26-35"	        79001
"18-25"     	62947